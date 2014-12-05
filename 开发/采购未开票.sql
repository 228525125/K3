--drop procedure list_cgwkp drop procedure list_cgwkp_count

create procedure list_cgwkp 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@dwdm nvarchar(255),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')           
,kpsl decimal(28,2) default(0)
,wldw nvarchar(255) default('')           
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')  
,kpsl decimal(28,2) default(0)
,wldw nvarchar(255) default('')           
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,kpsl,wldw,hsdj,hsje
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',u1.FQtyInvoice as 'kpsl',s.FName as 'wldw',o.FPriceDiscount as 'hsdj',u1.FQty*o.FPriceDiscount as 'hsje' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN POOrderEntry o on o.FInterID=u1.FOrderInterID and o.FEntryID=u1.FOrderEntryID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 AND v1.FStatus>0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or s.FName like '%'+@query+'%')
AND s.FNumber like '%'+@dwdm+'%'
AND u1.FQtyInvoice=0  --开票数量为0
AND v1.FHookStatus=0  --没有核销
order by v1.FBillNo

if @huizong=0
set @sqlstring='Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,kpsl,wldw,hsdj,hsje)select * from #temp'
if @huizong=1
set @sqlstring='Insert Into #Data(wldw,cpdm,cpmc,cpgg,jldw,fssl,kpsl,hsje)select wldw,cpdm,cpmc,cpgg,jldw,sum(fssl),sum(kpsl),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,jldw'
if @huizong=2
set @sqlstring='Insert Into #Data(wldw,fssl,kpsl,hsje)select wldw,sum(fssl),sum(kpsl),sum(hsje) from #temp group by wldw'


if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring+'order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,hsje,kpsl)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje',sum(kpsl) as 'kpsl' from #Data 
select * from #Data
end

--count--
create procedure list_cgwkp_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@huizong int,
@dwdm nvarchar(255),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')           
,kpsl decimal(28,2) default(0)
,wldw nvarchar(255) default('')           
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

create table #Data(
FCheck nvarchar(255) default('')
,FCloseStatus nvarchar(255) default('')
,hywgb nvarchar(255) default('')
,FInterID nvarchar(255) default('')
,FBillNo nvarchar(255) default('')
,FCancellation nvarchar(255) default('')
,FSourceBillNo nvarchar(255) default('')
,FOrderInterID nvarchar(255) default('')
,FOrderEntryID nvarchar(255) default('')
,FDate nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(255) default('')           
,fssl decimal(28,2) default(0)          
,wlph nvarchar(255) default('')  
,kpsl decimal(28,2) default(0)
,wldw nvarchar(255) default('')           
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
)

DECLARE @sqlstring nvarchar(255)

Insert Into #temp(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,kpsl,wldw,hsdj,hsje
)
Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',u1.FQtyInvoice as 'kpsl',s.FName as 'wldw',o.FPriceDiscount as 'hsdj',u1.FQty*o.FPriceDiscount as 'hsje' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN POOrderEntry o on o.FInterID=u1.FOrderInterID and o.FEntryID=u1.FOrderEntryID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 AND v1.FStatus>0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or s.FName like '%'+@query+'%')
AND s.FNumber like '%'+@dwdm+'%'
AND u1.FQtyInvoice=0  --开票数量为0
AND v1.FHookStatus=0  --没有核销
order by v1.FBillNo

if @huizong=0
set @sqlstring='Insert Into #Data(FCheck,FCloseStatus,hywgb,FInterID,FBillNo,FCancellation,FSourceBillNo,FOrderInterID,FOrderEntryID,FDate,cpdm,cpmc,cpgg,jldw,fssl,wlph,kpsl,wldw,hsdj,hsje)select * from #temp'
if @huizong=1
set @sqlstring='Insert Into #Data(wldw,cpdm,cpmc,cpgg,jldw,fssl,kpsl,hsje)select wldw,cpdm,cpmc,cpgg,jldw,sum(fssl),sum(kpsl),sum(hsje) from #temp group by wldw,cpdm,cpmc,cpgg,jldw'
if @huizong=2
set @sqlstring='Insert Into #Data(wldw,fssl,kpsl,hsje)select wldw,sum(fssl),sum(kpsl),sum(hsje) from #temp group by wldw'


if @orderby='null'
exec(@sqlstring)
else
exec(@sqlstring+'order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(wldw,fssl,hsje,kpsl)
select '合计',sum(fssl) as 'fssl',sum(hsje) as 'hsje',sum(kpsl) as 'kpsl' from #Data 
select count(*) from #Data
end

execute list_cgwkp '','2011-01-01','2011-11-30',0,'','null',''

execute list_cgwkp '','2011-12-24','2011-12-24',0,'01.050','null','null'



select v1.FHookStatus,v1.FRelateInvoiceID,FQtyInvoice,FSupplyID,* from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1
AND v1.FTranType=1 AND  v1.FCancellation = 0 
--AND v1.FDate>='2011-12-01' and v1.FDate<='2011-12-30'
AND u1.FQtyInvoice=0
and v1.FBillNo='WIN001098'

select * from t_Supplier where FItemID=271


select * from t_Supplier









Select top 20000 case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,'' as FCloseStatus,'' as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FOrderInterID,u1.FOrderEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw', 
u1.FQty as 'fssl',u1.FBatchNo as 'wlph',u1.FQtyInvoice as 'kpsl',s.FName as 'wldw',o.FPriceDiscount as 'hsdj',u1.FQty*o.FPriceDiscount as 'hsje' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN POOrderEntry o on o.FInterID=u1.FOrderInterID and o.FEntryID=u1.FOrderEntryID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 AND v1.FStatus>0
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or s.FName like '%'+@query+'%')
AND s.FNumber like @dwdm
AND u1.FQtyInvoice=0  --开票数量为0
AND v1.FHookStatus=0  --没有核销
order by v1.FBillNo










