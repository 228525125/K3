--销售订单单价变更时，同时更新发货通知和销售出库的单价
--DROP TRIGGER IC_XSDD_GXDJ

CREATE TRIGGER IC_XSDD_GXDJ ON SEOrder
After UPDATE,INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted WHERE FChangeUser>0)
BEGIN
DECLARE @FInterID int

SELECT @FInterID=FInterID FROM inserted

EXECUTE update_dd @FInterID

END




--drop procedure update_dd-- 根据订单单价更新通知和出库

create procedure update_dd
@FInterID int
as
begin
SET NOCOUNT ON
update c set c.FPrice=b.FPriceDiscount,c.FAmount=c.FQty*b.FPriceDiscount,c.FAuxPrice=b.FPriceDiscount,c.FStdAmount=c.FQty*b.FPriceDiscount
from SEOrder a
INNER JOIN SEOrderEntry b on a.FInterID=b.FInterID
INNER JOIN SEOutStockEntry c on c.FSourceInterID=b.FInterID and c.FOrderEntryID=b.FEntryID
where a.FStatus>=1
and a.FInterID=@FInterID

update d set d.FConsignPrice=b.FPriceDiscount,d.FConsignAmount=d.FQty*b.FPriceDiscount
from SEOrder a
INNER JOIN SEOrderEntry b on a.FInterID=b.FInterID
INNER JOIN ICStockBillEntry d on d.FOrderInterID=b.FInterID and d.FOrderEntryID=b.FEntryID
where a.FStatus>=1
and a.FInterID=@FInterID
end


exec update_dd 10200



select FStatus,* from SEOrder a
INNER JOIN SEOrderEntry b on a.FInterID=b.FInterID
where a.FBillNo='SEORD007122'
and a.FCancellation = 0



select b.* from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FBillNo='XOUT009217'

