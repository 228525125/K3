--������ת������ʱ���Զ������񵥵���¯��
--DROP TRIGGER IC_GXLZK_LH

CREATE TRIGGER IC_GXLZK_LH ON ICShop_FlowCard
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FInterID int        --������������
SELECT @FInterID=FSRCInterID FROM inserted
EXECUTE sclzklh @FInterID
END 




select a.FText1,b.FHeadSelfJ0184 from ICShop_FlowCard a left join ICMO b on a.FSourceBillNo=b.FBillNo where b.FBillNo='WORK024670'

update a set a.FText1=b.FHeadSelfJ0184 from ICShop_FlowCard a left join ICMO b on a.FSourceBillNo=b.FBillNo

select FHeadSelfJ0184,* from ICMO where FBillNo='WORK024670'

--�޸���ת���ϸ�����

select b.FAuxQtyPass,b.FAuxQtyPassCoefficient,b.* from ICShop_FlowCard a left join ICShop_FlowCardEntry b on a.FID=b.FID where a.FFlowCardNo in ('FC25799','FC25757') and FIndex=1

update b set b.FAuxQtyPass=5000,b.FAuxQtyPassCoefficient=5000 from ICShop_FlowCard a left join ICShop_FlowCardEntry b on a.FID=b.FID where a.FFlowCardNo='FC25799' and FIndex=1




FFlowCardNo

select * from ICMO where FBillNo='WORK025241'

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo='WORK025051'


select * from 




