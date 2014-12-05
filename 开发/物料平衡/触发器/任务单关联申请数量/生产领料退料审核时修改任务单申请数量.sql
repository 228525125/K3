--此触发器在生产退料时，自动更新生产任务单FCheckCommitQty和FAuxCheckCommitQty的值，以达到送检数量=计划-退料-报废-已送检
--DROP TRIGGER IC_SCTL

CREATE TRIGGER IC_SCTL ON ICStockBill
AFTER INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted a 
	INNER JOIN ICStockBillEntry b on a.FInterID=b.FInterID 
	WHERE a.FTranType=24 AND a.FCancellation = 0 --AND a.FStatus = 1 AND a.FROB=-1 and b.FSCStockID=5272 
)
BEGIN
exec compute_scrw_yjsl
END
