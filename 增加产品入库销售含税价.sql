select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN (
	select u1.FItemID,max(u1.FTaxPrice) as FTaxPrice
	from ICSale v1 
	INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	INNER JOIN (select b.FItemID,max(a.FDate) as FDate from ICSale a INNER JOIN ICSaleEntry b ON a.FInterID = b.FInterID   AND b.FInterID <>0 where a.FTranType=80 AND  a.FCancellation = 0 group by b.FItemID) c on v1.FDate=c.FDate and u1.FItemID=c.FItemID
	where 1=1
	and v1.FTranType=80 AND v1.FCancellation = 0
	group by u1.FItemID
) c on u1.FItemID=c.FItemID
where 1=1
AND v1.FTranType=2 AND  v1.FCancellation = 0
and v1.FDate>='2013-01-01'

FEntrySelfA0239

update u1 set u1.FEntrySelfA0239=c.FTaxPrice from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN (
	select u1.FItemID,max(u1.FTaxPrice) as FTaxPrice
	from ICSale v1 
	INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	INNER JOIN (select b.FItemID,max(a.FDate) as FDate from ICSale a INNER JOIN ICSaleEntry b ON a.FInterID = b.FInterID   AND b.FInterID <>0 where a.FTranType=80 AND  a.FCancellation = 0 group by b.FItemID) c on v1.FDate=c.FDate and u1.FItemID=c.FItemID
	where 1=1
	and v1.FTranType=80 AND v1.FCancellation = 0
	group by u1.FItemID
) c on u1.FItemID=c.FItemID
where 1=1
AND v1.FTranType=2 AND  v1.FCancellation = 0
and v1.FDate>='2013-01-01'


select u1.FItemID,max(u1.FTaxPrice) as FTaxPrice
from ICSale v1 
INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN (select b.FItemID,max(a.FDate) as FDate from ICSale a INNER JOIN ICSaleEntry b ON a.FInterID = b.FInterID   AND b.FInterID <>0 where a.FTranType=80 AND  a.FCancellation = 0 group by b.FItemID) c on v1.FDate=c.FDate and u1.FItemID=c.FItemID
where 1=1
and v1.FTranType=80 AND v1.FCancellation = 0
group by u1.FItemID
order by u1.FItemID