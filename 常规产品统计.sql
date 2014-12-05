
create table #temp(
FDate nvarchar(255),
FNumber nvarchar(255),
FName nvarchar(255),
FModel nvarchar(255),
FQty decimal(28,2) default(0)
)

Insert Into #temp(FDate,FNumber,FName,FModel,FQty
)
select convert(char(6),v1.FDate,112) as FDate,i.FNumber,i.FName,i.FModel,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_ICItem i on i.FItemID=u1.FItemID
where v1.FTranType in (2) and v1.FCancellation = 0 AND v1.FCheckerID>0
and v1.FDate>='2012-01-01' and v1.FDate<='2013-06-30'
and i.FErpClsID=2
group by i.FNumber,i.FName,i.FModel,convert(char(6),v1.FDate,112)
order by convert(char(6),v1.FDate,112),i.FNumber,i.FName,i.FModel

alter table #temp add fid int 

update #temp set fid=1

select FNumber,FName,FModel,
sum(fid),   --有几个月上100
MAX(FDate)  --最近一个月
from #temp where FQty>=100
group by FNumber,FName,FModel
order by sum(fid),MAX(FDate) desc 

drop table #temp
