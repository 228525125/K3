--�˴��������ͼ�����ʱ���Զ�������������FCheckCommitQty��FAuxCheckCommitQty��ֵ���Դﵽ�ͼ�����=�ƻ�-����-����-���ͼ�
--DROP TRIGGER IC_CPJYSQD_SCRWSJSL

CREATE TRIGGER IC_CPJYSQD_SCRWSJSL ON QMICMOCKRequest    
AFTER DELETE                                                    --���������˵�ʱ��k3ϵͳ���Զ�����FCheckCommitQty������ɾ�����ݵ�ʱ���޷����£��������ֻ����ɾ������ʱ����
AS
SET NOCOUNT ON
BEGIN
exec compute_scrw_yjsl
END

INSERT,UPDATE,

WORK023816

select FCheckCommitQty,* from ICMO where FBillNo like '%23816%'


select FCheckCommitQty,FAuxCheckCommitQty,FStatus,* from ICMO where FBillNo = 'WORK023770-1'

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo = 'WORK000305'



