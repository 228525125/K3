

select u1.FOperTranOutQty,u1.FTranOutQty,b.FAuxQtyFinish,b.FAuxQtyFinishCoefficient,b.FFlowCardNo,b.FEntryID
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
INNER JOIN ICShop_FlowCardEntry b on b.FFlowCardNo=u1.FFlowCardNo and b.FEntryID=u1.FFlowCardEntryID
where v1.FBillNo like '%4358%' and u1.FEntryID=9259

update u1 set u1.FOperTranOutQty=45 ,u1.FTranOutQty=45 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo like '%4358%' and FEntryID=9259


select b.* from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and a.FFlowCardNo='FC25896'
and b.FEntryID=222963

update b set b.FAuxQtyFinish=45,b.FAuxQtyFinishCoefficient=45 from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
left join ICMO c on a.FSourceBillNo=c.FBillNo
where 1=1 
and a.FFlowCardNo='FC25896'
and b.FEntryID=222963


222963

