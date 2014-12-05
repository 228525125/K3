

select FWorkTypeID,* from ICMO v1 

select b.FStatus,* 
from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on  a.FID=b.FID
Inner join ICMO o on a.FSourceBillNo=o.FBillNo
where 1=1
and o.FStatus = 3           --结案
and b.FStatus <> 4


update b set b.FStatus=4 
from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on  a.FID=b.FID
Inner join ICMO o on a.FSourceBillNo=o.FBillNo
where 1=1
and o.FStatus = 3           --结案
and b.FStatus <> 4

select * from ICShop_FlowCardEntry


select * from ICMO where FBillNo in ('work024507','work024508')



--5：委外转出 6：委外接收 4：完工 0：未派工 2：已打印 1：已派工 3：开工 7：暂停 8：取消