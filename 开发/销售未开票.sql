--drop procedure list_xswkp drop procedure list_xswkp_count

create procedure list_xswkp 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
--@style int,
@huizong int,
@dwdm nvarchar(255),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FOrderID nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FHookStatus nvarchar(20) default('')
,FStatus nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
,cpph nvarchar(50) default('')
,kpsl decimal(28,2) default(0)          
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

create table #Data(
FOrderID nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FHookStatus nvarchar(20) default('')
,FStatus nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
,cpph nvarchar(50) default('')
,kpsl decimal(28,2) default(0)          
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,kpsl,hsdj,hsje
)
Select top 2000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID, Convert(char(10),v1.Fdate,111) as Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,
case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,CASE WHEN v1.FHookStatus=1 THEN 'P' 
WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,v1.FStatus as FStatus,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',i.FNumber as 'cpdm',u1.FBatchNo as 'cpph',
c1.FQty as 'kpsl',isnull(s1.FPriceDiscount,0) as 'hsdj',isnull(s1.FPriceDiscount,0)*u1.FQty as 'hsje'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN (
select b.FSourceInterID,b.FSourceEntryID,sum(b.FQty) as FQty 
from ICSale a 
inner join ICSaleEntry b on a.FInterID=b.FInterID and b.FInterID <>0 
where a.FTranType=80 and a.FCancellation = 0
group by FSourceInterID,FSourceEntryID
) c1 ON u1.FInterID=c1.FSourceInterID and u1.FEntryID=c1.FSourceEntryID
LEFT JOIN SEOrderEntry s1 on s1.FInterID=u1.FOrderInterID and s1.FEntryID=u1.FOrderEntryID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
AND v1.FStatus > 0
AND t4.FNumber like '%'+@dwdm+'%'
AND c1.FQty is null
order by v1.FBillNo,u1.FItemID

if @huizong=0
set @sqlstring='Insert Into #Data(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,kpsl,hsdj,hsje)select * from #temp'
if @huizong=1
set @sqlstring='Insert Into #Data(wldw,cpdm,cpmc,cpgg,jldw,fssl,kpsl,hsje)select wldw,cpdm,cpmc,cpgg,jldw,sum(fssl),sum(kpsl),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,jldw'
if @huizong=2
set @sqlstring='Insert Into #Data(wldw,fssl,kpsl,hsje)select wldw,sum(fssl),sum(kpsl),sum(hsje) from #temp group by wldw'


if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring+'order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data 
select * from #Data

/*if @style=0
begin
Insert Into  #Data(wldw,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data 
select * from #Data
end
else if @style=1
begin
Insert Into  #Data(wldw,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data where (kpsl is null or fssl<>kpsl)
select * from #Data where (kpsl is null or fssl<>kpsl)
end
else
begin
Insert Into  #Data(wldw,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data where kpsl is not null
select * from #Data where kpsl is not null
end*/
end

--count--
create procedure list_xswkp_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@style int,
@dwdm nvarchar(255),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FOrderID nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FHookStatus nvarchar(20) default('')
,FStatus nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
,cpph nvarchar(50) default('')
,kpsl decimal(28,2) default(0)          
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

create table #Data(
FOrderID nvarchar(20) default('')
,Fdate nvarchar(20) default('')
,FCheck nvarchar(20) default('')
,FCancellation nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FHookStatus nvarchar(20) default('')
,FStatus nvarchar(20) default('')
,dwdm nvarchar(20) default('')
,wldw nvarchar(100) default('')          
,ywy nvarchar(20) default('')
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,fssl decimal(28,2) default(0)          
,cpdm nvarchar(20) default('')
,cpph nvarchar(50) default('')
,kpsl decimal(28,2) default(0)          
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

