--DROP TRIGGER IC_LLJYD_BEIZHU

CREATE TRIGGER IC_LLJYD_BEIZHU ON ICQCBill
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM inserted where FTranType=711)       
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted
UPDATE v1 SET v1.FNote=v1.FNote+'   《来料检验申请单备注》：'+u1.FNote FROM ICQCBill v1 
LEFT JOIN POInstockEntry u1 ON v1.FInStockInterID=u1.FInterID and v1.FSerialID=u1.FEntryID
WHERE 1=1 
AND (v1.FTranType=711) 
AND u1.FNote <>''
AND v1.FInterID=@FInterID
END 


select FNote,* from ICQCBill where FTranType=711 and FInterID=33259

update ICQCBill set FNote='刻字的位置度偏移了中心' where FTranType=711 and FInterID=33259


select u1.FNote,* from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where u1.FNote<>''


