--此触发器在送检申请时，自动更新生产任务单FCheckCommitQty和FAuxCheckCommitQty的值，以达到送检数量=计划-退料-报废-已送检
--DROP TRIGGER IC_CPJYSQD_SCRWSJSL

CREATE TRIGGER IC_CPJYSQD_SCRWSJSL ON QMICMOCKRequest    
AFTER DELETE                                                    --当保存和审核的时候，k3系统会自动更新FCheckCommitQty，但在删除单据的时候无法更新，因此这里只需在删除单据时触发
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



