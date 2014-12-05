--drop procedure count_wxjq

create procedure count_wxjq 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
wxoverr int default(0)
,wxtoday int default(0)
,wxone int default(0)
,wxtwo int default(0)
,wxthree int default(0)
,wxfour int default(0)
,wxfive int default(0)
)

create table #temp(
id int
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
)

Insert Into #temp(id,jhrq,dhrq
)
select 1,
convert(char(10),b.FFetchDate,120) as 'jhrq',
case when c.FDate is not null then isnull(convert(char(10),c.FDate,120),'') else '' end as 'dhrq'
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
--order by a.FBillNo

Insert Into #Data(wxoverr,wxtoday,wxone,wxtwo,wxthree,wxfour,wxfive
)
select isnull(sum(case when datediff(day,jhrq,dhrq)>0 or (dhrq='' and datediff(day,jhrq,getDate())>0) then id end),0) as 'wxoverr',
isnull(sum(case when datediff(day,jhrq,getDate())=0 and dhrq='' then id end),0) as 'wxtoday',
isnull(sum(case when datediff(day,jhrq,getDate())=-1 and dhrq='' then id end),0) as 'wxone',
isnull(sum(case when datediff(day,jhrq,getDate())=-2 and dhrq='' then id end),0) as 'wxtwo',
isnull(sum(case when datediff(day,jhrq,getDate())=-3 and dhrq='' then id end),0) as 'wxthree',
isnull(sum(case when datediff(day,jhrq,getDate())<=-4 and dhrq='' then id end),0) as 'wxfour',
isnull(sum(case when datediff(day,jhrq,getDate())<=-5 and dhrq='' then id end),0) as 'wxfive'
from #temp 
select * from #Data
end

execute count_wxjq '2011-10-08','2011-10-31' 



