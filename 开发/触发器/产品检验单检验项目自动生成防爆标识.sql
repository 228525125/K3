--添加防爆检验项目
--DROP TRIGGER IC_CPJJD_FANGBAO

CREATE TRIGGER IC_CPJJD_FANGBAO ON ICQCBill
After UPDATE,INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted  WHERE FStatus=1 AND FTranType=713 AND FCancellation = 0) 
BEGIN
DECLARE @FInterID int

SELECT @FInterID=FInterID FROM inserted

UPDATE b set b.FEntrySelfT1448 = d.FEntrySelfQCS26 
from ICQCBill a
left join ICQCBillEntry b on a.FInterID=b.FInterID and b.FInterID>0
LEFT JOIN t_ICItem i on i.FItemID=a.FItemID
LEFT JOIN ICQCScheme c on i.FInspectionProject = c.FInterID and i.FInspectionProject>0
left join ICQCSchemeEntry d on c.FInterID=d.FInterID and b.FEntryID=d.FEntryID
where 1=1
and a.FInterID=@FInterID

END