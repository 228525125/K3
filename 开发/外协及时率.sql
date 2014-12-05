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
,sum(case when /*( c.FDate is null and datediff(day,b.FFetchDate,getDate())<=0 ) or*/ case when c.FDate is null then f.FDate else c.FDate end <= b.FFetchDate then 1 else 0 end) as 'wxasdh'
,sum(case when ( case when c.FDate is null then f.FDate else c.FDate end is null and datediff(day,b.FFetchDate,getDate())>0 )  or case when c.FDate is null then f.FDate else c.FDate end>b.FFetchDate then 1 else 0 end) as 'wxwasdh'
--,0 as 'wgwasdh'
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN (
select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID
) c on b.FInterID=c.FSourceInterID and b.FEntryID=c.FSourceEntryID
LEFT JOIN (select MIN(a.FDate) as FDate,b.FSubcOutNo,b.FSubcOutEntryID from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by b.FSubcOutNo,b.FSubcOutEntryID) f on a.FBillNo=f.FSubcOutNo and b.FEntryID=f.FSubcOutEntryID
where 1=1
AND a.FClassTypeID=1002521
AND a.FStatus > 0
AND b.FFetchDate>=@begindate and b.FFetchDate<=@enddate
--AND b.FFetchDate>='2011-10-08' and b.FFetchDate<='2011-10-31'
--AND b.FFetchDate <= getDate()
--and (c.FDate is null or c.FDate>b.FFetchDate)
--order by a.FBillNo
--and a.FSupplierID=4578


select wxzs,wxasdh,wxwasdh,convert(decimal(28,2),convert(decimal(28,2),wxasdh)/wxzs*100) as wxjsl from #Data
end

execute count_wxjsl '2013-01-01','2013-12-31' 


select * from ICShop_SubcOut a left join t_Supplier b on a.FSupplierID=b.FItemID

select * from t_Supplier where FNumber = '01.063'



select a.FBillNo as 'djbh',case when case when c.FDate is null then f.FDate else c.FDate end <= b.FFetchDate then 1 else 0 end
,convert(char(10),a.FBillDate,120) as 'djrq',convert(char(10),b.FFetchDate,120) as 'jhrq'
,isnull(convert(char(10),case when c.FDate is null then f.FDate else c.FDate end,120),'') as 'dhrq'
,convert(char(10),c.FDate,120),convert(char(10),f.FDate,120)
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN (
select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID
) c on b.FInterID=c.FSourceInterID and b.FEntryID=c.FSourceEntryID
LEFT JOIN ICShop_SubcInEntry d on a.FBillNo=d.FSubcOutNo and b.FEntryID=d.FSubcOutEntryID
LEFT JOIN ICShop_SubcIn f on d.FInterID=f.FInterID
where 1=1
AND a.FClassTypeID=1002521
AND a.FStatus > 0
AND b.FFetchDate>='2013-01-01' and b.FFetchDate<='2013-01-31'
order by a.FBillNo

