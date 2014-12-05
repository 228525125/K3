--drop procedure report_xsfphztj drop procedure report_xsfphztj_count

create procedure report_xsfphztj 
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
u1.FPrice as 'wsdj',
u1.FTaxPrice as 'hsdj',
u1.FTaxAmount as 'xxs',
u1.FAmountincludetax as 'hsje'
from ICSale v1 
INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID   AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=80 AND  v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
order by v1.FBillNo

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
create procedure report_xsfphztj_count 
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
u1.FPrice as 'wsdj',
u1.FTaxPrice as 'hsdj',
u1.FTaxAmount as 'xxs',
u1.FAmountincludetax as 'hsje'
from ICSale v1 
INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_Organization t4 ON     v1.FCustID = t4.FItemID   AND t4.FItemID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID   AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=80 AND  v1.FCancellation = 0)
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (FBillNo like '%'+@query+'%' or t4.FNumber like '%'+@query+'%' or t4.FName like '%'+@query+'%' or us.FDescription like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%' or i.FNumber like '%'+@query+'%')
order by v1.FBillNo

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



select * from ICSale v1 
INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo='XZP00000282'


