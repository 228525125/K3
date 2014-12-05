--drop procedure list_scbf drop procedure list_scbf_count

create procedure list_scbf 
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
FCancellation,u1.FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl',u1.FBatchNo as 'wlph'
from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
 LEFT JOIN t_Department t4 ON   u1.FWorkShop = t4.FItemID  AND t4.FItemID<>0 
 LEFT JOIN t_ICItem t8 ON   u1.FItemID = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND v1.FCheckerID>0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
 LEFT JOIN t_Department t4 ON   u1.FWorkShop = t4.FItemID  AND t4.FItemID<>0 
 LEFT JOIN t_ICItem t8 ON   u1.FItemID = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND v1.FCheckerID>0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--

create procedure list_scbf_count 
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
FCancellation,u1.FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl',u1.FBatchNo as 'wlph'
from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
 LEFT JOIN t_Department t4 ON   u1.FWorkShop = t4.FItemID  AND t4.FItemID<>0 
 LEFT JOIN t_ICItem t8 ON   u1.FItemID = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND v1.FCheckerID>0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
 LEFT JOIN t_Department t4 ON   u1.FWorkShop = t4.FItemID  AND t4.FItemID<>0 
 LEFT JOIN t_ICItem t8 ON   u1.FItemID = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND v1.FCheckerID>0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end



execute list_scbf '','2012-01-01','2012-12-31','','null',''


Select i.FNumber as 'cpdm',i.FName as 'cpmc',sum(CONVERT(decimal(18,4),isnull(u1.FEntrySelfZ0632,0))) as 'fssl'
from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
LEFT JOIN t_ICItem i on u1.FEntrySelfZ0631=i.FHelpCode
 where 1=1 
AND v1.FCheckerID>0
AND v1.FCheckDate>='2013-01-01' AND  v1.FCheckDate<='2013-12-31'
AND v1.FStatus like '1'
and u1.FEntrySelfZ0632<>''
--and v1.FBillNo='FSC001195'
group by i.FNumber,i.FName
order by i.FNumber



select u1.FEntrySelfZ0631,i.FHelpCode,* from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
LEFT JOIN ICMO o ON u1.FSourceBillNo=o.FBillNo
LEFT JOIN t_ICItem i on o.FItemID=i.FItemID
where 1=1 AND v1.FBillNo='FSC005643'

SELECT * FROM ICItemScrap WHERE FBillNo='FSC005643'

Select a.FEntrySelfZ0631,i.FHelpCode,* from ICItemScrapEntry a 
LEFT JOIN ICMO o ON a.FSourceBillNo=o.FBillNo
LEFT JOIN t_ICItem i on o.FItemID=i.FItemID
where 1=1 AND a.FInterID=6650

UPDATE a set a.FEntrySelfZ0631=i.FHelpCode 
from ICItemScrapEntry a 
LEFT JOIN ICMO o ON a.FSourceBillNo=o.FBillNo
LEFT JOIN t_ICItem i on o.FItemID=i.FItemID
where 1=1 AND a.FInterID=

