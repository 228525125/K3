--drop procedure list_wxwzdj drop procedure list_wxwzdj_count

create procedure list_wxwzdj
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
,gys nvarchar(255) default('')
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,gys
)
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',
convert(char(10),b.FFetchDate,120) as 'jhrq',
case when c.FDate is not null then isnull(convert(char(10),c.FDate,120),'') else '' end as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FOperTranOutQty as 'fssl',s.FName as 'gys'
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplierID=s.FItemID
LEFT JOIN (
select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FDate) as FDate from ICQCBill where 1=1 AND (FTranType=715 AND (FCancellation = 0)) group by FSHSubcOutInterID,FSHSubcOutEntryID
) c on b.FInterID=c.FSHSubcOutInterID and b.FEntryID=c.FSHSubcOutEntryID
where 1=1
AND FClassTypeID=1002521
AND a.FStatus > 0
AND b.FFetchDate>=@begindate and b.FFetchDate<=@enddate
--AND b.FFetchDate>='2011-11-01' and b.FFetchDate<='2011-11-30'
order by a.FBillNo

if @status=-1 
select * from #Data where 1=1 AND datediff(day,jhrq,dhrq)>0 or (dhrq='' and jhrq<getDate())        --超交期
else if @status=0
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=0 and dhrq=''                   --今天到期
else if @status=1
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=-1 and dhrq=''      --1天
else if @status=2
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=-2 and dhrq=''      --2天
else if @status=3
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=-3 and dhrq=''      --3天
else if @status=4
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())<=-4 and dhrq=''      --4天以上
else 
select * from #Data

end

--count--
create procedure list_wxwzdj_count
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
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',
convert(char(10),b.FFetchDate,120) as 'jhrq',
case when c.FDate is not null then isnull(convert(char(10),c.FDate,120),'') else '' end as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FOperTranOutQty as 'fssl'
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
--AND b.FFetchDate>='2011-11-01' and b.FFetchDate<='2011-11-30'
order by a.FBillNo

if @status=-1 
select count(*) from #Data where 1=1 AND datediff(day,jhrq,dhrq)>0 or (dhrq='' and jhrq<getDate())        --超交期
else if @status=0
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=0 and dhrq=''                   --今天到期
else if @status=1
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=-1 and dhrq=''      --1天
else if @status=2
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=-2 and dhrq=''      --2天
else if @status=3
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=-3 and dhrq=''      --3天
else if @status=4
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())<=-4 and dhrq=''      --4天以上
else 
select count(*) from #Data

end

execute list_wxwzdj '2012-11-01','2012-11-30',0