select datediff(month,b.FDate,getDate()),a.* 
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,FBatchNo,MIN(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (1,2,6,10) AND v1.FCancellation = 0 group by i.FNumber,FBatchNo
) b on a.dm=b.FNumber


select * from ICStockBillEntry

/* 最近销售时间(包括其他出库)
update a set a.zjxssj=Convert(char(10),b.FDate,120)
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (21,29) AND v1.FCancellation = 0 group by i.FNumber
) b on a.dm=b.FNumber
*/

/* 最近入库时间（外购入库、销售入库、其他入库、虚仓入库）
update a set a.zhrksj=Convert(char(10),b.FDate,120)
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (1,2,6,10) AND v1.FCancellation = 0 group by i.FNumber
) b on a.dm=b.FNumber
*/

/* 库龄
update a set kl=datediff(month,b.FDate,getDate())
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,FBatchNo,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (1,2,6,10) AND v1.FCancellation = 0 group by i.FNumber,FBatchNo
) b on a.dm=b.FNumber


select *from rss.dbo.kcdz1$


