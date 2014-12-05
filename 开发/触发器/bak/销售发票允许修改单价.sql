
--DROP TRIGGER IC_XSFP_DJ

CREATE TRIGGER IC_XSFP_DJ ON ICSale
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID
	INNER JOIN ICStockBillEntry c on b.FSourceInterID=c.FInterID and b.FSourceEntryID=c.FEntryID  
	WHERE a.FStatus=1
	AND b.FTaxPrice <> c.FConsignPrice
)        --到货日期为当天的
BEGIN
--提示错误
DECLARE @FPrice decimal(28,2)
DECLARE @FEntryID int
DECLARE @msg nvarchar(255)

SELECT @FEntryID=b.FEntryID,@FPrice=c.FConsignPrice FROM inserted a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID
INNER JOIN ICStockBillEntry c on b.FSourceInterID=c.FInterID and b.FSourceEntryID=c.FEntryID  
WHERE a.FStatus=1
AND b.FTaxPrice <> c.FConsignPrice

set @msg='发票单价与出库单价不符，第'+convert(nvarchar(255),@FEntryID)+'行，出库金额：'+convert(nvarchar(255),@FPrice)

EXEC sp_addmessage 50022, 10, @msg,'us_english',false,replace

RAISERROR (50022,16,1 )
END


DECLARE @FPrice decimal(28,2)
DECLARE @FEntryID int
DECLARE @msg nvarchar(255)
set @FPrice=20.5
set @FEntryID=2
set @msg='发票单价与出库单价不符，位置'+convert(nvarchar(255),@FEntryID)+'，出库金额：'+convert(nvarchar(255),@FPrice)
select @msg


SELECT b.FTaxPrice,c.FConsignPrice FROM ICSale a 
INNER JOIN ICSaleEntry b on a.FInterID=b.FInterID
INNER JOIN ICStockBillEntry c on b.FSourceInterID=c.FInterID and b.FSourceEntryID=c.FEntryID  
WHERE a.FStatus=0
AND a.FBillNo='XZP00000956'



 