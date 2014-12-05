select * from ICShop_FlowCard where FDBCode like 'FC25144%'

update ICShop_FlowCard set FPlanStartDate='2013-05-04',FPlanFinishDate='2013-05-06' where FDBCode='FC13984'


SELECT * FROM ICShop_FlowCard WHERE FDBCode IN ('fc16392','FC16495')

update ICShop_FlowCard set FText1='11D487' WHERE FDBCode IN ('fc16392','FC16495')

--------任务单结案的流转卡状态修改为完工---------
select b.* from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and c.FStatus=3
and b.FIsOut<>1058

update b set b.FStatus=4 from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where c.FStatus=3


FSourceBillNo

FFlowCardNo

--5 转出 6 接收

select b.* from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and a.FFlowCardNo='FC22749'
and FIndex=1

update b set b.FAuxQty=144,b.F from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and a.FFlowCardNo='FC22749'
and FIndex=1



