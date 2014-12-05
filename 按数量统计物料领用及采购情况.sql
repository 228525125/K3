Select 
i.FNumber,i.FName,i.FModel,i.FHelpCode,
sum(u1.FQty) as 'fssl',Max(s.FQty) as 'rksl',max(s.FPrice) as 'dj',s.FName
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Department t4 ON v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (
select s.FName,i.FNumber,sum(u1.FQty) as FQty,max(u1.FPrice)*1.17 as FPrice
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
AND v1.FDate>='2011-01-01' AND  v1.FDate<='2011-12-31'
group by s.FName,i.FNumber
) s on s.FNumber=i.FNumber
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FDate>='2011-01-01' AND  v1.FDate<='2011-12-31'
AND left(i.FNumber,3)='02.'
group by i.FNumber,i.FNumber,i.FName,i.FModel,i.FHelpCode,s.FName
order by sum(u1.FQty) desc
