--产品检验单写入抽检比例和说明
--DROP TRIGGER IC_CPJJD_CJBL

CREATE TRIGGER IC_CPJJD_CJBL ON ICQCBill
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)       
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted
UPDATE a SET a.FHeadSelfT1466=d.FHeadSelfQCS26 
FROM ICQCBill a
LEFT JOIN ICQCBillEntry b ON a.FInterID=b.FInterID and b.FInterID>0
LEFT JOIN ICQCScheme d ON a.FSCBillInterID=d.FInterID
WHERE a.FInterID=@FInterID

UPDATE b SET b.FEntrySelfT1449=c.FEntrySelfQCS27 
FROM ICQCBill a
LEFT JOIN ICQCBillEntry b ON a.FInterID=b.FInterID and b.FInterID>0
LEFT JOIN ICQCSchemeEntry c ON a.FSCBillInterID=c.FInterID and b.FEntryID=c.FEntryID
WHERE a.FInterID=@FInterID
END 