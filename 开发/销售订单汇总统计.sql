--drop procedure report_xsddhztj drop procedure report_xsddhztj_count

create procedure report_xsddhztj 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@FMrpClosed nvarchar(10),
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
,fhje decimal(28,2) default(0)          --发货金额
,wfhje decimal(28,2) default(0)          --未发货金额
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
,fhje decimal(28,2) default(0)          --发货金额
,wfhje decimal(28,2) default(0)          --未发货金额
)

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje,fhje,wfhje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
b.FQty as 'fssl',
b.FPrice as 'wsdj',
b.FPriceDiscount as 'hsdj',
b.FTaxAmt as 'xxs',
b.FAllAmount as 'hsje',
b.fhje as 'fhje',
b.FAllAmount - b.fhje as 'wfhje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,FMrpClosed,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate,sum(FStockQty*FPriceDiscount) as fhje from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID,FMrpClosed) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1
and a.FCancellation=0     --未作废的单据
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
and b.FMrpClosed like '%'+@FMrpClosed+'%'
order by d.fName,c.FName,c.FModel

if @huizong=1          -- 汇总依据：客户
set @sqlstring='Insert Into #Data(wldw,fssl,wsdj,hsdj,xxs,hsje,fhje,wfhje)select wldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje),sum(fhje),sum(wfhje) from #temp group by wldw'
else if @huizong=2     -- 汇总依据：客户、品规
set @sqlstring = 'Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje,fhje,wfhje)select wldw,cpdm,cpmc,cpgg,cpth,jldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje)sum(fhje),sum(wfhje) from #temp group by wldw,cpdm,cpmc,cpgg,cpth,jldw'

if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring + ' order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '合计',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,FMrpClosed,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate,sum(FStockQty*FPriceDiscount) as fhje from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID,FMrpClosed) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1 
and a.FCancellation=0     --未作废的单据
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
and b.FMrpClosed like '%'+@FMrpClosed+'%'

select * from #Data
end

select * from SEOrderEntry

--------------------count----------------------
create procedure report_xsddhztj_count 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@FMrpClosed nvarchar(10),
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
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
b.FQty as 'fssl',
b.FPrice as 'wsdj',
b.FPriceDiscount as 'hsdj',
b.FTaxAmt as 'xxs',
b.FAllAmount as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,FMrpClosed,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate,sum(FStockQty*FPriceDiscount) as fhje from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID,FMrpClosed) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1
and a.FCancellation=0     --未作废的单据
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
and b.FMrpClosed like '%'+@FMrpClosed+'%'
order by d.fName,c.FName,c.FModel

if @huizong=1          -- 汇总依据：客户
set @sqlstring='Insert Into #Data(wldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw'
else if @huizong=2     -- 汇总依据：客户、品规
set @sqlstring = 'Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje)select wldw,cpdm,cpmc,cpgg,cpth,jldw,sum(fssl),max(wsdj),max(hsdj),sum(xxs),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,cpth,jldw'

if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring + ' order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '合计',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,FMrpClosed,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate,sum(FStockQty*FPriceDiscount) as fhje from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID,FMrpClosed) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FStatus>=1 
and a.FCancellation=0     --未作废的单据
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
and b.FMrpClosed like '%'+@FMrpClosed+'%'
select count(*) from #Data
end


execute report_xsddhztj '','2011-11-01','2011-11-30',1,'','null',''

execute report_xsddhztj_count '重庆横河','2011-11-01','2011-11-30',2,'null',''



/*select * from SEOrder where FBillNo='SEORD000105' 
and FClosed=1        --0：未行业务关闭；1：行业务关闭
and FStatus=1        --0：保存；1：审核状态；3：关闭状态*/


113554.00	1965.81	2300.00	253120.33	1742064.11

