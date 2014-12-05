--此触发器在产品入库时，判断入库产品对应的投料单是否已领料完毕
--DROP TRIGGER IC_CPRKKZ

CREATE TRIGGER IC_CPRKKZ ON ICStockBill    
FOR INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN  ICStockBillEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	INNER JOIN ICMO e on b.FICMOInterID=e.FInterID 
	WHERE a.FTranType=2 
	and c.FAuxStockQty < (e.FStockQty+b.FQty) * c.FAuxQtyScrap         --已领料数量 < 入库总数*单位用量 
	and left(d.FNumber,3)<>'08.'                            --不考虑包装材料
	and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947)  --计量单位没有小数点的
	and d.FErpClsID=2                                       --只考虑自制材料
)
BEGIN
DECLARE @test nvarchar(255)
SELECT @test = b.FEntryID FROM inserted a 
	INNER JOIN  ICStockBillEntry b on a.FInterID=b.FInterID 
	INNER JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID 
	LEFT JOIN t_ICItem d on c.FItemID=d.FItemID 
	INNER JOIN ICMO e on b.FICMOInterID=e.FInterID 
	WHERE a.FTranType=2        
	and c.FAuxStockQty < (e.FStockQty+b.FQty) * c.FAuxQtyScrap    
	and left(d.FNumber,3)<>'08.'                        
	and c.FUnitID in (179,181,183,185,187,189,214,227,334,338,5947) 
	and d.FErpClsID=2                                     
exec('部分产品未执行完生产领料_请检查第'+@test+'行')
END 



exec('请检查生产领料_请检查第'+'1行')

select * from ICStockBillEntry

SELECT e.FBillNo,d.FNumber+'/'+d.FName,c.FAuxStockQty,e.FStockQty,c.FAuxQtyScrap,b.FQty FROM ICStockBill a 
LEFT JOIN ICStockBillEntry b on a.FInterID=b.FInterID
LEFT JOIN PPBOMEntry c on b.FICMOInterID=c.FICMOInterID
LEFT JOIN t_ICItem d on c.FItemID=d.FItemID
LEFT JOIN ICMO e on b.FICMOInterID=e.FInterID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=c.FUnitID 
where a.FTranType=2
--and c.FAuxStockQty < e.FStockQty*c.FAuxQtyScrap
and e.FBillNo='WORK000304'

SELECT * FROM ICMO

select u1.* from PPBOM v1 
INNER JOIN PPBOMEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0 

select * from t_MeasureUnit where FItemID in (179,181,183,185,187,189,214,227,334,338,5947)