--drop procedure list_wwzc_edit drop procedure list_wwzc_edit_count

create procedure list_wwzc_edit 
@query nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FInterEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jhrq nvarchar(255) default('')         
,jgdw nvarchar(255) default('')     
,ysjsl decimal(28,2) default(0)
,sfjy int default(0)                       
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FInterEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jhrq nvarchar(255) default('')
,jgdw nvarchar(255) default('')
,ysjsl decimal(28,2) default(0)                   
,sfjy int default(0)
)

Insert Into #temp(FStatus,FInterID,FEntryID,FInterEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,ysjsl,sfjy
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,u1.FInterID,u1.FEntryID,cast(u1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FInterEntryID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FBillDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FTranOutQty as 'fssl',u1.FBatchNo as 'wlph',u1.FFetchDate as 'jhrq',t4.FName as 'jgdw',isnull(w.FQty,0) as 'ysjsl',
case when f1.FID is null then 0 else 1 end as sfjy 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
LEFT JOIN (select FID,FEntryID from ICShop_FlowCardEntry where FIsOut=1058 and FQualityChkID<>352 group by FID,FEntryID) f1 on u1.FFlowCardInterID=f1.FID and u1.FFlowCardEntryID=f1.FEntryID
where 1=1 
AND v1.FStatus > 0 
order by v1.FBillNo 

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FInterEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,ysjsl,sfjy)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FInterEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,ysjsl,sfjy)select * from #temp order by '+ @orderby +' '+ @ordertype)

exec('select * from #Data where FInterEntryID in ('+@query+')')
end

--count--
create procedure list_wwzc_edit_count 
@query nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FInterEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jhrq nvarchar(255) default('')         
,jgdw nvarchar(255) default('')     
,ysjsl decimal(28,2) default(0)                       
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FInterEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jhrq nvarchar(255) default('')
,jgdw nvarchar(255) default('')
,ysjsl decimal(28,2) default(0)                   
)

Insert Into #temp(FStatus,FInterID,FEntryID,FInterEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,ysjsl
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,u1.FInterID,u1.FEntryID,cast(u1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FInterEntryID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FBillDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FTranOutQty as 'fssl',u1.FBatchNo as 'wlph',u1.FFetchDate as 'jhrq',t4.FName as 'jgdw',isnull(w.FQty,0) as 'ysjsl' 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID
where 1=1 
AND v1.FStatus > 0
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FInterEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,ysjsl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FEntryID,FInterEntryID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,jhrq,jgdw,ysjsl)select * from #temp order by '+ @orderby +' '+ @ordertype)

exec('select count(*) from #Data where FInterEntryID in ('+@query+')')
end




execute list_wwzc_edit '38095122','null',''

execute list_wwzc_edit_count '22981806','null',''

execute list_wwzc_edit_count '','null','null'


execute list_wwzc_count 'WORK011866','2000-01-01','2099-12-31','','null','null'




select * from ICShop_SubcOutEntry

select f2.* from ICShop_FlowCard f1
left join ICShop_FlowCardEntry f2 on f1.FID=f2.FID
where f1.FFlowCardNo='FC8701'

352

select * from ICShop_FlowCardEntry


select v1.*,FFlowCardInterID,FFlowCardEntryID FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID

FIsOut=1058


select * from wwzc_wwjysqd where fid=597

delete wwzc_wwjysqd where fid=597




select case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,u1.FInterID,u1.FEntryID,cast(u1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FInterEntryID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FBillDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FTranOutQty as 'fssl',u1.FBatchNo as 'wlph',u1.FFetchDate as 'jhrq',t4.FName as 'jgdw',isnull(w.FQty,0) as 'ysjsl',
case when f1.FID is null then 0 else 1 end as sfjy 
FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID 
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select FSourceInterID,FSourceEntryID,sum(FQty) as FQty from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID) w on w.FSourceInterID=u1.FInterID and w.FSourceEntryID=u1.FEntryID 
LEFT JOIN (select FID,FEntryID from ICShop_FlowCardEntry where FIsOut=1058 and FQualityChkID<>352 group by FID,FEntryID) f1 on u1.FFlowCardInterID=f1.FID and u1.FFlowCardEntryID=f1.FEntryID
where 1=1 
AND v1.FStatus > 0 
and v1.FBillNo='wwzc002810'
and i.FNumber = '06.07.0100'


select * from ICShop_SubcOut where FBillNo='wwzc002810'

38095122

select * from ICShop_SubcOutEntry where FInterID=3809

select FEntryID from ICShop_SubcOutEntry group by FEntryID

select * from ICShop_FlowCardEntry

select * from wwzc_wwjysqd where fid=2406

update wwzc_wwjysqd set jyfs='√‚ºÏ' where fid=2401


