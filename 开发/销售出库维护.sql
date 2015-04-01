--drop procedure list_xsck drop procedure list_xsck_count

create procedure list_xsck 
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
,note nvarchar(255) default('')
,hsdj decimal(28,2) default(0)          
,lh nvarchar(255) default('')
,khddh nvarchar(255) default('')
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
,note nvarchar(255) default('')
,hsdj decimal(28,2) default(0)          
,lh nvarchar(255) default('')
,khddh nvarchar(255) default('')
)

Insert Into #temp(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,note,hsdj,lh,khddh
)
Select top 2000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID, Convert(char(10),v1.Fdate,111) as Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as 
FCheck,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,CASE WHEN v1.FHookStatus=1 THEN 'P' 
WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,v1.FStatus as FStatus,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',i.FNumber as 'cpdm',u1.FBatchNo as 'cpph',u1.FNote as 'note',u1.FConsignPrice as 'hsdj',
case when b.lh is null or b.lh = '' then c.lh else b.lh end as lh,u1.FEntrySelfB0161 as 'khddh'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN(select b.FBatchNo as ph,MAX(b.FEntrySelfT0241) as lh,MAX(b.FEntrySelfT0242) as bz from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0  group by b.FBatchNo) b on u1.FBatchNo=b.ph
LEFT JOIN(select ph,max(lh) as lh from rss.dbo.pclh where ph is not null group by ph) c on u1.FBatchNo=c.ph
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%' --or u1.FOrderBillNo like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo,u1.FItemID

if @orderby='null'
exec('Insert Into #Data(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,note,hsdj,lh,khddh)select * from #temp')
else
exec('Insert Into #Data(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph,note,hsdj,lh,khddh)select * from #temp order by '+ @orderby+' '+ @ordertype)



Insert Into  #Data(Fdate,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%' --or u1.FOrderBillNo like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end


------count-----

create procedure list_xsck_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10)
as 
begin
SET NOCOUNT ON 
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
)

Insert Into #Data(FOrderID,Fdate,FCheck,FCancellation,FBillNo,FHookStatus,FStatus,dwdm,wldw,ywy,cpmc,cpgg,jldw,fssl,cpdm,cpph
)
Select top 2000 cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) as FOrderID,Convert(char(10),v1.Fdate,111) as Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as 
FCheck,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,CASE WHEN v1.FHookStatus=1 THEN 'P' 
WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,v1.FStatus as FStatus,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',i.FNumber as 'cpdm',u1.FBatchNo as 'cpph'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%' --or u1.FOrderBillNo like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'

Insert Into  #Data(Fdate,fssl)
Select '合计',sum(u1.FQty) as 'fssl'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%' --or u1.FOrderBillNo like '%'+@query+'%' or u1.FSourceBillNo like '%'+@query+'%' 
or cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = @query)
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end


execute list_xsck '1127','2010-02-01','2010-02-28','','cpmc','desc'

execute list_xsck 'SEORD002238','2000-01-01','2099-12-31',''

execute list_xsck_count 'SEORD002238','2000-01-01','2099-12-31',''




SELECT * FROM ICStockBill

SELECT b.* FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo like 'XOUT004727'


select * from t_Organization





Select top 2000 Convert(char(10),v1.Fdate,111) as Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as 
FCheck,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,CASE WHEN v1.FHookStatus=1 THEN 'P' 
WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,v1.FStatus as FStatus,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',i.FNumber as 'cpdm'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
--AND (cast(u1.FOrderInterID as nvarchar(10))+cast(u1.FOrderEntryID as nvarchar(10)) = '35931')
AND (cast(u1.FOrderInterID as nvarchar(10)) = '3593')

select * from ICStockBillEntry where FOrderInterID='1127'

execute list_xsck '','2014-01-01','2014-01-31',''



Select i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND t4.FNumber='01.001'
AND v1.FDate>='2013-01-01'
group by i.FNumber,i.FName,i.FModel,mu.FName



SELECT u1.FEntrySelfB0161,r1.FEntrySelfS0161 
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
left join SEOrderEntry r1 ON r1.FInterID = u1.FOrderInterID   AND r1.FEntryID = u1.FOrderEntryID
WHERE 1=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2014-06-01'
and r1.FEntrySelfS0161 is not null and r1.FEntrySelfS0161 <> ''

update u1 set u1.FEntrySelfB0161=r1.FEntrySelfS0161
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
left join SEOrderEntry r1 ON r1.FInterID = u1.FOrderInterID   AND r1.FEntryID = u1.FOrderEntryID
WHERE 1=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2014-06-01'
and r1.FEntrySelfS0161 is not null and r1.FEntrySelfS0161 <> ''


select FSaleStyle,* from ICStockBill v1
where 1=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
and v1.FBillNo='XOUT010303'
FSaleStyle=102

UPDATE ICStockBill SET FSaleStyle=102
where 1=1
and FBillNo='XOUT010303'



select u1.* from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
and (v1.FBillNo like '%XOUT001107A%' or v1.FBillNo like '%XOUT001410%')

select u1.* from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
and (v1.FBillNo like '%XOUT001410%')


45.0000000000	
5130.00

FConsignPrice = 45 and FConsignAmount = 5130.00

select * from 

update u1 set u1.FConsignPrice = 45 ,u1.FConsignAmount = -5130.00
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
and (v1.FBillNo like '%XOUT001410%')



select i.FNumber,i.FName,i.FModel,i.FHelpCode from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID AND t4.FItemID <>0
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
and t4.FNumber='01.001'
group by i.FNumber,i.FName,i.FModel,i.FHelpCode
order by i.FNumber


select * from t_Organization


select u1.FSourceInterId,FSourceEntryId from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FDate='2014-12-02'


-----------2014-11-12 修改单价---------
select u1.FQty,u1.FConsignPrice,u1.FConsignAmount,u1.* from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FBillNo='XOUT003106' AND i.FNumber='05.01.0013'

update u1 set u1.FConsignPrice=0,u1.FConsignAmount=0 from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FBillNo='XOUT003106' AND i.FNumber='05.01.0013'


select * from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where FBillNo='XOUT011821'

FEntrySelfB0161