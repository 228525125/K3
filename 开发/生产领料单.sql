--drop procedure list_scll drop procedure list_scll_count

create procedure list_scll 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
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
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Department t4 ON v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
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
select * from #Data 
end

--count--
create procedure list_scll_count 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
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
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Department t4 ON v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
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



execute list_scll '','2011-08-01','2011-08-31','','null',''

execute list_scll_count '','2011-08-01','2011-08-31','','null',''


execute list_scll_count 'WORK011866','2000-01-01','2099-12-31','','null','null'






select * from ICStockBillEntry


select * from ICStockBill v1 
--INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
and v1.FBillNo='SOUT015554'

16469


Select 
i.FNumber,i.FName,i.FModel,i.FHelpCode,
sum(u1.FQty) as 'fssl',Max(s.FQty) as 'rksl',s.FName
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Department t4 ON v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (
select s.FName,i.FNumber,sum(u1.FQty) as FQty
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
AND v1.FDate>='2012-01-01' AND  v1.FDate<='2012-12-31'
group by s.FName,i.FNumber
) s on s.FNumber=i.FNumber
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FDate>='2012-01-01' AND  v1.FDate<='2012-12-31'
AND left(i.FNumber,3)='02.'
group by i.FNumber,i.FNumber,i.FName,i.FModel,i.FHelpCode,s.FName
order by sum(u1.FQty) desc



select v1.* from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1
AND (v1.FTranType=24 AND v1.FCancellation = 0)
and v1.FBillNo='SOUT023163'

select s.FName,i.FNumber,sum(u1.FQty)
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
--AND left(i.FNumber,3)='02.'
AND i.FNumber ='02.02.02.039'
AND v1.FDate>='2012-01-01' AND  v1.FDate<='2012-12-31'
group by s.FName,i.FNumber

select u1.* from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNO='SOUT020400'


select * from ICMO where FBillnO='WORK023674'
24798


select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=10 and v1.FStatus=1
and v1.FDate>='2013-01-01' and v1.FDate<='2013-12-31'
and 

