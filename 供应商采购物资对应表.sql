
SELECT s.FNumber as FSNumber,s.FName as FSName,s.FPhone,s.FFax,s.FAddress,i.FNumber as FINumber,i.FName as FIName,i.FModel,sum(b.FQty) as FQty ,MIN(c.FPrice) as FPrice
FROM ICPurchase a
INNER JOIN ICPurchaseEntry b on a.FInterID=b.FInterID
LEFT JOIN t_supplier s on a.FSupplyID=s.FItemID
LEFT JOIN t_ICItem i on b.FItemID=i.FItemID
LEFT JOIN (
select b.FItemID,min(b.FPriceDiscount) as FPrice from ICPurchase a INNER JOIN ICPurchaseEntry b on a.FInterID=b.FInterID
INNER join (
	select b.FItemID,max(a.FDate) as FDate FROM ICPurchase a
	INNER JOIN ICPurchaseEntry b on a.FInterID=b.FInterID
	where 1=1 and a.FCancellation = 0 and a.FStatus=1
	group by b.FItemID
	) c on b.FItemID=c.FItemID and a.FDate=c.FDate
	group by b.FItemID
) c on b.FItemID=c.FItemID
where 1=1 
and a.FCancellation = 0 and a.FStatus=1
AND s.FDeleted = 0
group by s.FNumber,s.FName,s.FPhone,s.FFax,s.FAddress,i.FNumber,i.FName,i.FModel







/* Õ‚π∫»Îø‚
select s.FNumber,s.FName,s.FPhone,s.FFax,s.FAddress,u1.FQty, from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
AND s.FDeleted = 0
*/



select * from wwzc_wwjysqd where FDate = '2012-12-17' and fid=1139

delete wwzc_wwjysqd where FDate = '2012-12-17' and fid=1139


