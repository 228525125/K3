--drop procedure list_cprk drop procedure list_cprk_count

create procedure list_cprk 
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
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')           
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
)

Insert Into #temp(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl',u1.FBatchNo as 'wlph'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--

create procedure list_cprk_count 
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
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')           
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
)

Insert Into #temp(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl',u1.FBatchNo as 'wlph'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end


execute list_cprk '','2011-02-01','2012-02-28','','null','null'


select b.FICMOBillNo,b.FICMOInterID,* from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=2 and b.FICMOInterID=24907 and FICMOBillNo='WORK023777'

update b set b.FICMOBillNo='WORK023777000',b.FICMOInterID=24907000 from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=2 and b.FICMOInterID=24907


select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FBillNo in ('CIN006914','CIN006915','CIN006916','CIN006917')

update b set b.FICMOBillNo='WORK023777',b.FICMOInterID=24907,b.FBatchNo='13D28' from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FBillNo in ('CIN006914','CIN006915','CIN006916','CIN006917')



Select i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0
AND v1.FCheckDate>='2012-01-01' AND  v1.FCheckDate<='2012-12-31'
group by i.FNumber,i.FName,i.FModel,mu.FName
order by i.FNumber 



