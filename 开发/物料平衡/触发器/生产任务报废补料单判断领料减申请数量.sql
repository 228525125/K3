--此触发器在生产任务报废补料单时，判断已领料数量-报废数量 < 入库总数*单位用量
--DROP TRIGGER IC_SCRWBFD

CREATE TRIGGER IC_SCRWBFD ON ICItemScrap    
FOR INSERT,UPDATE
AS
BEGIN
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICItemScrapEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN ICMO f on b.FICMOInterID=f.FInterID
	LEFT JOIN t_ICItem g on f.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND((c.FDiscardAuxQty-b.FQty)/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(f.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --已领料数量-已报废数量-当前报废 < 入库总数*单位用量 
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
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
	LEFT JOIN ICMO f on b.FICMOInterID=f.FInterID
	LEFT JOIN t_ICItem g on f.FItemID=g.FItemID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0) < case when g.FProChkMde=352 then ISNULL(f.FAuxStockQty,0) else ISNULL(e.FQty,0) end         --已领料数量-报废数量 < 入库总数*单位用量   f.qty退料废库的红字领料数量，因为之前红字领料与报废单重复了，这种情况从2013-06-26日开始改过来
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

