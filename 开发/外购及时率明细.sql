--drop procedure list_wgjsl drop procedure list_wgjsl_count

create procedure list_wgjsl
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
,wldw nvarchar(255) default('')
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,wldw
)
select v1.FBillNo as 'djbh',convert(char(10),v1.FDate,120) as 'djrq',convert(char(10),u1.FDate,120) as 'jhrq',
case when j.FDate is not null then isnull(convert(char(10),j.FDate,120),'') when k.FDate is not null then isnull(convert(char(10),k.FDate,120),'') else '' end as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',u1.FQty as 'fssl',s.FName
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0 
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0 
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0 and v1.FCheckerID>0
AND not(u1.FMrpClosed=1 and j.FDate is null and k.FDate is null)
AND u1.FDate>=@begindate AND  u1.FDate<=@enddate
--AND u1.FDate >= '2011-10-08' and u1.FDate <= '2011-10-31'
order by v1.FBillNo

if @status=0 
select * from #Data
else if @status=1
select * from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) ) 
else
select * from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end

--count--
create procedure list_wgjsl_count
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
select v1.FBillNo as 'djbh',convert(char(10),v1.FDate,120) as 'djrq',convert(char(10),u1.FDate,120) as 'jhrq',
case when j.FDate is not null then isnull(convert(char(10),j.FDate,120),'') when k.FDate is not null then isnull(convert(char(10),k.FDate,120),'') else '' end as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',u1.FQty as 'fssl'
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0 
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0 
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0 and v1.FCheckerID>0
AND not(u1.FMrpClosed=1 and j.FDate is null and k.FDate is null)
AND u1.FDate>=@begindate AND  u1.FDate<=@enddate
--AND u1.FDate >= '2011-10-08' and u1.FDate <= '2011-10-31'
order by v1.FBillNo

if @status=0 
select count(*) from #Data
else if @status=1
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) ) 
else
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end


execute list_wgjsl '2013-10-01','2013-10-31',2








-------------------明细----------------

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
,wldw nvarchar(255) default('')
)

Insert Into #Data1(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,wldw
)
select v1.FBillNo as 'djbh',convert(char(10),v1.FDate,120) as 'djrq',convert(char(10),u1.FDate,120) as 'jhrq',
case when j.FDate is not null then isnull(convert(char(10),j.FDate,120),'') when k.FDate is not null then isnull(convert(char(10),k.FDate,120),'') else '' end as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',u1.FQty as 'fssl',s.FName
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) j on u1.FInterID=j.FOrderInterID and u1.FEntryID=j.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0 
group by u1.FOrderInterID,u1.FOrderEntryID
) k on u1.FInterID=k.FOrderInterID and u1.FEntryID=k.FOrderEntryID
LEFT JOIN (
select b.FOrderInterID,b.FOrderEntryID,sum(a.FPassQty) as 'FQty' 
from ICQCBill a 
left join POInstockEntry b on a.FInStockInterID=b.FInterID and a.FSerialID=b.FEntryID
where 1=1 
AND (a.FTranType=711 AND (a.FCancellation = 0)) AND a.FCheckerID>0 
group by b.FOrderInterID,b.FOrderEntryID
) l on u1.FInterID=l.FOrderInterID and u1.FEntryID=l.FOrderEntryID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty' 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=1 AND v1.FROB=1 AND  v1.FCancellation = 0
group by u1.FOrderInterID,u1.FOrderEntryID
) m on u1.FInterID=m.FOrderInterID and u1.FEntryID=m.FOrderEntryID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0 and v1.FCheckerID>0
AND not(u1.FMrpClosed=1 and j.FDate is null and k.FDate is null)
AND u1.FDate >= '2013-12-01' and u1.FDate <= '2013-12-31'
order by v1.FBillNo

select wldw,count(djbh) from #data1 group by wldw

select wldw,count(*) from #data1 where jhrq<dhrq or dhrq = '' group by wldw

delete #data1

drop table #data1





