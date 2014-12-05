--drop procedure report_wwgxjgfhz drop procedure report_wwgxjgfhz_count
 
create procedure report_wwgxjgfhz 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,cpth nvarchar(255) default('')
,cpdw nvarchar(255) default('')
,jgsl decimal(28,2) default(0)
,jgdj decimal(28,2) default(0)
)

Insert Into #Data(cpdm,cpmc,cpgg,cpth,cpdw,jgsl,jgdj
)
select i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,case when a.FReceiveQty<b.FQty then a.FReceiveQty else b.FQty end,a.FUnitPrice
FROM t_ICItem i 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID 
INNER JOIN (
select u1.FItemID,sum(u1.FReceiveQty) as FReceiveQty,sum(u1.FReceiveQty*u1.FUnitPrice)/sum(u1.FReceiveQty) as FUnitPrice 
from ICShop_SubcIn v1 
inner join ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID and u1.FInterID<>0
where v1.FCheckerID>0 
and v1.FDate>=@begindate and v1.FDate<=@enddate
--and v1.FDate>='2012-05-01' and v1.FDate<='2012-05-31'
group by u1.FItemID
) a on a.FItemID=i.FItemID 
INNER JOIN (
select u1.FItemID,sum(u1.FQty) as FQty 
from ICStockBill v1 
inner join ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
--and v1.FDate>='2012-05-01' and v1.FDate<='2012-05-31'
group by u1.FItemID 
) b on i.FItemID=b.FItemID 

select *,jgje=jgsl*jgdj from #Data
end

-------count-------
create procedure report_wwgxjgfhz_count 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,cpth nvarchar(255) default('')
,jgsl decimal(28,2) default(0)
,jgdj decimal(28,2) default(0)
)

Insert Into #Data(cpdm,cpmc,cpgg,cpth,jgsl,jgdj
)
select i.FNumber,i.FName,i.FModel,i.FHelpCode,case when a.FReceiveQty<b.FQty then a.FReceiveQty else b.FQty end,a.FUnitPrice
FROM t_ICItem i 
INNER JOIN (
select u1.FItemID,sum(u1.FReceiveQty) as FReceiveQty,avg(u1.FUnitPrice) as FUnitPrice 
from ICShop_SubcIn v1 
inner join ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID and u1.FInterID<>0
where v1.FCheckerID>0 
and v1.FDate>=@begindate and v1.FDate<=@enddate
--and v1.FDate>='2012-05-01' and v1.FDate<='2012-05-31'
group by u1.FItemID
) a on a.FItemID=i.FItemID 
INNER JOIN (
select u1.FItemID,sum(u1.FQty) as FQty 
from ICStockBill v1 
inner join ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
AND v1.FDate>=@begindate AND v1.FDate<=@enddate
--and v1.FDate>='2012-05-01' and v1.FDate<='2012-05-31'
group by u1.FItemID
) b on i.FItemID=b.FItemID 

select count(*) from #Data
end


execute report_wwgxjgfhz '2012-05-01','2012-05-31' 



select FItemID from ICMO 
