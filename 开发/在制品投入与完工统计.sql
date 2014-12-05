
--在制品表 以材料计
SELECT i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,a.FQty as 'llsl',b.FQty as 'xhsl' 
FROM t_ICItem i 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID 
LEFT JOIN (
select b.FItemID,sum(b.FQty) as FQty
from ICStockBill a 
inner join ICStockBillEntry b on a.FInterID=b.FInterID
where a.FTranType=24 
AND a.FCancellation = 0 
AND a.FStatus = 1 
and a.FDate>='2014-03-01' 
and a.FDate<='2014-03-31'
and b.FICMOInterID>0             --必须是生产任务单投料 , 如果只有成本对象还不行，因为不晓得标准用量，就不能计算出消耗
group by b.FItemID
) a on i.FItemID=a.FItemID
left join (
select p.FItemID,sum(p.FAuxQtyScrap*u1.FQty) as FQty from ICStockBill v1
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
left join PPBOMEntry p on u1.FICMOInterID=p.FICMOInterID 
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0
and v1.FStatus=1 
AND v1.FDate>='2014-03-01' AND  v1.FDate<='2014-03-31'
AND u1.FICMOInterID > 0
group by p.FItemID
) b on i.FItemID=b.FItemID
where 1=1
and (a.FQty is not null or b.FQty is not null)


--在制品以产品计，默认生产任务单下达就表示投入
select i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,a.FQty as 'tlsl',b.FQty as 'rksl'
from t_ICItem i
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID 
left join (
select FItemID,sum(FQty) as FQty from ICMO where 1=1 and FCheckDate>='2014-03-01' and FCheckDate<='2014-03-31' and FCancellation=0 and FStatus in (1,3) group by FItemID
) a on i.FItemID=a.FItemID
left join (
select u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1 
AND v1.FTranType=2 AND  v1.FCancellation = 0 and v1.FStatus=1
AND v1.FCheckDate>='2014-03-01' AND  v1.FCheckDate<='2014-03-31'
AND u1.FICMOInterID > 0
group by u1.FItemID 
) b on i.FItemID=b.FItemID
where 1=1
and (a.FQty is not null or b.FQty is not null)








select * from ICMO where 




select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 


select * from PPBOMEntry


select i.FNumber,sum(b.FQty) as FQty 
from ICStockBill a 
inner join ICStockBillEntry b on a.FInterID=b.FInterID
left join t_ICItem i on b.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where a.FTranType=24 
AND a.FCancellation = 0 
AND a.FStatus = 1 
--AND a.FROB=-1              --红字
and a.FDate>='2014-03-01' 
and a.FDate<='2014-03-31'
and b.FICMOInterID>0             --必须是生产任务单投料 , 如果只有成本对象还不行，因为不晓得标准用量，就不能计算出消耗
group by i.FNumber


select a.FBillNo,i.FNumber,b.FQty 
from ICStockBill a 
inner join ICStockBillEntry b on a.FInterID=b.FInterID
left join t_ICItem i on b.FItemID=i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where a.FTranType=24 
AND a.FCancellation = 0 
AND a.FStatus = 1 
and a.FDate>='2014-03-01' 
and a.FDate<='2014-03-31'

b.FICMOInterID,b.FPPBomEntryID 



select * from t_stock where FItemID=5272