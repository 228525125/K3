--drop procedure list_sctl drop procedure list_sctl_count

create procedure list_sctl 
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
)

Insert Into #temp(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,i1.FBillNo as 'FSourceBillNo',convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl' 
from PPBOM v1 
INNER JOIN PPBOMEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN ICMO i1 ON   v1.FICMOInterID = i1.FInterID  AND i1.FInterID<>0 
LEFT JOIN t_Department t42 ON   i1.FWorkShop = t42.FItemID  AND t42.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
 where 1=1 
AND I1.FType <> 11060 and v1.FType<>1067
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or i1.FBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from PPBOM v1 
INNER JOIN PPBOMEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN ICMO i1 ON   v1.FICMOInterID = i1.FInterID  AND i1.FInterID<>0 
LEFT JOIN t_Department t42 ON   i1.FWorkShop = t42.FItemID  AND t42.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
 where 1=1 
AND I1.FType <> 11060 and v1.FType<>1067
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or i1.FBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--

create procedure list_sctl_count 
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
)

Insert Into #temp(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,i1.FBillNo as 'FSourceBillNo',convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl' 
from PPBOM v1 
INNER JOIN PPBOMEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN ICMO i1 ON   v1.FICMOInterID = i1.FInterID  AND i1.FInterID<>0 
LEFT JOIN t_Department t42 ON   i1.FWorkShop = t42.FItemID  AND t42.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
 where 1=1 
AND I1.FType <> 11060 and v1.FType<>1067
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or i1.FBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Department t4 ON v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end


execute list_sctl '','2011-08-01','2011-08-31','','null',''

execute list_sctl_count '','2011-08-01','2011-08-31','','null',''
