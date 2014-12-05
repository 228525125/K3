--drop procedure report_xsckhztj drop procedure report_xsckhztj_count

create procedure report_xsckhztj 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldw nvarchar(100) default('')          --客户名称
,cpdm nvarchar(20) default('')           --物料代码
,cpmc nvarchar(255) default('')           --物料名称
,cpgg nvarchar(255) default('')           --规格
,cpth nvarchar(20) default('')           --图号
,jldw nvarchar(20) default('')           --计量单位
,fssl decimal(28,2) default(0)          --订单数量
,wsdj decimal(28,2) default(0)          --含税单价
,hsdj decimal(28,2) default(0)          --含税单价
,xxs decimal(28,2) default(0)          --税额
,hsje decimal(28,2) default(0)          --含税金额
)

create table #Data(
wldw nvarchar(100) default('')          --客户名称
,cpdm nvarchar(20) default('')           --物料代码
,cpmc nvarchar(255) default('')           --物料名称
,cpgg nvarchar(255) default('')           --规格
,cpth nvarchar(20) default('')           --图号
,jldw nvarchar(20) default('')           --计量单位
,fssl decimal(28,2) default(0)          --订单数量
,wsdj decimal(28,2) default(0)          --含税单价
,hsdj decimal(28,2) default(0)          --含税单价
,xxs decimal(28,2) default(0)          --税额
,hsje decimal(28,2) default(0)          --含税金额
)

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select t4.FName as 'wldw',i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',i.FHelpCode as 'cpth',mu.FName as 'jldw',
u1.FQty as 'fssl',
u1.FConsignPrice/1.17 as 'wsdj',
u1.FConsignPrice as 'hsdj',
u1.FConsignAmount*0.17 as 'xxs',
u1.FConsignAmount as 'hsje'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
order by v1.FBillNo,u1.FItemID

if @huizong=1          -- 汇总依据：客户
set @sqlstring='Insert Into #Data(wldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw'
else if @huizong=2     -- 汇总依据：客户、品规
set @sqlstring = 'Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,cpdm,cpmc,cpgg,cpth,jldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,cpth,jldw'

if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring + ' order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '合计',sum(fssl),sum(xxs),sum(hsje) from #temp

select * from #Data
end

--count--
create procedure report_xsckhztj_count 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldw nvarchar(100) default('')          --客户名称
,cpdm nvarchar(20) default('')           --物料代码
,cpmc nvarchar(255) default('')           --物料名称
,cpgg nvarchar(255) default('')           --规格
,cpth nvarchar(20) default('')           --图号
,jldw nvarchar(20) default('')           --计量单位
,fssl decimal(28,2) default(0)          --订单数量
,wsdj decimal(28,2) default(0)          --含税单价
,hsdj decimal(28,2) default(0)          --含税单价
,xxs decimal(28,2) default(0)          --税额
,hsje decimal(28,2) default(0)          --含税金额
)

create table #Data(
wldw nvarchar(100) default('')          --客户名称
,cpdm nvarchar(20) default('')           --物料代码
,cpmc nvarchar(255) default('')           --物料名称
,cpgg nvarchar(255) default('')           --规格
,cpth nvarchar(20) default('')           --图号
,jldw nvarchar(20) default('')           --计量单位
,fssl decimal(28,2) default(0)          --订单数量
,wsdj decimal(28,2) default(0)          --含税单价
,hsdj decimal(28,2) default(0)          --含税单价
,xxs decimal(28,2) default(0)          --税额
,hsje decimal(28,2) default(0)          --含税金额
)

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select t4.FName as 'wldw',i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',i.FHelpCode as 'cpth',mu.FName as 'jldw',
u1.FQty as 'fssl',
u1.FConsignPrice/1.17 as 'wsdj',
u1.FConsignPrice as 'hsdj',
u1.FConsignAmount*0.17 as 'xxs',
u1.FConsignAmount as 'hsje'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or u1.FQty like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
order by v1.FBillNo,u1.FItemID

if @huizong=1          -- 汇总依据：客户
set @sqlstring='Insert Into #Data(wldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw'
else if @huizong=2     -- 汇总依据：客户、品规
set @sqlstring = 'Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,cpdm,cpmc,cpgg,cpth,jldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,cpth,jldw'

if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring + ' order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '合计',sum(fssl),sum(xxs),sum(hsje) from #temp

select count(*) from #Data
end

execute report_xsckhztj '金属缠绕','2013-01-01','2013-12-30',2,'null',''


execute report_xsckhztj_count '','2011-11-01','2011-11-30',2,'null',''



---------------
select i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',
sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2013-03-01' AND  v1.FDate<='2013-09-01'
AND (
FModel like '%PT0001-04%' 
or FModel like '%PT0005-04%' 
or FModel like '%PT0009-04%' 
or FModel like '%PT0003-04%' 
or FModel like '%PT0007-04%' 
or FModel like '%PT0011-04%' 
or FModel like '%PT0180/1%'
or FModel like '%PT0031-03%' 
or FModel like '%3KXT001145U0300%'
or FModel like '%3KXT001153U0300%'
or FModel like '%3KXT001154U0300%'
or FModel like '%3KXT001142U0300%'
or FModel like '%3KXT001146U0300%'
or FModel like '%3KXT001149U0300%'
or FModel like '%3KXT001149U0200%'
or FModel like '%3KXT001158U0300%'
or FModel like '%ANSI B16.5 1%'
or FModel like '%ANSI B16.5(88) 1″150%'
or FModel like '%ANSI B16.5(88) 1″300%'
or FModel like '%PT0019-03%'
or FModel like '%PT0021-03%'
or FModel like '%PT0023-03%'
or FModel like '%PT0025-03%'
or FModel like '%PT0027-03%'
or FModel like '%PT0017-03%'
or FModel like '%PT0184/1%'
)
group by i.FNumber,i.FName,i.FModel
order by i.FNumber,i.FName,i.FModel

or FModel like '%%'

select FNumber,* from t_ICItem where 
FModel like '%PT0001-04%' 
or FModel like '%PT0005-04%' 
or FModel like '%PT0009-04%' 
or FModel like '%PT0003-04%' 
or FModel like '%PT0007-04%' 
or FModel like '%PT0011-04%' 
or FModel like '%PT0180/1%'
or FModel like '%PT0031-03%' 
or FModel like '%3KXT001145U0300%'
or FModel like '%3KXT001153U0300%'
or FModel like '%3KXT001154U0300%'
or FModel like '%3KXT001142U0300%'
or FModel like '%3KXT001146U0300%'
or FModel like '%3KXT001149U0300%'
or FModel like '%3KXT001149U0200%'
or FModel like '%3KXT001158U0300%'
or FModel like '%ANSI B16.5 1%'
or FModel like '%ANSI B16.5(88) 1″150%'
or FModel like '%ANSI B16.5(88) 1″300%'
or FModel like '%PT0019-03%'
or FModel like '%PT0021-03%'
or FModel like '%PT0023-03%'
or FModel like '%PT0025-03%'
or FModel like '%PT0027-03%'
or FModel like '%PT0017-03%'
or FModel like '%PT0184/1%'

select * from t_ICItem WHERE FModel like '%ANSI B16.5(88) 1″150%'


select * from t_Organization
