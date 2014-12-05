--drop procedure list_shd drop procedure list_shd_count

create procedure list_shd 
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
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')     
,ywy nvarchar(20) default('')           
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,ywy nvarchar(20) default('')
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',us.FDescription as 'ywy'
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_shd_count 
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
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')     
,ywy nvarchar(20) default('')           
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,ywy nvarchar(20) default('')
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',us.FDescription as 'ywy'
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end


execute list_shd '','2011-02-01','2012-02-28','','null','null'
