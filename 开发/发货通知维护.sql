--drop procedure list_fhtz drop procedure list_fhtz_count

create procedure list_fhtz
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
FOrderID nvarchar(20) default('')
,FOutID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(10) default('')        --行关
,FStatus nvarchar(10) default('')             --关闭
,FDate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
,jskc decimal(28,2) default(0)    
,cksl decimal(28,2) default(0)         
)

create table #Data(
FOrderID nvarchar(20) default('')
,FOutID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(10) default('')
,FStatus nvarchar(10) default('')
,FDate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
,jskc decimal(28,2) default(0)          
,cksl decimal(28,2) default(0)    
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


Insert Into #temp(FOrderID,FOutID,FCheck,FCloseStatus,FStatus,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,jskc,cksl
)
Select top 2000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FOutID,
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,case  when v1.FClosed=1 then 'Y' else '' end as FCloseStatus,case when v1.FStatus=3 then 'Y' else '' end as FStatus,Convert(char(10),v1.Fdate,111) as Fdate,
v1.FBillNo as FBillNo,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',t17.FName as 'cpmc',t17.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',t17.FNumber as 'cpdm',h.FBUQty as 'jskc',x.FQty as 'cksl'
from SEOutStock v1 INNER JOIN SEOutStockEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN (select b.FSourceInterId,b.FSourceEntryId,sum(b.FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=21 AND a.FCancellation = 0 group by b.FSourceInterId,b.FSourceEntryId) x on u1.FInterID=x.FSourceInterId and u1.FEntryId=x.FSourceEntryId
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
left join (
Select SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t1.FItemID AS FItemID 
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
	and t2.FItemID <> '4527'             --废品（工废）库
	and t2.FItemID <> '4528'             --可利用库
	and t2.FItemID <> '4739'             --返工返修库
	and t2.FItemID <> '5272'             --料废库
	and t2.FItemID <> '5888'             --封存库
group by t1.FItemID
) h on u1.FItemID=h.FItemID
 where 1=1 
AND (v1.FTranType=83 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or t17.FNumber like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FClosed like '%'+@status+'%'
order by v1.FBillNo,u1.FItemID

if @orderby='null'
exec('Insert Into #Data(FOrderID,FOutID,FCheck,FCloseStatus,FStatus,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,jskc,cksl)select * from #temp')
else
exec('Insert Into #Data(FOrderID,FOutID,FCheck,FCloseStatus,FStatus,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,jskc,cksl)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FBillNo,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from SEOutStock v1 INNER JOIN SEOutStockEntry u1 ON     v1.FInterID = u1.FInterID   AND 
u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND (v1.FTranType=83 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or t17.FNumber like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FClosed like '%'+@status+'%'
select * from #Data 
end

--------count---------

create procedure list_fhtz_count
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
FOrderID nvarchar(20) default('')
,FOutID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(10) default('')
,FDate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
)

create table #Data(
FOrderID nvarchar(20) default('')
,FOutID nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCloseStatus nvarchar(10) default('')
,FDate nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
)

Insert Into #temp(FOrderID,FOutID,FCheck,FCloseStatus,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm
)
Select top 2000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,cast(v1.FInterID as nvarchar(10))+cast(u1.FEntryID as nvarchar(10)) as FOutID,
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,v1.FClosed as FCloseStatus,Convert(char(10),v1.Fdate,111) as Fdate,
v1.FBillNo as FBillNo,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',t17.FName as 'cpmc',t17.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',t17.FNumber as 'cpdm'
from SEOutStock v1 INNER JOIN SEOutStockEntry u1 ON     v1.FInterID = u1.FInterID   AND 
u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND (v1.FTranType=83 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or t17.FNumber like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FClosed like '%'+@status+'%'
order by v1.FBillNo,u1.FItemID

if @orderby='null'
exec('Insert Into #Data(FOrderID,FOutID,FCheck,FCloseStatus,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm)select * from #temp')
else
exec('Insert Into #Data(FOrderID,FOutID,FCheck,FCloseStatus,Fdate,FBillNo,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FOrderID,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from SEOutStock v1 INNER JOIN SEOutStockEntry u1 ON     v1.FInterID = u1.FInterID   AND 
u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_ICItem t17 ON     u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
 LEFT JOIN t_user us On us.FUserID=v1.FBillerID
 LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
 where 1=1 
AND (v1.FTranType=83 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or t17.FName like '%'+@query+'%' 
or t17.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or t17.FNumber like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FClosed like '%'+@status+'%'
select count(*) from #Data 
end

execute list_fhtz '','2013-10-30','2013-10-30','0','cpmc','desc' 





select * from SEOutStock where 

select a.* from SEOutStock a left join SEOutStockEntry b on a.FInterID=b.FInterID where a.FDate='2013-10-30'

select i.FNumber,* from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID left join t_ICItem i on b.FItemID=i.FItemID where b.FInterID=3407 and b.FEntryID=3 --FBillNo='SEORD002079'

