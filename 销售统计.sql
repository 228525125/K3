--drop procedure report_xsddhztj
--drop procedure report_xsddhztj_count

create procedure report_xsddhztj 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
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

Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
sum(b.FQty) as 'fssl',
MIN(b.FPrice) as 'wsdj',
MIN(b.FPriceDiscount) as 'hsdj',
SUM(b.FTaxAmt) as 'xxs',
SUM(b.FAllAmount) as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
group by d.FName,c.FNumber,c.FName,c.FModel,c.FHelpCode,e.FName 
order by d.fName,c.FName,c.FModel 

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '合计',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
select * from #Data 
end

--------------------count----------------------
create procedure report_xsddhztj_count 
@query varchar(10),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
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

Insert Into #Data(wldw,cpdm,cpmc,cpgg,cpth,jldw,fssl,wsdj,hsdj,xxs,hsje
)
select d.FName as 'wldw',c.FNumber as 'cpdm',c.FName as 'cpmc',c.FModel as 'cpgg',c.FHelpCode as 'cpth',e.FName as 'jldw',
sum(b.FQty) as 'fssl',
MIN(b.FPrice) as 'wsdj',
MIN(b.FPriceDiscount) as 'hsdj',
SUM(b.FTaxAmt) as 'xxs',
SUM(b.FAllAmount) as 'hsje'
from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate 
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
group by d.FName,c.FNumber,c.FName,c.FModel,c.FHelpCode,e.FName 
order by d.fName,c.FName,c.FModel 

Insert Into  #Data(wldw,fssl,xxs,hsje)
select '合计',sum(b.FQty) as FQty,SUM(b.FTaxAmt) as FTaxAmt,SUM(b.FAllAmount) as FAllAmount from SEOrder a 
left join (select FBillNo,FItemID,FUnitID,sum(FQty) as FQty,min(FPrice) as FPrice,min(FPriceDiscount) as FPriceDiscount,sum(FTaxAmt) as FTaxAmt,sum(FAllAmount) as FAllAmount,max(a.FDate) as FDate from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FCancellation=0 group by FBillNo,FItemID,FUnitID) b on a.FBillNo=b.FBillNo 
left join t_ICItem c on b.FItemID=c.FItemID 
left join t_Organization d on a.FCustID=d.FItemID 
left join t_MeasureUnit e on e.FItemID=b.FUnitID 
where a.FCancellation=0 
and a.FDate>=@begindate and a.FDate<=@enddate
and (d.FName like '%'+@query+'%' or c.FNumber like '%'+@query+'%' or c.FName like '%'+@query+'%' or c.FModel like '%'+@query+'%' or c.FHelpCode like '%'+@query+'%')
select count(*) from #Data
end


execute report_xsddhztj '重庆横河川仪','2011-05-01','2011-05-31'

execute report_xsddhztj_count '2011-05-01','2011-05-31'





