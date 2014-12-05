--drop procedure count_task_cgsq drop procedure list_task_cgsq drop procedure list_task_cgsq_count

create procedure count_task_cgsq
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
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_MultiCheckOption a on v1.FTranType=a.FBillType
LEFT JOIN t_MultiLevelCheck b on a.FBillType=b.FBillType
LEFT JOIN t_User c on b.FCheckMan=c.FUserID
where 1=1 
AND v1.FCancellation = 0 AND FMultiCheckLevel1 is not null
AND v1.FDate>='2011-01-01'

select count(distinct FBillNo) from #temp where FMaxCheckLevel>FCurLevel and (FCurLevel+1)=FCheckLevel and FUserID=@FUserID
end

--list_task_cgsq--
create procedure list_task_cgsq
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

Create Table #TempInventory( 
                            [FBrNo] [varchar] (10)  NOT NULL ,
                            [FItemID] [int] NOT NULL ,
                            [FBatchNo] [varchar] (200)  NOT NULL ,
                            [FMTONo] [varchar] (200)  NOT NULL ,
                            [FStockID] [int] NOT NULL ,
                            [FQty] [decimal](28, 10) NOT NULL ,
                            [FBal] [decimal](20, 2) NOT NULL ,
                            [FStockPlaceID] [int] NULL ,
                            [FKFPeriod] [int] NOT NULL Default(0),
                            [FKFDate] [varchar] (255)  NOT NULL ,
                            [FMyKFDate] [varchar] (255), 
                            [FStockTypeID] [Int] NOT NULL,
                            [FQtyLock] [decimal](28, 10) NOT NULL,
                            [FAuxPropID] [int] NOT NULL,
                            [FSecQty] [decimal](28, 10) NOT NULL
                             )
Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),500,u1.FQtyLock,u1.FAuxPropID,u1.FSecQty From ICInventory u1 where u1.FQty<>0 

Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),u1.FStockTypeID,0,u1.FAuxPropID,u1.FSecQty From POInventory u1 where u1.FQty<>0 

Insert Into #temp(FBillNo,FInterID,FEntryID,FMaxCheckLevel,FCurLevel,FCheckLevel,FUserID,FUserName
)
select v1.FBillNo,v1.FInterID,u1.FEntryID,a.FMaxCheckLevel,
case when FMultiCheckLevel6 is not null then 6 when FMultiCheckLevel5 is not null then 5 when FMultiCheckLevel4 is not null then 4 when FMultiCheckLevel3 is not null then 3 when FMultiCheckLevel2 is not null then 2 when FMultiCheckLevel1 is not null then 1 else 0 end as 'FCurLevel',
b.FCheckLevel,c.FName as FUserID,c.FDescription as FUserName
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_MultiCheckOption a on v1.FTranType=a.FBillType
LEFT JOIN t_MultiLevelCheck b on a.FBillType=b.FBillType
LEFT JOIN t_User c on b.FCheckMan=c.FUserID
where 1=1 
AND v1.FCancellation = 0 AND FMultiCheckLevel1 is not null
AND v1.FDate>='2011-01-01'

Insert Into #data(FBillNo,FInterID,FEntryID,FUserID,FUserName
)
select FBillNo,FInterID,FEntryID,FUserID,FUserName from #temp where FMaxCheckLevel>FCurLevel and (FCurLevel+1)=FCheckLevel and FUserID=@FUserID group by FBillNo,FInterID,FEntryID,FUserID,FUserName

select case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',v1.FInterID,u1.FEntryID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',convert(char(10),u1.FFetchTime,120) as 'dhrq',us.FDescription as 'ywy',v1.FNote,FEntrySelfP0130 as 'bz',b.FSecInv as 'aqkc',isnull(h.FBUQty,0) as 'jcsl',
v1.FCurCheckLevel
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem t11 ON u1.FItemID = t11.FItemID   AND t11.FItemID <>0 
left join t_ICItemBase b on t11.FItemID=b.FItemID 
LEFT JOIN t_Supplier t15 ON u1.FSupplyID = t15.FItemID AND t15.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
INNER JOIN #data d on u1.FInterID=d.FInterID and u1.FEntryID=d.FEntryID
left join (
Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FNumber AS FLongNumber 
From #TempInventory u1
left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
and t1.FDeleted=0 
AND t2.FTypeID in (500,20291,20293)
and t2.FItemID <> '4527'             --∑œ∆∑£®π§∑œ£©ø‚
and t2.FItemID <> '4528'             --ø…¿˚”√ø‚
and t2.FItemID <> '4739'             --∑µπ§∑µ–ﬁø‚
and t2.FItemID <> '5272'             --¡œ∑œø‚
and t2.FItemID <> '5888'             --∑‚¥Êø‚
group by t1.FNumber
) h on t11.FNumber=h.FLongNumber
where 1=1 
AND v1.FCancellation = 0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
order by v1.FBillNo
end

--list_task_cgsq_count

create procedure list_task_cgsq_count
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
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_MultiCheckOption a on v1.FTranType=a.FBillType
LEFT JOIN t_MultiLevelCheck b on a.FBillType=b.FBillType
LEFT JOIN t_User c on b.FCheckMan=c.FUserID
where 1=1 
AND v1.FCancellation = 0 AND FMultiCheckLevel1 is not null
AND v1.FDate>='2011-01-01'

Insert Into #data(FBillNo,FInterID,FEntryID,FUserID,FUserName
)
select FBillNo,FInterID,FEntryID,FUserID,FUserName from #temp where FMaxCheckLevel>FCurLevel and (FCurLevel+1)=FCheckLevel and FUserID=@FUserID group by FBillNo,FInterID,FEntryID,FUserID,FUserName

select count(*)
from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem t11 ON u1.FItemID = t11.FItemID   AND t11.FItemID <>0 
LEFT JOIN t_Supplier t15 ON u1.FSupplyID = t15.FItemID AND t15.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
INNER JOIN #data d on u1.FInterID=d.FInterID and u1.FEntryID=d.FEntryID
where 1=1 
AND v1.FCancellation = 0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%'
or cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) = @query)
end

execute count_task_cgsq 'chenxian'

execute list_task_cgsq 'chenxian','','2011-01-01','2011-12-31'

execute list_task_cgsq_count 'chenxian','','2011-12-01','2011-12-31'

select * from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where FMultiCheckLevel1 = 16416

select * from t_user where FName='0022'

16416

select * from POrequest where FBillNo='POREQ001330'

update POrequest set FCurCheckLevel=1 where FBillNo in ('POREQ001319')


select * from POrequest where FMultiCheckDate1 is not null and FCurCheckLevel is null

select * from POrequest where FCurCheckLevel =4


