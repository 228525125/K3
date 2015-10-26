--此触发器在生产任务报废补料单时，判断已领料数量-报废数量 < 入库总数*单位用量   / 通过产品数量折算子物料数量
--DROP TRIGGER IC_SCRWBFD

CREATE TRIGGER IC_SCRWBFD ON ICItemScrap    
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON

UPDATE b SET b.FQty=b.FEntrySelfZ0632*c.FAuxQtyScrap,b.FAuxQty=b.FEntrySelfZ0632*c.FAuxQtyScrap
FROM inserted a 
INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID and b.FSourceEntryID=c.FEntryID
WHERE b.FUnitID=173         --计量单位为kg

IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=b.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=b.FICMOInterID and c.FEntryID=k.FPPBomEntryID
	LEFT JOIN ICMO o on b.FICMOInterID=o.FInterID
	LEFT JOIN t_ICItem g on o.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) -ROUND((c.FDiscardAuxQty+b.FQty)/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(o.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --已领料数量-已报废数量-当前报废 < 入库总数*单位用量 
	and left(d.FNumber,3)<>'08.'                                       --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and c.FItemID=b.FItemID            --判断具体到一项物料
	and a.FStatus=0                    --单据保存时判断
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --不考虑外购称重的半成品
)
RAISERROR (50021,16,1 )

IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=b.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=b.FICMOInterID and c.FEntryID=k.FPPBomEntryID
	LEFT JOIN ICMO o on b.FICMOInterID=o.FInterID
	LEFT JOIN t_ICItem g on o.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) -ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(o.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --已领料数量-报废数量 < 入库总数*单位用量  
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and c.FItemID=b.FItemID            --判断具体到一项物料
	and a.FStatus=1                    --单据审核时判断，因为审核时c.FDiscardAuxQty包含本次报废数量
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'      --不考虑外购称重的半成品
)
RAISERROR (50021,16,1 )


END



select b.* from ICItemScrap a left join ICItemScrapEntry b on a.FInterID=b.FInterID





	SELECT c.FAuxStockQty,b.FQty,e.FQty,c.FAuxQtyScrap FROM ICItemScrap a 
	INNER JOIN ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	WHERE 1=1 
	--and c.FAuxStockQty-c.FDiscardAuxQty-b.FQty < e.FQty * c.FAuxQtyScrap         --已领料数量-报废数量 < 入库总数*单位用量 
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and c.FItemID=b.FItemID
	and a.FBillNo='FSC003353'




SELECT 
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) as '领料', 
ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) as '退料',
ROUND((c.FDiscardAuxQty-b.FQty)/c.FAuxQtyScrap,0) as '报废', 
case when g.FProChkMde=352 then ISNULL(o.FAuxStockQty,0) else ISNULL(e.FQty,0) end as '申请/入库'
FROM ICItemScrap a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2013-06-26' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=b.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=b.FICMOInterID and c.FEntryID=k.FPPBomEntryID
	LEFT JOIN ICMO o on b.FICMOInterID=o.FInterID
	LEFT JOIN t_ICItem g on o.FItemID=g.FItemID
	WHERE 1=1 
--	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) -ROUND((c.FDiscardAuxQty-b.FQty)/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(o.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --已领料数量-已报废数量-当前报废 < 入库总数
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and c.FItemID=b.FItemID            --判断具体到一项物料
	--and a.FStatus=0                    --单据保存时判断
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --不考虑外购称重的半成品
	and a.FBillNo='FSC006001'




select FStockQty,FAuxStockQty,FAuxCommitQty,FCommitQty,* from ICMO where FBillNo in ('WORK036152','WORK036283','WORK036312')



SELECT 
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0),
ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0),
ROUND((c.FDiscardAuxQty)/c.FAuxQtyScrap,0),
ROUND((-b.FQty)/c.FAuxQtyScrap,0),
case when g.FProChkMde=352 then ISNULL(o.FAuxStockQty,0) else ISNULL(e.FQty,0) end,
ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) -ROUND((c.FDiscardAuxQty+b.FQty)/c.FAuxQtyScrap,0)
 FROM ICItemScrap a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate>='2015-02-01' and b.FSCStockID=5272 group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=b.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FICMOInterID,b.FPPBomEntryID) k on k.FICMOInterID=b.FICMOInterID and c.FEntryID=k.FPPBomEntryID
	LEFT JOIN ICMO o on b.FICMOInterID=o.FInterID
	LEFT JOIN t_ICItem g on o.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0) + ROUND((ISNULL(-f.FQty,0)+ISNULL(-k.FQty,0))/c.FAuxQtyScrap,0) -ROUND((c.FDiscardAuxQty+b.FQty)/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(o.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --已领料数量-已报废数量-当前报废 < 入库总数*单位用量 
	and left(d.FNumber,3)<>'08.'                                       --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and c.FItemID=b.FItemID            --判断具体到一项物料
	and a.FStatus=0                    --单据保存时判断
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040'    --不考虑外购称重的半成品
	and a.FBillNo='FSC006883'


select 
ROUND((-b.FQty)/c.FAuxQtyScrap,0),
c.FAuxQtyScrap,
(-b.FQty) FROM ICItemScrap a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
where 1=1
	and a.FBillNo='FSC006883'


select b.FBatchNo,* 
FROM ICItemScrap a 
INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
where 1=1
and a.FBillNo='FSC006853'

update b set b.FBatchNo='11K06' FROM ICItemScrap a 
INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
where 1=1
and a.FBillNo='FSC006853'


