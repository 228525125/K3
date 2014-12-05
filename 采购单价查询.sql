
--最后一次采购发票含税单价
select b.FItemID,c.FNumber,avg(b.FTaxPrice) as FTaxPrice
from ICPurchase a 
left join ICPurchaseEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID 
left join (select b.FItemID,MAX(a.FDate) as FDate from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID group by b.FItemID) d on b.FItemID=d.FItemID
where a.FDate=d.FDate
group by b.FItemID,c.FNumber


select c.FNumber,c.FName,c.FModel,max(d.FTaxPrice) from t_ICItem c
left join (
select b.FItemID,c.FNumber,avg(b.FTaxPrice) as FTaxPrice
from ICPurchase a 
left join ICPurchaseEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID 
left join (select b.FItemID,MAX(a.FDate) as FDate from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID group by b.FItemID) d on b.FItemID=d.FItemID
where a.FDate=d.FDate
group by b.FItemID,c.FNumber
) d on c.FItemID=d.FItemID
where 1=1
AND c.FNumber in (
'03.01.168',
'03.01.100',
'03.01.101',
'03.01.121',
'03.02.034',
'03.02.043',
'03.02.142',
'03.02.064',
'03.01.001',
'03.01.004',
'03.01.023',
'03.01.427',
'03.01.428',
'03.02.144',
'03.01.420',
'03.01.032'
)
group by c.FNumber,c.FName,c.FModel

select v1.FBillNo,c.FNumber,c.FName,c.FModel,u1.FQty,a.FTaxPrice from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN (
select b.FItemID,c.FNumber,avg(b.FTaxPrice) as FTaxPrice
from ICPurchase a 
left join ICPurchaseEntry b on a.FInterID=b.FInterID 
left join t_ICItem c on b.FItemID=c.FItemID 
left join (select b.FItemID,MAX(a.FDate) as FDate from ICPurchase a left join ICPurchaseEntry b on a.FInterID=b.FInterID group by b.FItemID) d on b.FItemID=d.FItemID
where a.FDate=d.FDate
group by b.FItemID,c.FNumber) a on u1.FItemID=a.FItemID
left join t_ICItem c on u1.FItemID=c.FItemID
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND FBillNo in ('SOUT019088','SOUT018639')



