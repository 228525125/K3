--drop procedure list_wxjsl drop procedure list_wxjsl_count

create procedure list_wxjsl
@begindate varchar(10),
@enddate varchar(10),
@status int
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
,jgdw nvarchar(255) default('')
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,jgdw
)
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',convert(char(10),b.FFetchDate,120) as 'jhrq',
isnull(convert(char(10),case when c.FDate is null then f.FDate else c.FDate end,120),'') as 'dhrq',
--isnull(convert(char(10),c.FDate,120),'') as 'dhrq',                                                   --不考虑外协免检的情况
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FTranOutQty as 'fssl',s.FName
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN t_supplier s on a.FSupplierID=s.FItemID 
LEFT JOIN (
select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID
) c on b.FInterID=c.FSourceInterID and b.FEntryID=c.FSourceEntryID
LEFT JOIN (select MIN(a.FDate) as FDate,b.FSubcOutNo,b.FSubcOutEntryID from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by b.FSubcOutNo,b.FSubcOutEntryID) f on a.FBillNo=f.FSubcOutNo and b.FEntryID=f.FSubcOutEntryID
where 1=1 
AND a.FClassTypeID=1002521
AND a.FStatus > 0
AND b.FFetchDate>=@begindate and b.FFetchDate<=@enddate
--AND b.FFetchDate>='2013-10-01' and b.FFetchDate<='2013-10-31'
order by a.FBillNo

if @status=0 
select * from #Data
else if @status=1
select * from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) /*or (dhrq='' and datediff(day,jhrq,getDate())<=0)*/ )
else
select * from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end

--count--
create procedure list_wxjsl_count
@begindate varchar(10),
@enddate varchar(10),
@status int
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
,jgdw nvarchar(255) default('')
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,jgdw
)
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',convert(char(10),b.FFetchDate,120) as 'jhrq',
isnull(convert(char(10),case when c.FDate is null then f.FDate else c.FDate end,120),'') as 'dhrq',
--isnull(convert(char(10),c.FDate,120),'') as 'dhrq',                                                   --不考虑外协免检的情况
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FTranOutQty as 'fssl',s.FName
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN t_supplier s on a.FSupplierID=s.FItemID 
LEFT JOIN (
select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID
) c on b.FInterID=c.FSourceInterID and b.FEntryID=c.FSourceEntryID
--LEFT JOIN ICMO d on b.FICMOBillNo=d.FBillNo
LEFT JOIN (select MIN(a.FDate) as FDate,b.FSubcOutNo,b.FSubcOutEntryID from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by b.FSubcOutNo,b.FSubcOutEntryID) f on a.FBillNo=f.FSubcOutNo and b.FEntryID=f.FSubcOutEntryID
where 1=1 
AND a.FClassTypeID=1002521
AND a.FStatus > 0
AND b.FFetchDate>=@begindate and b.FFetchDate<=@enddate
--AND b.FFetchDate>='2012-04-01' and b.FFetchDate<='2012-04-30' and a.FBillNo='wwzc001393'
order by a.FBillNo

if @status=0 
select count(*) from #Data
else if @status=1
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) /*or (dhrq='' and datediff(day,jhrq,getDate())<=0)*/ )
else
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end


execute list_wxjsl '2013-10-01','2013-10-31',0

execute list_wxjsl_count '2013-01-01','2013-01-31',2

select b.* from ICShop_SubcOut a left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID where a.FBillNo='WWZC002516'

select FSourceInterID,FSourceEntryID,MIN(FDate) from rss.dbo.wwzc_wwjysqd where FSourceInterID=3515 and FSourceEntryID=4534 group by FSourceInterID,FSourceEntryID


select datediff(day,'2011-10-25',getDate())


select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID


select b.FInterID,b.FEntryID,* from ICShop_SubcOut a left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID where a.FBillNo='wwzc001393'

select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd where FDate='2012-04-10' group by FSourceInterID,FSourceEntryID 

select i.FNumber,b.FInterID,b.FEntryID,* from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
where a.FBillNo='wwzc001393'

2392 2007

select * from rss.dbo.wwzc_wwjysqd where FSourceInterID=2392 and FSourceEntryID=2011

select * from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID

select * from t_supplier


-------------------分单位汇总------------------------
create table #Data1(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
,jgdw nvarchar(255) default('')
)

Insert Into #Data1(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,jgdw
)
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',convert(char(10),b.FFetchDate,120) as 'jhrq',
isnull(convert(char(10),case when c.FDate is null then f.FDate else c.FDate end,120),'') as 'dhrq',
--isnull(convert(char(10),c.FDate,120),'') as 'dhrq',                                                   --不考虑外协免检的情况
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FTranOutQty as 'fssl',s.FName
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN t_supplier s on a.FSupplierID=s.FItemID 
LEFT JOIN (
select FSourceInterID,FSourceEntryID,MIN(FDate) as FDate from rss.dbo.wwzc_wwjysqd group by FSourceInterID,FSourceEntryID
) c on b.FInterID=c.FSourceInterID and b.FEntryID=c.FSourceEntryID
LEFT JOIN (select MIN(a.FDate) as FDate,b.FSubcOutNo,b.FSubcOutEntryID from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by b.FSubcOutNo,b.FSubcOutEntryID) f on a.FBillNo=f.FSubcOutNo and b.FEntryID=f.FSubcOutEntryID
where 1=1 
AND a.FClassTypeID=1002521
AND a.FStatus > 0
--AND b.FFetchDate>=@begindate and b.FFetchDate<=@enddate
AND b.FFetchDate>='2014-01-01' and b.FFetchDate<='2014-12-31'
order by a.FBillNo


select jgdw,count(djbh) from #data1 group by jgdw

select jgdw,count(1) from #data1 where jhrq<dhrq or dhrq = '' group  by jgdw

select * from #data1

delete #data1

drop table #data1





