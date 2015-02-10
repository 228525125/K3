--其他入库时，入库人显示制单人姓名
--DROP TRIGGER IC_QTRK_RKR 

CREATE TRIGGER IC_QTRK_RKR ON ICStockBill
After INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM inserted where FTranType=10)       
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted
UPDATE v1 set v1.FHeadSelfA9736=us.FDescription FROM ICStockBill v1 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
where v1.FTranType=10 and v1.FCancellation = 0
AND v1.FInterID=@FInterID
END