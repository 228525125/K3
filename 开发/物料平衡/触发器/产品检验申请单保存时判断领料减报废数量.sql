--此触发器在产品检验申请时，判断送检数量>领料数量-报废数量
--DROP TRIGGER IC_CPJYSQD

CREATE TRIGGER IC_CPJYSQD ON QMICMOCKRequest    
FOR INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  QMICMOCKRequestEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on a.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=c.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	WHERE 1=1     
	and (
		(c.FQtyMust>=c.FQtyPick and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0)+ROUND(ISNULL(-f.FQty,0)/c.FAuxQtyScrap,0) < e.FQty)  --计划投料数量 >= 应发数量    已领料数量-报废数量 < 入库总数*单位用量   f.qty退料废库的红字领料数量，因为之前红字领料与报废单重复了，这种情况从2013-06-26日开始改过来
	    	or 
		(c.FQtyMust<c.FQtyPick  and  c.FQtyMust>c.FAuxStockQty)   --计划投料数量 < 应发数量，就必须全部领完，因为有时会临时修改投料单
	)                         
	and left(d.FNumber,3)<>'08.'                        --不考虑包装材料
	and c.FAuxQtyScrap > 0                              --单位用量必须大于0
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049'      --不考虑外购称重的半成品
)
BEGIN
DECLARE @test nvarchar(255)
SELECT @test=ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(c.FDiscardAuxQty/c.FAuxQtyScrap,0)+ROUND(ISNULL(-f.FQty,0)/c.FAuxQtyScrap,0)-(e.FQty-b.FQty) FROM inserted a 
	INNER JOIN  QMICMOCKRequestEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on a.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 	
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and a.FDate<'2013-06-26' group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=c.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	WHERE 1=1 
	and ROUND(c.FAuxStockQty/c.FAuxQtyScrap,0)-ROUND(FDiscardAuxQty/c.FAuxQtyScrap,0)+ROUND(ISNULL(-f.FQty,0)/c.FAuxQtyScrap,0) < e.FQty         --已领料数量-报废数量 < 入库总数*单位用量   f.qty退料废库的红字领料数量，因为之前红字领料与报废单重复了，这种情况从2013-06-26日开始改过来
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	and c.FAuxQtyScrap > 0                              --单位用量必须大于0
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and d.FNumber <> '06.07.0135' and d.FNumber<>'06.07.0045' and d.FNumber<>'06.07.0040' and d.FNumber<>'06.04.0049'      --不考虑外购称重的半成品

exec('送检数量_大于_领料数量_减_报废_'+@test) 
END 






(select v1.FICMOInterID,sum(u1.FQty) from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) 




--select (c.FAuxStockQty/c.FAuxQtyScrap) as '已领',(FDiscardAuxQty/c.FAuxQtyScrap) as '报废',(-f.FQty) as '退料',e.FQty as '入库' 
select (c.FAuxStockQty) as '已领',(FDiscardAuxQty) as '报废',(-f.FQty) as '退料',e.FQty* c.FAuxQtyScrap as '入库' 
	FROM QMICMOCKRequest a 
	INNER JOIN  QMICMOCKRequestEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on a.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	LEFT JOIN (select v1.FICMOInterID,sum(u1.FQty) as FQty from QMICMOCKRequest v1 INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 group by v1.FICMOInterID) e on e.FICMOInterID=c.FICMOInterID 	
	LEFT JOIN (select b.FICMOInterID,b.FPPBomEntryID,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 /*and a.FDate<'2013-06-26'*/ group by b.FICMOInterID,b.FPPBomEntryID) f on f.FICMOInterID=c.FICMOInterID and c.FEntryID=f.FPPBomEntryID
	WHERE 1=1 
	--and c.FAuxStockQty-c.FDiscardAuxQty+(-f.FQty) < (e.FQty+7) * c.FAuxQtyScrap         --已领料数量-报废数量 < 入库总数*单位用量 
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	--and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and c.FICMOInterID=25135


select * from ICMO where FBillNo='work024004'

select * from PPBOM a left join PPBOMEntry b on a.FInterID=b.FInterID where a.FBillNo='PBOM000164'


select v1.* from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=24 AND v1.FCancellation = 0 AND v1.FStatus = 1 AND FROB=-1
and v1.FBillNo='SOUT020648'

FSCStockID

select * from t_stock where FItemID='5272'

select * from ICMO where FBillNo IN ('WORK000303','WORK000304')
1331
1332

FCheckCommitQty

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo IN ('WORK023816')


23816

select FCheckCommitQty,* from ICMO where FBillNo like '%23816%'