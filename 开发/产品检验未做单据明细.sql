/*产品检验未做单据明细*/
--drop procedure list_cpjywzdj drop procedure list_cpjywzdj_count

create procedure list_cpjywzdj
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
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',
isnull(convert(char(10),c.QDate,120),'') as 'jyrq',isnull(convert(char(10),c.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FQty as 'fssl'
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
left join (select FInStockInterID,FSerialID,MIN(a.FDate) as QDate,MIN(case when a.FResult=286 then c.FDate else a.FDate end) as FDate from ICQCBill a left join ICStockBillEntry b on a.FInterID=b.FSourceInterID left join ICStockBill c on b.FInterID=c.FInterID where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 AND a.FStatus>=1 group by FInStockInterID,FSerialID) c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>=@begindate AND a.FDate<=@enddate
--AND a.FDate>='2011-11-01' AND a.FDate<='2011-11-08'
AND c.FDate is null 
AND datediff(day,a.FDate,getDate())<30
order by a.FBillNo

select * from #Data
end

--count--
create procedure list_cpjywzdj_count
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
select a.FBillNo as 'djbh',convert(char(10),a.FBillDate,120) as 'djrq',
isnull(convert(char(10),c.QDate,120),'') as 'jyrq',isnull(convert(char(10),c.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FQty as 'fssl'
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
left join (select FInStockInterID,FSerialID,MIN(a.FDate) as QDate,MIN(case when a.FResult=286 then c.FDate else a.FDate end) as FDate from ICQCBill a left join ICStockBillEntry b on a.FInterID=b.FSourceInterID left join ICStockBill c on b.FInterID=c.FInterID where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 AND a.FStatus>=1 group by FInStockInterID,FSerialID) c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>=@begindate AND a.FDate<=@enddate
--AND a.FDate>='2011-11-01' AND a.FDate<='2011-11-08'
AND c.FDate is null 
AND datediff(day,a.FDate,getDate())<30
order by a.FBillNo

select count(*) from #Data
end


execute list_cpjywzdj '2011-12-01','2011-12-30'

execute list_cpjywzdj_count '2011-11-01','2011-11-08'

