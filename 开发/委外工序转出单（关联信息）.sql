--drop procedure table_wwzc

create procedure table_wwzc
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
select 
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,
case when fc.FQualityChkID=353 then '³é¼ì' else 'Ãâ¼ì' end as cjfs,
v1.FInterID,u1.FEntryID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FBillDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FTranOutQty as 'fssl',u1.FBatchNo as 'wlph',convert(char(10),u1.FFetchDate,120) as 'jhrq',t4.FName as 'jgdw',isnull(w.FQty,0) as 'sjsl',convert(char(10),w.FDate,120) as 'sjrq',u1.FQualifiedQty as 'hgsl',convert(char(10),z.FDate,120) as 'jyrq',u1.FReceiptQty as 'jssl',convert(char(10),y.FDate,120) as 'jsrq',
case when x.FItemID is null then 'Y' else '' end as 'shouci'
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty,min(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
LEFT JOIN (select FFlowCardInterID,FFlowCardEntryID,min(FBillDate) as FDate FROM  ICShop_SubcIn v1 INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID group by FFlowCardInterID,FFlowCardEntryID) y on u1.FFlowCardInterID=y.FFlowCardInterID and u1.FFlowCardEntryID=y.FFlowCardEntryID
LEFT JOIN (select FFlowCardInterID,FFlowCardEntryID,min(FDate) as FDate FROM ICQCBill v1 where 1=1 AND (v1.FTranType=715 AND v1.FCancellation = 0) group by FFlowCardInterID,FFlowCardEntryID) z on u1.FFlowCardInterID=z.FFlowCardInterID and u1.FFlowCardEntryID=z.FFlowCardEntryID
LEFT JOIN (select u1.FItemID FROM  ICShop_SubcOut v1 INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID where v1.FBillDate<'2015-01-01' group by FItemID) x on x.FItemID=u1.FItemID
LEFT JOIN ICShop_FlowCardEntry fc on u1.FFlowCardNo=fc.FFlowCardNo and u1.FFlowCardEntryID=fc.FEntryID
where 1=1 
AND convert(char(10),u1.FFetchDate,120)>=@begindate AND  convert(char(10),u1.FFetchDate,120)<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
end





exec table_wwzc '','2015-01-01','2015-01-31'



select b.FQualityChkID FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN ICShop_FlowCardEntry b on u1.FFlowCardNo=b.FFlowCardNo and u1.FFlowCardEntryID=b.FEntryID
where 1=1
AND u1.FFetchDate>='2015-01-01' AND  convert(char(10),u1.FFetchDate,120)<='2015-01-31'
and v1.FBillNo='WWZC004405'



select b.* from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on a.FID=b.FID 
