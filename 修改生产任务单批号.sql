select * from ICMO where FBillNo='WORK034330'

update ICMO set FGMPBatchNo='Q1408' where FBillNo='WORK034330'

select A.* from ICShop_FlowCard a 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and c.FBillNo='WORK033920'

UPDATE a set a.FText='Q1406',a.FText1='Q1406' 
from ICShop_FlowCard a 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and c.FBillNo='WORK033920'