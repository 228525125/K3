--drop procedure chart_aqkc 

create procedure chart_aqkc 
@FNumber nvarchar(255),
@begin nvarchar(255),
@end nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #Data(
FDate nvarchar(255),
FQty decimal(28,2) default(0)
)

Insert Into #Data(FDate,FQty
)
select convert(char(6),v1.FDate,112) as FDate,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_ICItem i on i.FItemID=u1.FItemID
where v1.FTranType in (24,21) and v1.FCancellation = 0 AND v1.FCheckerID>0
and v1.FDate>=@begin and v1.FDate<=@end
and i.FNumber = @FNumber
group by u1.FItemID,convert(char(6),v1.FDate,112)
order by u1.FItemID,convert(char(6),v1.FDate,112)

select * from #Data
end

execute chart_aqkc '01.01.02.027','2010-01-01','2011-12-31'



select FDeleted,* from t_icitem where FModel='h15.88' 


select FNumber,FName from t_icitem


select convert(char(6),v1.FDate,112) as FDate,sum(u1.FQty) as FQty 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
LEFT JOIN t_ICItem i on i.FItemID=u1.FItemID
where  v1.FCancellation = 0 AND v1.FCheckerID>0
and v1.FTranType in (24,21)
and v1.FDate>='2013-01-01' and v1.FDate<='2013-12-31'
--and i.FNumber = '05.05.0001'
group by convert(char(6),v1.FDate,112)
order by convert(char(6),v1.FDate,112)

