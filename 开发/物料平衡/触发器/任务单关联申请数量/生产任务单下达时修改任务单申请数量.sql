--�˴����������������´�ʱ���Զ�������������FCheckCommitQty��FAuxCheckCommitQty��ֵ���Դﵽ�ͼ�����=�ƻ�-����-����-���ͼ�
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