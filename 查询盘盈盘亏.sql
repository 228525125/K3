select FNumber,FItemID,FModel,MAX(FDate),sum(FAuxQty) from vwICBill_17 where FNumber in (
'01.01.02.029',
'01.01.02.037',
'01.01.02.041',
'01.01.02.042',
'01.01.06.009',
'01.01.06.016',
'01.01.06.034',
'01.01.06.048',
'01.01.06.050',
'01.01.08.002',
'01.01.08.003',
'01.01.15.009'
)
group by FNumber,FItemID,FModel



select * from vwICBill_17 where FNumber in (
'01.01.06.048'
)


select i.FNumber,sum(u1.FQty) from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_ICItem i ON     u1.FItemID = i.FItemID AND i.FItemID <>0 
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0
and i.FNumber in (
'01.01.02.029',
'01.01.02.037',
'01.01.02.041',
'01.01.02.042',
'01.01.06.009',
'01.01.06.016',
'01.01.06.034',
'01.01.06.048',
'01.01.06.050',
'01.01.08.002',
'01.01.08.003',
'01.01.15.009'
)
group by i.FNumber

