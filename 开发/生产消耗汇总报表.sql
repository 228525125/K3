select a.FBillNo,Convert(char(10),a.FCheckDate,120) as FDate,case when a.FStatus=0 then '计划' when a.FStatus=5 then '确认' when a.FStatus=1 then '下达' when a.FStatus=3 then '结案' else '' end as FStatus,
i1.FNumber as 'cpdm',i1.FName as 'cpmc',i1.FModel as 'cpgg',i1.FHelpCode as 'cpth',mu1.FName as 'cpdw',a.FGMPBatchNo as 'cpph',a.FQty as 'jhsl', 
i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu2.FName as 'wldw',c.FQty as 'tlsl',d.FQty as 'llsl',f.FQty as 'bfsl',e.FQty as 'rksl'
from ICMO a
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
LEFT JOIN (
select u1.FSourceBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 
group by u1.FSourceBillNo,u1.FItemID
) d on a.FBillNo=d.FSourceBillNo and c.FItemID=d.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=2 AND  v1.FCancellation = 0
group by u1.FICMOBillNo,u1.FItemID
) e on a.FBillNo=e.FICMOBillNo and a.FItemID=e.FItemID
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0
group by u1.FICMOBillNo,u1.FItemID
) f on a.FBillNo=f.FICMOBillNo and c.FItemID=f.FItemID
where 1=1

--group by i1.FNumber


select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=2 AND  v1.FCancellation = 0
and u1.FICMOBillNo like '%9111%'
group by u1.FICMOBillNo,u1.FItemID

select FItemID from ICMO where FBillNo='WORK009111'



select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty,i.FName,i.FNumber from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON v1.FInterID = u1.FInterID  AND u1.FInterID<>0
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
group by u1.FICMOBillNo,u1.FItemID,i.FName,i.FNumber

