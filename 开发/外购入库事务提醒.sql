--drop procedure count_task_wgrk drop procedure list_task_wgrk drop procedure list_task_wgrk_count

create procedure count_task_wgrk
@FUserID varchar(50)
as 
begin
SET NOCOUNT ON 
create table #temp(
FBillNo nvarchar(20) default('')
,FInterID int default(0)
,FEntryID int default(0)
,FMaxCheckLevel int default(0)
,FCurLevel int default(0)
,FCheckLevel int default(0)
,FUserID nvarchar(20) default('')
,FUserName nvarchar(20) default('')
)

Insert Into #temp(FBillNo,FInterID,FEntryID,FMaxCheckLevel,FCurLevel,FCheckLevel,FUserID,FUserName
)
select v1.FBillNo,v1.FInterID,u1.FEntryID,a.FMaxCheckLevel,
case when FMultiCheckLevel6 is not null then 6 when FMultiCheckLevel5 is not null then 5 when FMultiCheckLevel4 is not null then 4 when FMultiCheckLevel3 is not null then 3 when FMultiCheckLevel2 is not null then 2 when FMultiCheckLevel1 is not null then 1 else 0 end as 'FCurLevel',
b.FCheckLevel,c.FName as FUserID,c.FDescription as FUserName
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_MultiCheckOption a on v1.FTranType=a.FBillType
LEFT JOIN t_MultiLevelCheck b on a.FBillType=b.FBillType
LEFT JOIN t_User c on b.FCheckMan=c.FUserID
where 1=1 
AND v1.FTranType=1 
AND v1.FCancellation = 0 AND FMultiCheckLevel1 is not null
AND v1.FDate>='2011-01-01'

select count(distinct FBillNo) from #temp where FMaxCheckLevel>FCurLevel and (FCurLevel+1)=FCheckLevel and FUserID=@FUserID
end

--list_task_wgrk--
create procedure list_task_wgrk
@FUserID varchar(50),
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
FBillNo nvarchar(20) default('')
,FInterID int default(0)
,FEntryID int default(0)
,FMaxCheckLevel int default(0)
,FCurLevel int default(0)
,FCheckLevel int default(0)
,FUserID nvarchar(20) default('')
,FUserName nvarchar(20) default('')
)

create table #data(
FBillNo nvarchar(20) default('')
,FInterID int default(0)
,FEntryID int default(0)
,FUserID nvarchar(20) default('')
,FUserName nvarchar(20) default('')
)


Insert Into #temp(FBillNo,FInterID,FEntryID,FMaxCheckLevel,FCurLevel,FCheckLevel,FUserID,FUserName
)
select v1.FBillNo,v1.FInterID,u1.FEntryID,a.FMaxCheckLevel,
case when FMultiCheckLevel6 is not null then 6 when FMultiCheckLevel5 is not null then 5 when FMultiCheckLevel4 is not null then 4 when FMultiCheckLevel3 is not null then 3 when FMultiCheckLevel2 is not null then 2 when FMultiCheckLevel1 is not null then 1 else 0 end as 'FCurLevel',
b.FCheckLevel,c.FName as FUserID,c.FDescription as FUserName
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_MultiCheckOption a on v1.FTranType=a.FBillType
LEFT JOIN t_MultiLevelCheck b on a.FBillType=b.FBillType
LEFT JOIN t_User c on b.FCheckMan=c.FUserID
where 1=1 
AND v1.FTranType=1 
AND v1.FCancellation = 0 AND FMultiCheckLevel1 is not null
AND v1.FDate>='2011-01-01'

Insert Into #data(FBillNo,FInterID,FEntryID,FUserID,FUserName
)
select FBillNo,FInterID,FEntryID,FUserID,FUserName from #temp where FMaxCheckLevel>FCurLevel and (FCurLevel+1)=FCheckLevel and FUserID=@FUserID group by FBillNo,FInterID,FEntryID,FUserID,FUserName

Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
INNER JOIN #data d on u1.FInterID=d.FInterID and u1.FEntryID=d.FEntryID
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%')
order by v1.FBillNo
end

--list_task_wgrk_count--
create procedure list_task_wgrk_count
@FUserID varchar(50),
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #temp(
FBillNo nvarchar(20) default('')
,FInterID int default(0)
,FEntryID int default(0)
,FMaxCheckLevel int default(0)
,FCurLevel int default(0)
,FCheckLevel int default(0)
,FUserID nvarchar(20) default('')
,FUserName nvarchar(20) default('')
)

create table #data(
FBillNo nvarchar(20) default('')
,FInterID int default(0)
,FEntryID int default(0)
,FUserID nvarchar(20) default('')
,FUserName nvarchar(20) default('')
)


Insert Into #temp(FBillNo,FInterID,FEntryID,FMaxCheckLevel,FCurLevel,FCheckLevel,FUserID,FUserName
)
select v1.FBillNo,v1.FInterID,u1.FEntryID,a.FMaxCheckLevel,
case when FMultiCheckLevel6 is not null then 6 when FMultiCheckLevel5 is not null then 5 when FMultiCheckLevel4 is not null then 4 when FMultiCheckLevel3 is not null then 3 when FMultiCheckLevel2 is not null then 2 when FMultiCheckLevel1 is not null then 1 else 0 end as 'FCurLevel',
b.FCheckLevel,c.FName as FUserID,c.FDescription as FUserName
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_MultiCheckOption a on v1.FTranType=a.FBillType
LEFT JOIN t_MultiLevelCheck b on a.FBillType=b.FBillType
LEFT JOIN t_User c on b.FCheckMan=c.FUserID
where 1=1 
AND v1.FTranType=1 
AND v1.FCancellation = 0 AND FMultiCheckLevel1 is not null
AND v1.FDate>='2011-01-01'

Insert Into #data(FBillNo,FInterID,FEntryID,FUserID,FUserName
)
select FBillNo,FInterID,FEntryID,FUserID,FUserName from #temp where FMaxCheckLevel>FCurLevel and (FCurLevel+1)=FCheckLevel and FUserID=@FUserID group by FBillNo,FInterID,FEntryID,FUserID,FUserName

Select count(*)
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
INNER JOIN #data d on u1.FInterID=d.FInterID and u1.FEntryID=d.FEntryID
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%')
end


execute task_wgrk 'chenxian'

execute list_task_wgrk 'chenxian','','2011-01-01','2011-11-30'


