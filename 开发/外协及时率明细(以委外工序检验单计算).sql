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
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl
)
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',convert(char(10),b.FFetchDate,120) as 'jhrq',
isnull(convert(char(10),c.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FTranOutQty as 'fssl'
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
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl
)
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',convert(char(10),b.FFetchDate,120) as 'jhrq',
isnull(convert(char(10),c.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FTranOutQty as 'fssl'
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
order by a.FBillNo

if @status=0 
select count(*) from #Data
else if @status=1
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) /*or (dhrq='' and datediff(day,jhrq,getDate())<=0)*/ )
else
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end


execute list_wxjsl '2013-10-01','2013-10-31',0

execute list_wxjsl_count '2011-10-08','2011-10-31',2


select datediff(day,'2011-10-25',getDate())



