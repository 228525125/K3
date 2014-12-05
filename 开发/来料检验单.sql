--drop procedure list_lljyd drop procedure list_lljyd_count

create procedure list_lljyd 
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
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)    
,bhgsl decimal(28,2) default(0)                
,wlph nvarchar(20) default('')   
,jyjg nvarchar(20) default('')          
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)          
,bhgsl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jyjg nvarchar(20) default('')  
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,'' as FCloseStatus, 
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation, 
v1.FInStockInterID as FSourceInterID,v1.FSerialID as FSourceEntryID,p.FOrderInterID,p.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
v1.FCheckQty as 'bjsl',v1.FPassQty as 'hgsl',v1.FNotPassQty as 'bhgsl',v1.FBatchNo as 'wlph',case when v1.FResult=286 then '合格' else '不合格' end as 'jyjg'
from ICQCBill v1 
LEFT JOIN t_Emp t2 ON   v1.FFManagerID = t2.FItemID  AND t2.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN POInstockEntry p on v1.FInStockInterID=p.FInterID and v1.FSerialID=p.FEntryID
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0)) 
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or v1.FBatchNo like '%'+@query+'%' 
or cast(p.FOrderInterID as nvarchar(10))+cast(p.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,hgsl)
Select '合计',sum(v1.FPassQty) as 'hgsl'
from ICQCBill v1 
LEFT JOIN t_Emp t2 ON   v1.FFManagerID = t2.FItemID  AND t2.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN POInstockEntry p on v1.FInStockInterID=p.FInterID and v1.FSerialID=p.FEntryID
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(p.FOrderInterID as nvarchar(10))+cast(p.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_lljyd_count 
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
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)    
,bhgsl decimal(28,2) default(0)                
,wlph nvarchar(20) default('')   
,jyjg nvarchar(20) default('')          
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceInterID nvarchar(20) default('')
,FSourceEntryID nvarchar(20) default('')
,FOrderInterID nvarchar(20) default('')
,FOrderEntryID nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,bjsl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)          
,bhgsl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,jyjg nvarchar(20) default('')  
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,'' as FCloseStatus, 
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation, 
v1.FInStockInterID as FSourceInterID,v1.FSerialID as FSourceEntryID,p.FOrderInterID,p.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
v1.FCheckQty as 'bjsl',v1.FPassQty as 'hgsl',v1.FNotPassQty as 'bhgsl',v1.FBatchNo as 'wlph',case when v1.FResult=286 then '合格' else '不合格' end as 'jyjg'
from ICQCBill v1 
LEFT JOIN t_Emp t2 ON   v1.FFManagerID = t2.FItemID  AND t2.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN POInstockEntry p on v1.FInStockInterID=p.FInterID and v1.FSerialID=p.FEntryID
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0)) 
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' 
or cast(p.FOrderInterID as nvarchar(10))+cast(p.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceInterID,FSourceEntryID,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,bjsl,hgsl,bhgsl,wlph,jyjg)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,hgsl)
Select '合计',sum(v1.FPassQty) as 'hgsl'
from ICQCBill v1 
LEFT JOIN t_Emp t2 ON   v1.FFManagerID = t2.FItemID  AND t2.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN POInstockEntry p on v1.FInStockInterID=p.FInterID and v1.FSerialID=p.FEntryID
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(p.FOrderInterID as nvarchar(10))+cast(p.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end




select count(FBillNo),case when FResult=286 then  from ICQCBill where 1=1 
and FResult=286
LEFT JOIN t_Emp t2 ON   v1.FFManagerID = t2.FItemID  AND t2.FItemID<>0 
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0))








