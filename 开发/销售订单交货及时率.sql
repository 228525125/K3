--drop procedure count_ddjsl

create procedure count_ddjsl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
ddzs int default(0)
,ddasjh int default(0)
,ddwasjh int default(0)
,ddjsl decimal(28,2) default(0)
,ddtx int default(0)
)

Insert Into #Data(ddzs,ddasjh,ddwasjh,ddtx
)
select sum(1) as 'ddzs'
,sum(case when j.FDate<=u1.FDate then 1 else 0 end) as 'ddasjh'
,sum(case when j.FDate>u1.FDate or (j.FDate is null and datediff(day,u1.FDate,getDate())>0) then 1 else 0 end) as 'ddwasjh'
,sum(case when j.FDate is null AND datediff(day,u1.FDate,getDate())>=-2 AND u1.FDate>=convert(char(10),getDate(),120) then 1 else 0 end) as 'ddtx'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN(
select FOrderInterID,FOrderEntryID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderInterID,FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100) 
AND ((u1.FDate>=@begindate AND  u1.FDate<=@enddate) AND  v1.FCancellation = 0))
AND v1.FStatus > 0

select ddzs,ddasjh,ddwasjh,convert(decimal(28,2),convert(decimal(28,2),ddzs-ddwasjh)/ddzs*100) as ddjsl,ddtx from #Data
end

execute count_ddjsl '2012-01-01','2012-01-31' 