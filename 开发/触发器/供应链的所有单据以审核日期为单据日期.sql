--将审核日期反写单据日期
--DROP TRIGGER IC_IC_FDateForFCheckDate

CREATE TRIGGER IC_FDateForFCheckDate ON ICStockBill
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM inserted where FCheckDate is not null and FDate<>FCheckDate)       
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted
UPDATE ICStockBill set FDate=FCheckDate 
WHERE 1=1 
AND FInterID=@FInterID
END 


