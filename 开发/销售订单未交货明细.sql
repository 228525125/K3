--drop procedure list_ddwzdj drop procedure list_ddwzdj_count

create procedure list_ddwzdj
@begindate varchar(10),
@enddate varchar(10)
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
select v1.FBillNo as 'djbh',convert(char(10),v1.FDate,120) as 'djrq',
isnull(convert(char(10),u1.FDate,120),'') as 'jhrq',
isnull(convert(char(10),j.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',u1.FQty as 'fssl'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN(
select FOrderInterID,FOrderEntryID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderInterID,FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND v1.FStatus > 0
AND j.FDate is null
AND datediff(day,u1.FDate,getDate())>=-2 
AND u1.FDate>=convert(char(10),getDate(),120)
AND u1.FDate>=@begindate AND  u1.FDate<=@enddate AND  v1.FCancellation = 0
order by v1.FBillNo

select * from #Data
end

--count--
create procedure list_ddwzdj_count
@begindate varchar(10),
@enddate varchar(10)
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
select v1.FBillNo as 'djbh',convert(char(10),v1.FDate,120) as 'djrq',
isnull(convert(char(10),u1.FDate,120),'') as 'jhrq',
isnull(convert(char(10),j.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',u1.FQty as 'fssl'
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN(
select FOrderInterID,FOrderEntryID,sum(FQty) as FQty,MIN(a.FDate) as 'FDate' 
from ICStockBill a 
left join ICStockBillEntry b on a.FInterID=b.FInterID 
where a.FTranType=21 AND a.FCancellation = 0 AND a.FCheckerID <>0
group by FOrderInterID,FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
where 1=1 
AND (v1.FChangeMark=0 
AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND v1.FStatus > 0
AND j.FDate is null
AND datediff(day,u1.FDate,getDate())>=-2 
AND u1.FDate>=convert(char(10),getDate(),120)
AND u1.FDate>=@begindate AND  u1.FDate<=@enddate AND  v1.FCancellation = 0
select count(*) from #Data
end

