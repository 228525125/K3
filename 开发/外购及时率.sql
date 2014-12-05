--drop procedure count_wgjsl

create procedure count_wgjsl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
wgzs int default(0)
,wgasdh int default(0)
,wgwasdh int default(0)
,wgjsl decimal(28,2) default(0)
)

Insert Into #Data(wgzs,wgasdh,wgwasdh
)
select sum(1) as 'wgzs'
,sum(case when /*( j.FDate is null and k.FDate is null and datediff(day,u1.FDate,getDate())<=0 ) or*/ j.FDate<=u1.FDate or k.FDate<=u1.FDate then 1 else 0 end) as 'wgasdh'
,sum(case when ( j.FDate is null and k.FDate is null and datediff(day,u1.FDate,getDate())>0 ) or j.FDate>u1.FDate or k.FDate>u1.FDate then 1 else 0 end) as 'wgwasdh'
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
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0 --AND v1.FBillNo='DD001245' -------------
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
--AND a.FStatus > 0     --0：未审核  1：审核未关闭  2：部分行关  3：关闭 
AND u1.FDate <= getDate()
--order by v1.FBillNo

select wgzs,wgasdh,wgwasdh,convert(decimal(28,2),convert(decimal(28,2),wgzs-wgwasdh)/wgzs*100) as wgjsl from #Data
end

execute count_wgjsl '2012-12-01','2012-12-31' 



select u1.FOrderInterID,u1.FOrderEntryID,v1.FDate as 'FDate' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=72 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
AND u1.FInterID=3883 and u1.FEntryID=1
group by u1.FOrderInterID,u1.FOrderEntryID


select v1.FBillNo,u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0
AND u1.FOrderInterID=3731 and u1.FOrderEntryID=1
group by v1.FBillNo,u1.FOrderInterID,u1.FOrderEntryID


select u1.FOrderInterID,u1.FOrderEntryID from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0
where FBillNo in ('DD001875','DD001822')

