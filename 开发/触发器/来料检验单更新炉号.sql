--DROP TRIGGER IC_LLJYD_LUHAO

CREATE TRIGGER IC_LLJYD_LUHAO ON ICQCBill
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM inserted where FTranType=711)       
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted
UPDATE v1 SET v1.FHeadSelft1256=u1.FEntrySelfT0241 FROM ICQCBill v1 
LEFT JOIN POInstockEntry u1 ON v1.FInStockInterID=u1.FInterID and v1.FSerialID=u1.FEntryID
WHERE 1=1 
AND (v1.FTranType=711) 
AND u1.FEntrySelfT0241 is not null
AND v1.FInterID=@FInterID
END 

