--生产领料单记录成本对象图号
--DROP TRIGGER IC_SCLL_CBDXTH

CREATE TRIGGER IC_SCLL_CBDXTH ON ICStockBill
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM inserted where FTranType=24)       
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted
UPDATE u1 set u1.FEntrySelfB0450=i.FHelpCode 
FROM inserted v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN cbCostObj cb on u1.FCostOBJID=cb.FItemID
INNER JOIN t_ICItem i on cb.FNumber=i.FNumber
WHERE 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FInterID=@FInterID
END 





select FEntrySelfB0450,u1.FCostOBJID,i.*
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN cbCostObj cb on u1.FCostOBJID=cb.FItemID
INNER JOIN t_ICItem i on cb.FNumber=i.FNumber
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FBillNo='SOUT033548'




select * from t_ICItem

select * from cb_CostObj_Product



update u1 set u1.FEntrySelfB0450=1 from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FBillNo='SOUT033548'