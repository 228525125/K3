--drop procedure count_wxjsl

create procedure count_wxjsl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
wxzs int default(0)
,wxasdh int default(0)
,wxwasdh int default(0)
,wxjsl decimal(28,2) default(0)
)

Insert Into #Data(wxzs,wxasdh,wxwasdh
)
select sum(1) as 'wxzs'
,sum(case when /*( c.FDate is null and datediff(day,b.FFetchDate,getDate())<=0 ) or*/ c.FDate <= b.FFetchDate then 1 else 0 end) as 'wxasdh'
,sum(case when ( c.FDate is null and datediff(day,b.FFetchDate,getDate())>0 )  or c.FDate>b.FFetchDate then 1 else 0 end) as 'wgwasdh'
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN (
select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FDate) as FDate from ICQCBill where 1=1 AND (FTranType=715 AND (FCancellation = 0)) group by FSHSubcOutInterID,FSHSubcOutEntryID
) c on b.FInterID=c.FSHSubcOutInterID and b.FEntryID=c.FSHSubcOutEntryID
where 1=1
AND FClassTypeID=1002521
AND a.FStatus > 0
AND b.FFetchDate>=@begindate and b.FFetchDate<=@enddate
--AND b.FFetchDate>='2011-10-08' and b.FFetchDate<='2011-10-31'
--AND b.FFetchDate <= getDate()
--and (c.FDate is null or c.FDate>b.FFetchDate)
--order by a.FBillNo

select wxzs,wxasdh,wxwasdh,convert(decimal(28,2),convert(decimal(28,2),wxzs-wxwasdh)/wxzs*100) as wxjsl from #Data
end

execute count_wxjsl '2011-11-01','2011-11-30' 