Insert Into #temp(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,kpsl,hsdj,hsje
)
Select top 2000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID, Convert(char(10),v1.Fdate,111) as Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as 
FCheck,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,CASE WHEN v1.FHookStatus=1 THEN 'P' 
WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,v1.FStatus as FStatus,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',i.FNumber as 'cpdm',u1.FBatchNo as 'cpph',
c1.FQty as 'kpsl',u1.FConsignPrice as 'hsdj',u1.FConsignAmount as 'hsje'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN (
select b.FSourceInterID,b.FSourceEntryID,sum(b.FQty) as FQty 
from ICSale a 
inner join ICSaleEntry b on a.FInterID=b.FInterID and b.FInterID <>0 
where a.FTranType=80 and a.FCancellation = 0
group by FSourceInterID,FSourceEntryID
) c1 ON u1.FInterID=c1.FSourceInterID and u1.FEntryID=c1.FSourceEntryID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
AND v1.FStatus > 0
AND t4.FNumber like '%'+@dwdm+'%'
order by v1.FBillNo,u1.FItemID

if @orderby='null'
exec('Insert Into #Data(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,kpsl,hsdj,hsje)select * from #temp')
else
exec('Insert Into #Data(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,kpsl,hsdj,hsje)select * from #temp order by '+ @orderby+' '+ @ordertype)

/*Insert Into  #Data(Fdate,fssl,hsje)
Select '合计',sum(u1.FQty) as 'fssl',sum(u1.FConsignAmount) as 'hsje'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN (
select b.FSourceInterID,b.FSourceEntryID,sum(b.FQty) as FQty 
from ICSale a 
inner join ICSaleEntry b on a.FInterID=b.FInterID and b.FInterID <>0 
where a.FTranType=80 and a.FCancellation = 0
group by FSourceInterID,FSourceEntryID
) c1 ON u1.FInterID=c1.FSourceInterID and u1.FEntryID=c1.FSourceEntryID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
AND v1.FStatus > 0*/

if @style=0
begin
Insert Into  #Data(Fdate,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data 
select count(*) from #Data
end
else if @style=1
begin
Insert Into  #Data(Fdate,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data where (kpsl is null or fssl<>kpsl)
select count(*) from #Data where (kpsl is null or fssl<>kpsl)
end
else
begin
Insert Into  #Data(Fdate,fssl,hsje)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje' from #Data where kpsl is not null
select count(*) from #Data where kpsl is not null
end
end


execute list_xswkp '','2011-11-01','2011-11-30',1,'01.001','null',''

execute list_xswkp '','2011-11-01','2011-11-30',1,1,'01.001','null',''


select a.FBillNo,b.FEntryID,b.FSourceInterID,b.FSourceEntryID,b.FQty as FQty 
from ICSale a 
inner join ICSaleEntry b on a.FInterID=b.FInterID and b.FInterID <>0 
where a.FTranType=80 and a.FCancellation = 0
and FSourceInterID=22033 and FSourceEntryID=1
--group by FSourceInterID,FSourceEntryID

select * from ICSale a 
inner join ICSaleEntry b on a.FInterID=b.FInterID and b.FInterID <>0 
where a.FBillNo='XZP04708706-707' and b.FEntryID=89


select b.FInterID,b.FEntryID from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FBillNo='XOUT002982'

22033 1










SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select top 20000 u1.FDetailID as FListEntryID,v1.FVchInterID as FVchInterID,v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,v1.Fdate as 
Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,v1.FBillNo as FBillNo,CASE WHEN v1.FHookStatus=1 THEN 'P' WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,u1.FContractBillNo as 
FContractBillNo,v1.FStatus as FStatus,case when (v1.FROB <> 1) then 'Y' else '' end as FRedFlag, 0 As FBOSCloseFlag 
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 
ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0 
 LEFT OUTER JOIN t_SubMessage t7 ON     v1.FSaleStyle = t7.FInterID   AND t7.FInterID <>0 
 INNER JOIN t_Stock t8 ON     u1.FDCStockID = t8.FItemID   AND t8.FItemID <>0 
 LEFT OUTER JOIN t_Emp t9 ON     v1.FFManagerID = t9.FItemID   AND t9.FItemID <>0 
 LEFT OUTER JOIN t_Emp t10 ON     v1.FSManagerID = t10.FItemID   AND t10.FItemID <>0 
 INNER JOIN t_User t11 ON     v1.FBillerID = t11.FUserID   AND t11.FUserID <>0 
 INNER JOIN t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0 
 INNER JOIN t_MeasureUnit t17 ON     u1.FUnitID = t17.FItemID   AND t17.FItemID <>0 
 LEFT OUTER JOIN t_User t24 ON     v1.Fcheckerid = t24.FUserID   AND t24.FUserID <>0 
 INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0 
 LEFT OUTER JOIN t_SubMessage t40 ON     v1.FMarketingStyle = t40.FInterID   AND t40.FInterID <>0 
 LEFT OUTER JOIN v_ICTransType t70 ON     u1.FSourceTranType = t70.FID   AND t70.FID <>0 
 LEFT OUTER JOIN ICVoucherTpl t16 ON     v1.FPlanVchTplID = t16.FInterID   AND t16.FInterID <>0 
 LEFT OUTER JOIN ICVoucherTpl t13 ON     v1.FActualVchTplID = t13.FInterID   AND t13.FInterID <>0 
 LEFT OUTER JOIN t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0 
 LEFT OUTER JOIN t_Emp t106 ON     v1.FEmpID = t106.FItemID   AND t106.FItemID <>0 
 LEFT OUTER JOIN t_Emp t107 ON     v1.FManagerID = t107.FItemID   AND t107.FItemID <>0 
 LEFT OUTER JOIN t_AuxItem t112 ON     u1.FAuxPropID = t112.FItemid   AND t112.FItemid <>0 
 LEFT OUTER JOIN t_MeasureUnit t500 ON     t14.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0 
 LEFT OUTER JOIN t_Currency t503 ON     v1.FCurrencyID = t503.FCurrencyID   AND t503.FCurrencyID <>0 
 LEFT OUTER JOIN t_StockPlace t510 ON     u1.FDCSPID = t510.FSPID   AND t510.FSPID <>0 
 LEFT OUTER JOIN ZPStockBill t523 ON     v1.FInterID = t523.FRelateBillInterID   AND t523.FRelateBillInterID <>0 
 LEFT OUTER JOIN t_SonCompany t550 ON     v1.FRelateBrID = t550.FItemID   AND t550.FItemID <>0 
 LEFT OUTER JOIN t_MeasureUnit t552 ON     t14.FSecUnitID = t552.FItemID   AND t552.FItemID <>0 
 LEFT OUTER JOIN t_SonCompany t560 ON     v1.FBrID = t560.FItemID   AND t560.FItemID <>0 
 LEFT OUTER JOIN rtl_vip t650 ON   v1.FVIPCardId = t650.Fid  AND t650.Fid<>0 
 LEFT OUTER JOIN Rtl_WorkShift t651 ON   v1.FWorkShiftID = t651.FID  AND t651.FID<>0 
 LEFT OUTER JOIN CRM_ServiceRequest t800 ON   v1.FInterID = t800.FSourceInterID  AND t800.FSourceInterID<>0 
 LEFT OUTER JOIN t_Organization t44 ON   v1.FConsignee = t44.FItemID  AND t44.FItemID<>0 
 LEFT OUTER JOIN t_Organization t1001 ON   v1.FSupplyID = t1001.FItemID  AND t1001.FItemID<>0 
 LEFT OUTER JOIN t_ICItem t1002 ON   u1.FItemID = t1002.FItemID  AND t1002.FItemID<>0 
 where 1=1 
AND ( 
(
v1.FTranType = 21 
And  CONVERT( bigint, v1.FInterID )  * 100000  + u1.FEntryID IN (  
Select CONVERT( bigint, ICSaleEntry.FSourceInterId ) * 100000  + ICSaleEntry.FSourceEntryID FROM ICSale left join ICSaleEntry on ICSale.FInterID = ICSaleEntry.FInterID where ICSale.FInterID = 1407 AND ICSaleEntry.FEntryID IN ( 89 )  And ICSaleEntry.FSourceTranType = 21)
) AND v1.FTranType=21
)



Select CONVERT( bigint, ICSaleEntry.FSourceInterId ) * 100000  + ICSaleEntry.FSourceEntryID FROM ICSale left join ICSaleEntry on ICSale.FInterID = ICSaleEntry.FInterID where ICSale.FInterID = 1085 AND ICSaleEntry.FEntryID IN ( 1 )

select b.FSourceInterID ,b.* from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where b.FInterID=1085



