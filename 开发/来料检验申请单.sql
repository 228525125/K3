--drop procedure list_lljysqd drop procedure list_lljysqd_count

create procedure list_lljysqd 
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

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',us.FDescription as 'ywy' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,ywy)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_lljysqd_count 
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
)

create table #Data(
FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(20) default('')
,hywgb nvarchar(20) default('')
,FInterID nvarchar(20) default('')
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
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%'
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end





execute list_lljysqd '29332','2000-02-01','2012-02-28','','null','null'






select * from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = '29332' and v1.FCancellation = 0


Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))
and cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = '29332'
order by v1.FBillNo



select FAuxConPassQty,FConPassQty,FAuxConCommitQty,FConCommitQty,FAuxQtyPass,FQtyPass,FAuxBCommitQty,u1.* from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where v1.FTranType=702 and u1.FInterID=3627 and u1.FEntryID=2



/*update u1 set u1.FNotPassQty=240,u1.FAuxNotPassQty=240,u1.FConPassQty=0,u1.FConCommitQty=0,u1.FAuxConPassQty=0,u1.FAuxConCommitQty=0 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where v1.FTranType=702 and u1.FInterID=3627 and u1.FEntryID=2*/


select FAuxConPassQty,FConPassQty,FAuxConCommitQty,FConCommitQty,FAuxQtyPass,FQtyPass,FAuxBCommitQty,u1.* from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where v1.FTranType=702 and u1.FInterID=3687 and u1.FEntryID=1

-------------------------------

16480	2012-04-28 00:00:00.000


select * from QMReject a where fbillno in ('CGBL00000232','CGBL00000244')

--update QMReject set FCheckerID=16480,FCheckDate='2012-04-28' where fbillno='CGBL00000232' 

update QMReject set FCheckerID=0,FCheckDate=null where fbillno='CGBL00000232' 


left join QMRejectEntry b on a.fid=b.fid
where a.FBillNo in ('CGBL00000232','CGBL00000233')


update 



select u1.FEntrySelfT0241,u1.FEntrySelfT0242 from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))

FEntrySelfT0241


---------------更新炉号---------------
select v1.*,v1.FHeadSelft1256,v1.FInStockInterID,v1.FSerialID,u1.FEntrySelfT0241,u1.FEntrySelfT0242
from ICQCBill v1 
LEFT JOIN POInstockEntry u1 on v1.FInStockInterID=u1.FInterID and v1.FSerialID=u1.FEntryID
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0)) 
AND u1.FEntrySelfT0241 is not null

update v1 set v1.FHeadSelft1256=u1.FEntrySelfT0241 from ICQCBill v1 
LEFT JOIN POInstockEntry u1 on v1.FInStockInterID=u1.FInterID and v1.FSerialID=u1.FEntryID
where 1=1 
AND (v1.FTranType=711 AND (v1.FCancellation = 0)) 
AND u1.FEntrySelfT0241 is not null


update ICQCBill set FHeadSelft1256='11d11'
where 1=1 
AND (FTranType=711 AND (FCancellation = 0)) 
and FBillNo='IQC002172'



Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
INNER JOIN t_ICItem i ON   u1.FItemID = i.FItemID  AND i.FItemID<>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0))
and v1.FBillNo like '%1228%'

select * from POInstock where FBillNo like '%IQCR001354%'AND (FTranType=702 AND (FCancellation = 0))

update POInstock set FDate='2013-11-06' where FBillNo like '%1228%'AND (FTranType=702 AND (FCancellation = 0))


select * from POInstockEntry where FInterID=5825 and FEntryID=4

delete POInstockEntry where FInterID=5825 and FEntryID=4