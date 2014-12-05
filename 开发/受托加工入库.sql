--drop procedure list_stjgrk drop procedure list_stjgrk_count

create procedure list_stjgrk 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')           
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')  
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,0 as 'FOrderInterID',0 as 'FOrderEntryID',convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from ICSTJGBill v1 
INNER JOIN ICSTJGBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=92 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICSTJGBill v1 
INNER JOIN ICSTJGBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=92 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_stjgrk_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')           
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')  
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,0 as 'FOrderInterID',0 as 'FOrderEntryID',convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from ICSTJGBill v1 
INNER JOIN ICSTJGBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=92 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICSTJGBill v1 
INNER JOIN ICSTJGBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FTranType=92 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end

execute list_stjgrk '','2011-02-01','2012-02-28','','null','null'

