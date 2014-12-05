--此触发器在生产任务单下达时，自动更新生产任务单FCheckCommitQty和FAuxCheckCommitQty的值，以达到送检数量=计划-退料-报废-已送检
--DROP TRIGGER IC_SCRW

CREATE TRIGGER IC_SCRW ON ICMO
AFTER INSERT,UPDATE
AS
SET NOCOUNT ON
IF EXISTS(
	SELECT 1 FROM inserted WHERE FStatus in (1,2)
)
BEGIN
exec compute_scrw_yjsl
END



select FCheckCommitQty,FAuxCheckCommitQty,* from ICMO where FBillNo='WORK000305'