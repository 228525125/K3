--drop procedure list_wgwzdj drop procedure list_wgwzdj_count

create procedure list_wgwzdj
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
select v1.FBillNo as 'djbh',convert(char(10),v1.FDate,120) as 'djrq',convert(char(10),u1.FDate,120) as 'jhrq',
case when j.FDate is not null then isnull(convert(char(10),j.FDate,120),'') when k.FDate is not null then isnull(convert(char(10),k.FDate,120),'') else '' end as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',u1.FQty as 'fssl',s.FName as 'gys'
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
select v1.FBillNo,u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0 --AND v1.FBillNo='DD001245' -------------
group by v1.FBillNo,u1.FOrderInterID,u1.FOrderEntryID
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
AND u1.FMrpClosed=0 AND v1.FStatus <> 3
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0 and v1.FCheckerID>0
AND u1.FDate>=@begindate AND  u1.FDate<=@enddate
--AND u1.FDate>='2011-11-01' AND  u1.FDate<='2011-11-08'
order by v1.FBillNo

if @status=-1 
select * from #Data where 1=1 AND datediff(day,jhrq,dhrq)>1 or (dhrq='' and datediff(day,jhrq,getDate())>1)        --超交期
else if @status=0
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=0 and dhrq=''                   --今天到期
else if @status=1
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=-1 and dhrq=''      --1天
else if @status=2
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=-2 and dhrq=''      --2天
else if @status=3
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())=-3and dhrq=''      --3天
else if @status=4
select * from #Data where 1=1 AND datediff(day,jhrq,getDate())<=-4 and dhrq=''      --4天以上
else 
select * from #Data

end

-----count-------
create procedure list_wgwzdj_count
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
select v1.FBillNo,u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0 --AND v1.FBillNo='DD001245' -------------
group by v1.FBillNo,u1.FOrderInterID,u1.FOrderEntryID
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
AND u1.FMrpClosed=0 AND v1.FStatus <> 3
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0 and v1.FCheckerID>0
AND u1.FDate>=@begindate AND  u1.FDate<=@enddate
--AND u1.FDate>='2011-11-01' AND  u1.FDate<='2011-11-08'
order by v1.FBillNo

if @status=-1 
select count(*) from #Data where 1=1 AND datediff(day,jhrq,dhrq)>0 or (dhrq='' and datediff(day,jhrq,getDate())>1)        --超交期
else if @status=0
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=0 and dhrq=''                   --今天到期
else if @status=1
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=-1 and dhrq=''      --1天
else if @status=2
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=-2 and dhrq=''      --2天
else if @status=3
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())=-3and dhrq=''      --3天
else if @status=4
select count(*) from #Data where 1=1 AND datediff(day,jhrq,getDate())<=-4 and dhrq=''      --4天以上
else 
select count(*) from #Data

end


execute list_wgwzdj '2012-12-01','2012-12-31',1
