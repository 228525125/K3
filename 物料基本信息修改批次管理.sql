
select a.FBatchManager,b.FProChkMde,b.* from t_ICItem a left join t_ICItemQuality b on a.FItemID=b.FItemID where FNumber in ('09.0505')

update t_ICItem set FBatchManager=1 where FNumber IN ('09.0813')

select FGMPBatchNo,* 
from ICMO a 
left join t_ICItem b on a.FItemID=b.FItemID
left join ICShop_FlowCard c on a.FBillNo=c.FSourceBillNo
where 1=1
and b.FNumber in ('09.0923','09.0925','09.0920','09.0924')
and a.FStatus in (1,2)


select * from ICMO a left join ICShop_FlowCard b on a.FBillNo=b.FSourceBillNo where FBillNo='WORK025662'

update a set a.FGMPBatchNo='13J45' from ICMO a left join ICShop_FlowCard b on a.FBillNo=b.FSourceBillNo where FBillNo='WORK025662'

update b set b.FText='13J45' from ICMO a left join ICShop_FlowCard b on a.FBillNo=b.FSourceBillNo where FBillNo='WORK025662'



