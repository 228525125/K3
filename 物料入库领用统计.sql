-----物料入库领用统计------
select a.FNumber as 'cpdm',a.FName as 'cpmc',a.FModel as 'cpgg',mu.FName as 'jldw', isnull(b.fssl,0) as 'rksl',isnull(c.fssl,0) as 'llsl'
from t_ICItem a
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
left join (
Select i.FNumber, sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON  v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON  u1.FItemID = i.FItemID   AND i.FItemID <>0 
where 1=1 
AND v1.FTranType=1 AND v1.FCancellation = 0
AND v1.FDate>='2013-01-01'
and left(i.FNumber,3)='08.'
AND v1.FStatus = 1
group by i.FNumber
) b on a.FNumber =b.FNumber
left join (
Select i.FNumber,sum(u1.FQty) as 'fssl'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where 1=1 
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FDate>='2013-01-01'
and left(i.FNumber,3)='08.'
AND v1.FStatus=1
group by i.FNumber
) c on a.FNumber=c.FNumber
where 1=1
and left(a.FNumber,3)='08.'
and a.FDeleted = 0
order by a.FNumber