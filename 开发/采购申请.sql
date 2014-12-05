--drop procedure list_cgsq drop procedure list_cgsq_count

create procedure list_cgsq 
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
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,dhrq nvarchar(20) default('') 
,ywy nvarchar(20) default('')
,shrq nvarchar(255) default('')                  
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
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,dhrq nvarchar(20) default('')  
,ywy nvarchar(20) default('')    
,shrq nvarchar(255) default('')
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,dhrq,ywy,shrq
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',convert(char(10),u1.FFetchTime,120) as 'dhrq',us.FDescription as 'ywy',convert(char(10),v1.FCheckTime,120) as 'shrq'
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem t11 ON u1.FItemID = t11.FItemID   AND t11.FItemID <>0 
LEFT JOIN t_Supplier t15 ON u1.FSupplyID = t15.FItemID AND t15.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
where 1=1 
AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,dhrq,ywy,shrq)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,dhrq,ywy,shrq)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem t11 ON u1.FItemID = t11.FItemID   AND t11.FItemID <>0 
LEFT JOIN t_Supplier t15 ON u1.FSupplyID = t15.FItemID AND t15.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_cgsq_count 
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
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,dhrq nvarchar(20) default('') 
,ywy nvarchar(20) default('')
,dhrq nvarchar(255) default('')                   
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
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,dhrq nvarchar(20) default('')  
,ywy nvarchar(20) default('')  
,dhrq nvarchar(255) default('')       
)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,dhrq,ywy,dhrq
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',convert(char(10),u1.FFetchTime,120) as 'dhrq',us.FDescription as 'ywy',u1.FFetchTime as 'dhrq'
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem t11 ON u1.FItemID = t11.FItemID   AND t11.FItemID <>0 
LEFT JOIN t_Supplier t15 ON u1.FSupplyID = t15.FItemID AND t15.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
where 1=1 
AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,dhrq,ywy,dhrq)select * from #temp')
else
exec('Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FEntryID,FBillNo,FCancellation,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,fssl,dhrq,ywy,dhrq)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FCheck,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem t11 ON u1.FItemID = t11.FItemID   AND t11.FItemID <>0 
LEFT JOIN t_Supplier t15 ON u1.FSupplyID = t15.FItemID AND t15.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end

execute list_cgsq '','2011-08-01','2011-08-31','','null',''

execute list_cgsq '','2011-10-01','2011-10-22','','null','null'


select * from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo='POREQ000063' 

--select * from POrequestEntry where FInterID=1302 and FEntryID=4

update POrequestEntry set FMRPClosed=0 where FInterID=1302 and FEntryID=4

select * from POrequest where FInterID=1302
select * from POrequestEntry where FInterID=1302 and FEntryID=4

delete POrequestEntry where FInterID=1302 and FEntryID=4


update POrequest set fstatus=3,FClosed=1 where FInterID=1302


select * from POrequestEntry where FInterID=78 and FEntryID=4

Insert Into POrequestEntry(FBrNo,FInterID,FEntryID,FItemID,FQty,FCommitQty,FPrice,FUse,FFetchTime,FUnitID,FAuxCommitQty,FAuxPrice,FAuxQty,FSourceEntryID,FSupplyID,FAPurchTime,FPlanOrderInterID,FAuxPropID,FSecCoefficient,FSecQty,FSecCommitQty,FSourceTranType,FSourceInterId,FSourceBillNo,FMRPLockFlag,FOrderQty,FMRPClosed,FMrpAutoClosed,FPlanMode,FMTONo,FBomInterID
)
select FBrNo,FInterID,4,2381,FQty,FCommitQty,FPrice,FUse,FFetchTime,FUnitID,FAuxCommitQty,FAuxPrice,FAuxQty,FSourceEntryID,FSupplyID,FAPurchTime,FPlanOrderInterID,FAuxPropID,FSecCoefficient,FSecQty,FSecCommitQty,FSourceTranType,FSourceInterId,FSourceBillNo,FMRPLockFlag,FOrderQty,FMRPClosed,FMrpAutoClosed,FPlanMode,FMTONo,FBomInterID from POrequestEntry where FInterID=1302 and FEntryID=2



select FChildren,* from POrequest where FBillNo='POREQ002248'

update POrequest set FChildren=0 where FBillNo='POREQ002248'

INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 


