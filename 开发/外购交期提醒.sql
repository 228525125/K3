--drop procedure count_wgjq

create procedure count_wgjq 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
overr int default(0)
,today int default(0)
,one int default(0)
,two int default(0)
,three int default(0)
,four int default(0)
,five int default(0)
)

create table #temp(
id int
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
)

Insert Into #temp(id,jhrq,dhrq
)
Select 1,
convert(char(10),u1.FDate,120) as 'jhrq',
case when j.FDate is not null then isnull(convert(char(10),j.FDate,120),'') when k.FDate is not null then isnull(convert(char(10),k.FDate,120),'') else '' end as 'dhrq'
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
--AND u1.FDate>='2011-10-08' AND  u1.FDate<='2011-10-31'
--order by v1.FBillNo
Insert Into #Data(overr,today,one,two,three,four,five
)
select isnull(sum(case when datediff(day,jhrq,dhrq)>1 or (dhrq='' and datediff(day,jhrq,getDate())>1) then id end),0) as 'overr',
isnull(sum(case when datediff(day,jhrq,getDate())=0 and dhrq='' then id end),0) as 'today',
isnull(sum(case when datediff(day,jhrq,getDate())=-1 and dhrq='' then id end),0) as 'one',
isnull(sum(case when datediff(day,jhrq,getDate())=-2 and dhrq='' then id end),0) as 'two',
isnull(sum(case when datediff(day,jhrq,getDate())=-3 and dhrq='' then id end),0) as 'three',
isnull(sum(case when datediff(day,jhrq,getDate())<=-4 and dhrq='' then id end),0) as 'four',
isnull(sum(case when datediff(day,jhrq,getDate())<=-5 and dhrq='' then id end),0) as 'five'
from #temp 
select * from #Data
end

execute count_wgjq '2012-12-01','2012-12-31' 


select datediff(day,'2011-10-31','2011-11-05')


select * from POOrder

