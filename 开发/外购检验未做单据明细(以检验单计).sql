/*来料检验未做单据明细*/
--drop procedure list_wgjywzdj drop procedure list_wgjywzdj_count

create procedure list_wgjywzdj
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jyrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
,hh int default(0)
)

Insert Into #Data(djbh,djrq,jyrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,hh
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),d.QDate,120),'') as 'jyrq',isnull(convert(char(10),case when d.FDate is not null and (d.FDate<c.FDate or c.FDate is null) then d.FDate else c.FDate end,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FQty as 'fssl',b.FEntryID as 'hh'
from POInstock a 
INNER JOIN POInstockEntry b ON  a.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
left join (select u1.FSourceInterID,u1.FSourceEntryID,MIN(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 where 1=1 AND v1.FTranType=1 AND  v1.FCancellation = 0 AND u1.FSourceInterID>0 group by u1.FSourceInterID,u1.FSourceEntryID) c on c.FSourceInterID=b.FInterID and c.FSourceEntryID=b.FEntryID
left join (select FInStockInterID,FSerialID,MIN(FDate) as QDate,MIN(case when FResult=286 then null else FDate end) as FDate from ICQCBill where FTranType=711 AND FCancellation = 0 group by FInStockInterID,FSerialID) d on d.FInStockInterID=b.FInterID and d.FSerialID=b.FEntryID      --不合格
where 1=1
AND (a.FTranType=702 AND (A.FCancellation = 0))
AND a.FStatus = 1
AND a.FDate>=@begindate AND a.FDate<=@enddate
--AND a.FDate>='2011-11-01' AND a.FDate<='2011-11-08'
AND c.FDate is null and d.FDate is null
AND datediff(day,a.FDate,getDate())<30
order by a.FBillNo

select * from #Data where jyrq is null or jyrq=''
end

--count--
create procedure list_wgjywzdj_count
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jyrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
)

Insert Into #Data(djbh,djrq,jyrq,dhrq,wldm,wlmc,wlgg,jldw,fssl
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),d.QDate,120),'') as 'jyrq',isnull(convert(char(10),case when d.FDate is not null and (d.FDate<c.FDate or c.FDate is null) then d.FDate else c.FDate end,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FQty as 'fssl'
from POInstock a 
INNER JOIN POInstockEntry b ON  a.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
left join (select u1.FSourceInterID,u1.FSourceEntryID,MIN(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 where 1=1 AND v1.FTranType=1 AND  v1.FCancellation = 0 AND u1.FSourceInterID>0 group by u1.FSourceInterID,u1.FSourceEntryID) c on c.FSourceInterID=b.FInterID and c.FSourceEntryID=b.FEntryID
left join (select FInStockInterID,FSerialID,MIN(FDate) as QDate,MIN(case when FResult=286 then null else FDate end) as FDate from ICQCBill where FTranType=711 AND FCancellation = 0 group by FInStockInterID,FSerialID) d on d.FInStockInterID=b.FInterID and d.FSerialID=b.FEntryID      --不合格
where 1=1
AND (a.FTranType=702 AND (A.FCancellation = 0))
AND a.FStatus = 1
AND a.FDate>=@begindate AND a.FDate<=@enddate
--AND a.FDate>='2011-11-01' AND a.FDate<='2011-11-08'
AND c.FDate is null and d.FDate is null
AND datediff(day,a.FDate,getDate())<30
order by a.FBillNo

select count(1) from #Data where jyrq is null or jyrq=''
end


execute list_wgjywzdj '2015-10-01','2015-10-31'

execute list_wgjywzdj_count '2013-10-01','2013-10-31'
