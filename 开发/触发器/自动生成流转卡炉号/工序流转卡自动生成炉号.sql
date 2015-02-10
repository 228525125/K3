--工序流转卡生成时，自动从任务单导入炉号
--DROP TRIGGER IC_GXLZK_LH

CREATE TRIGGER IC_GXLZK_LH ON ICShop_FlowCard
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
DECLARE @FInterID int        --关联任务单内码
SELECT @FInterID=FSRCInterID FROM inserted
EXECUTE sclzklh @FInterID
END 




select a.FText1,b.FHeadSelfJ0184 from ICShop_FlowCard a left join ICMO b on a.FSourceBillNo=b.FBillNo where b.FBillNo='WORK024670'

update a set a.FText1=b.FHeadSelfJ0184 from ICShop_FlowCard a left join ICMO b on a.FSourceBillNo=b.FBillNo

select FHeadSelfJ0184,* from ICMO where FBillNo='WORK024670'

--修改流转卡合格数量

select b.FAuxQtyPass,b.FAuxQtyPassCoefficient,b.* from ICShop_FlowCard a left join ICShop_FlowCardEntry b on a.FID=b.FID where a.FFlowCardNo in ('FC25799','FC25757') and FIndex=1

update b set b.FAuxQtyPass=5000,b.FAuxQtyPassCoefficient=5000 from ICShop_FlowCard a left join ICShop_FlowCardEntry b on a.FID=b.FID where a.FFlowCardNo='FC25799' and FIndex=1




FFlowCardNo

select * from ICMO where FBillNo='WORK025241'

update ICMO set FCheckCommitQty=0,FAuxCheckCommitQty=0 where FBillNo='WORK025051'


select * from 




