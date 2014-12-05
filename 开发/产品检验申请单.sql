--drop procedure list_cpjysqd drop procedure list_cpjysqd_count

create procedure list_cpjysqd 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@style int,              --0：列表；1：用于复制检验单用
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
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')           
,ywy nvarchar(20) default('')      
,jysl decimal(28,2) default(0)          
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,ywy nvarchar(20) default('')           
,jysl decimal(28,2) default(0)          
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy,jysl
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,v1.FICMOInterID,o.FBillNo as FICOMBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',us.FDescription as 'ywy',isnull(ic.FCheckQty,0) as 'jysl' 
from QMICMOCKRequest v1 
INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem t15 ON   u1.FItemID = t15.FItemID  AND t15.FItemID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN ICMO o on v1.FICMOInterID=o.FInterID
LEFT JOIN (
select b.FInterID,b.FEntryID,sum(c.FCheckQty) as FCheckQty 
from QMICMOCKRequestEntry b
left join ICQCBill c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
group by b.FInterID,b.FEntryID
) ic on ic.FInterID=u1.FInterID and ic.FEntryID=u1.FEntryID
where 1=1 
AND (v1.FTranType=701 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy,jysl)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy,jysl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl,jysl)
Select '合计',sum(u1.FQty) as 'fssl',sum(ic.FCheckQty) as 'jysl'
from QMICMOCKRequest v1 
INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem t15 ON   u1.FItemID = t15.FItemID  AND t15.FItemID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN ICMO o on v1.FICMOInterID=o.FInterID
LEFT JOIN (
select b.FInterID,b.FEntryID,sum(c.FCheckQty) as FCheckQty 
from QMICMOCKRequestEntry b
left join ICQCBill c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
group by b.FInterID,b.FEntryID
) ic on ic.FInterID=u1.FInterID and ic.FEntryID=u1.FEntryID
where 1=1 
AND (v1.FTranType=701 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'

if @style=0
select * from #Data 
else
select * from #Data where FCheck<>'合计' and jysl<fssl
end

--count--
create procedure list_cpjysqd_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
@style int,              --0：列表；1：用于复制检验单用
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
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')           
,ywy nvarchar(20) default('')      
,jysl decimal(28,2) default(0)          
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FICMOInterID nvarchar(20) default('')
,FICOMBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(20) default('')  
,ywy nvarchar(20) default('')           
,jysl decimal(28,2) default(0)          
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy,jysl
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,v1.FICMOInterID,o.FBillNo as FICOMBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',us.FDescription as 'ywy',isnull(ic.FCheckQty,0) as 'jysl' 
from QMICMOCKRequest v1 
INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem t15 ON   u1.FItemID = t15.FItemID  AND t15.FItemID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN ICMO o on v1.FICMOInterID=o.FInterID
LEFT JOIN (
select b.FInterID,b.FEntryID,sum(c.FCheckQty) as FCheckQty 
from QMICMOCKRequestEntry b
left join ICQCBill c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
group by b.FInterID,b.FEntryID
) ic on ic.FInterID=u1.FInterID and ic.FEntryID=u1.FEntryID
where 1=1 
AND (v1.FTranType=701 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy,jysl)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FICMOInterID,FICOMBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy,jysl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl,jysl)
Select '合计',sum(u1.FQty) as 'fssl',sum(ic.FCheckQty) as 'jysl'
from QMICMOCKRequest v1 
INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem t15 ON   u1.FItemID = t15.FItemID  AND t15.FItemID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN ICMO o on v1.FICMOInterID=o.FInterID
LEFT JOIN (
select b.FInterID,b.FEntryID,sum(c.FCheckQty) as FCheckQty 
from QMICMOCKRequestEntry b
left join ICQCBill c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
group by b.FInterID,b.FEntryID
) ic on ic.FInterID=u1.FInterID and ic.FEntryID=u1.FEntryID
where 1=1 
AND (v1.FTranType=701 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or o.FBillNo = @query)
AND v1.FStatus like '%'+@status+'%'

if @style=0
select count(*) from #Data 
else
select count(*) from #Data where FCheck<>'合计' and jysl<fssl
end

execute list_cpjysqd 'FQCR011601','2011-01-01','2011-11-14','1',0,'null','null'

execute list_cpjysqd '','2000-11-01','2011-11-30','','null','',1


execute list_cpjysqd_count 'WORK010015','2011-11-17','2011-11-17','','0','null','null'

execute list_cpjysqd 'WORK010201','2011-11-17','2011-11-17','','0','null','null'


select u1.* 
from QMICMOCKRequest v1 
INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where FICMOInterID=24907

update u1 set u1.FBatchNo='13D28' from QMICMOCKRequest v1 
INNER JOIN QMICMOCKRequestEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where FICMOInterID=24907

