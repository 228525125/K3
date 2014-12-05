--默认销售方式为：分期

CREATE TRIGGER IC_XSDD_XSFS ON SEOrder
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)        --订单变更不进行判断
BEGIN
DECLARE @FInterID int

SELECT @FInterID=FInterID FROM inserted

UPDATE SEOrder SET FSaleStyle=102 WHERE FInterID=@FInterID

END


select FSaleStyle,* from SEOrder where FBillNo='SEORD007619'



