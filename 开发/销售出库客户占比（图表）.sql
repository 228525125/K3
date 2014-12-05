--drop procedure chart_pie_xsck 

create procedure chart_pie_xsck 
@begin nvarchar(255),
@end nvarchar(255),
@huizong int
as 
begin
SET NOCOUNT ON 
create table #Data(
FName nvarchar(255),
FAllAmount decimal(28,2) default(0)
)

create table #temp(
wldw nvarchar(255),
wlmc nvarchar(255),
FAllAmount decimal(28,2) default(0)
)

DECLARE @FCount decimal(28,2)
DECLARE @sqlstring nvarchar(255)

Insert Into #temp(wldw,wlmc,FAllAmount
)
select left(o1.FName,4),left(i.FName,4),u1.FQty*a1.FPriceDiscount as FAllAmount 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN SEOrderEntry a1 on u1.FOrderInterID=a1.FInterID and u1.FOrderEntryID=a1.FEntryID 
LEFT JOIN SEOrder a2 on a1.FInterID = a2.FInterID
LEFT JOIN t_Organization o1 on o1.FItemID=v1.FSupplyID
LEFT JOIN t_ICItem i on i.FItemID=u1.FItemID
where 1=1 
AND v1.FTranType=21 AND v1.FCancellation = 0 AND v1.FStatus>0
AND a2.FAreaPS=20302                                           --销售范围：购销
AND v1.FDate>=@begin AND  v1.FDate<=@end   

if @huizong=1          -- 汇总依据：客户
set @sqlstring='Insert Into #Data(FName,FAllAmount)select top 7 wldw,sum(FAllAmount) from #temp group by wldw order by sum(FAllAmount) desc'
if @huizong=2          -- 汇总依据：物料
set @sqlstring='Insert Into #Data(FName,FAllAmount)select top 7 wlmc,sum(FAllAmount) from #temp group by wlmc order by sum(FAllAmount) desc'

exec(@sqlstring)

select @FCount=sum(u1.FQty*a1.FPriceDiscount)
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN SEOrderEntry a1 on u1.FOrderInterID=a1.FInterID and u1.FOrderEntryID=a1.FEntryID 
LEFT JOIN SEOrder a2 on a1.FInterID = a2.FInterID
LEFT JOIN t_Organization o1 on o1.FItemID=v1.FSupplyID
where 1=1 
AND v1.FTranType=21 AND v1.FCancellation = 0 AND v1.FStatus>0
AND a2.FAreaPS=20302                                           --销售范围：购销
AND v1.FDate>=@begin AND  v1.FDate<=@end

Insert Into #Data(FName,FAllAmount
)
select '其他',@FCount-SUM(FAllAmount) from #Data

select * from #Data
end


execute chart_pie_xsck '2011-12-01','2011-12-30',2


select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 
AND v1.FTranType=21 AND v1.FCancellation = 0 AND v1.FStatus>0


select * from t_Organization where FItemID=127

select left('123',8)