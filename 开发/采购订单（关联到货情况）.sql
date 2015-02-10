--drop procedure table_cgdd

create procedure table_cgdd
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
select 
case when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' 
end  as FCheck,CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
case when u1.FMrpClosed = 1 then 'Y' ELSE '' END as 'hywgb',v1.FInterID,v1.FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,u1.FSourceBillNo,u1.FSourceInterID,FSourceEntryID,u1.FEntryID,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FQty as 'fssl',u1.FPriceDiscount as 'hsdj',u1.FAllAmount as 'hsje',convert(char(10),u1.FDate,120) as 'jhrq',us.FDescription as 'ywy',s.FName as 'gys',
case when a.FDate is null then b.FDate ELSE a.FDate END as 'dhrq',
isnull(a.FQty,0) as 'sj',isnull(a.FPassQty,0) as 'hg',isnull(a.FNotPassQty,0) as 'bhg',isnull(a.FConPassQty,0) as 'rbjs',
isnull(b.FQty,0) as 'sh',case when a.FCommitQty is null then b.FCommitQty ELSE a.FCommitQty END as 'rksl',
case when c.FItemID is null then 'Y' else '' end as 'shouci'
from POOrder v1 
INNER JOIN POOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN t_user us on us.FUserID=v1.FBillerID 
LEFT JOIN t_Supplier s on v1.FSupplyID=s.FItemID
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',sum(u1.FAuxConPassQty) as 'FConPassQty',sum(u1.FAuxNotPassQty) as FNotPassQty,sum(u1.FAuxQtyPass) as FPassQty,sum(u1.FAuxCommitQty) as FCommitQty,MIN(v1.FDate) as 'FDate' 
from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
where 1=1 
AND (v1.FTranType=702 AND (v1.FCancellation = 0)) and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) a on u1.FInterID=a.FOrderInterID and u1.FEntryID=a.FOrderEntryID                  --ÀÕºÏ
LEFT JOIN (
select u1.FOrderInterID,u1.FOrderEntryID,sum(u1.FQty) as 'FQty',sum(u1.FAuxCommitQty) as FCommitQty,MIN(v1.FDate) as 'FDate'  
from POInstock v1 
INNER JOIN POInstockEntry u1 ON     v1.FInterID = u1.FInterID AND u1.FInterID <>0
where 1=1 
AND v1.FTranType=72 AND v1.FCancellation = 0 and v1.FCheckerID>0
group by u1.FOrderInterID,u1.FOrderEntryID
) b on u1.FInterID=b.FOrderInterID and u1.FEntryID=b.FOrderEntryID                  -- ’ªı
LEFT JOIN (
select p2.FItemID from POOrder p1 left join POOrderEntry p2 on p1.FInterID=p2.FInterID where p1.FDate<@begindate group by p2.FItemID
) c on u1.FItemID=c.FItemID
where 1=1 
AND v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007101) AND v1.FCancellation = 0
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or u1.FSourceBillNo like '%'+@query+'%' or i.FModel like '%'+@query+'%' or us.FDescription like '%'+@query+'%')
end


exec table_cgdd '','2015-01-01','2015-01-31'

