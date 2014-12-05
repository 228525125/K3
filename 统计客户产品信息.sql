------统计某个客户的品种信息------
select t4.FNumber,t4.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,sum(u1.FQty) as FQty, sum(u1.FAllAmount) as FAmount 
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization t4 ON v1.FCustID = t4.FItemID AND t4.FItemID <>0
where 1=1 
AND (v1.FTranType=81 AND (v1.FCancellation = 0))
and t4.FNumber in ('08.008','04.001','08.005','18.001')
AND v1.FDate>='2014-01-01' and v1.FDate<=getDate()
group by t4.FNumber,t4.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode
order by t4.FNumber,i.FNumber


select * from SEOrderEntry