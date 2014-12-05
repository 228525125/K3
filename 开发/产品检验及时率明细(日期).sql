--drop procedure list_cpjyjsl drop procedure list_cpjyjsl_count

create procedure list_cpjyjsl
@begindate varchar(10),
@enddate varchar(10),
@status int
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
isnull(convert(char(10),c.QDate,120),'') as 'jyrq',isnull(convert(char(10),c.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FQty as 'fssl'
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
left join (select FInStockInterID,FSerialID,MIN(a.FDate) as QDate,MIN(case when a.FResult=286 then c.FDate else a.FDate end) as FDate from ICQCBill a left join ICStockBillEntry b on a.FInterID=b.FSourceInterID left join ICStockBill c on b.FInterID=c.FInterID where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 AND a.FStatus>=1 group by FInStockInterID,FSerialID) c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID   --a.FStatus>=1 : 检验单为保留的入库时间=保留时间  c.FStatus>=1 : 检验单为保留的入库时间=真实入库时间
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>=@begindate AND a.FDate<=@enddate
--AND a.FDate>='2011-10-08' AND a.FDate<='2011-10-31'
order by a.FBillNo

if @status=0
select * from #Data
else if @status=1
select * from #Data a where 1=1 and a.dhrq<>'' and not exists(select * from #Data b where 1=1 and (  /*(dhrq='' and datediff(day,djrq,getDate())>1) or*/ ((datediff(day,djrq,dhrq)>1 
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-20'and djrq<>'2012-10-26'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-24'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'
and a.FDate<>'2013-02-02'
and a.FDate<>'2013-02-09'
and a.FDate<>'2013-02-16'
and a.FDate<>'2013-02-23'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) and datediff(day,djrq,dhrq)>2)
or (djrq in ('2012-10-26') and datediff(day,djrq,dhrq)>3))  ) and a.djbh=b.djbh)
else
select * from #Data where 1=1 and djrq<>'2012-04-02' and (  (dhrq='' and datediff(day,djrq,getDate())>1) or ((datediff(day,djrq,dhrq)>1 
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-20'and djrq<>'2012-10-26'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-24'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'
and djrq<>'2013-02-02'
and djrq<>'2013-02-09'
and djrq<>'2013-02-16'
and djrq<>'2013-02-23'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) and datediff(day,djrq,dhrq)>2)
or (djrq in ('2012-10-26') and datediff(day,djrq,dhrq)>3))  )
end

--count--
create procedure list_cpjyjsl_count
@begindate varchar(10),
@enddate varchar(10),
@status int
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
isnull(convert(char(10),c.QDate,120),'') as 'jyrq',isnull(convert(char(10),c.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',b.FQty as 'fssl'
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
left join (select FInStockInterID,FSerialID,MIN(a.FDate) as QDate,MIN(case when a.FResult=286 then c.FDate else a.FDate end) as FDate from ICQCBill a left join ICStockBillEntry b on a.FInterID=b.FSourceInterID left join ICStockBill c on b.FInterID=c.FInterID where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 AND a.FStatus>=1 group by FInStockInterID,FSerialID) c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID   --a.FStatus>=1 : 检验单为保留的入库时间=保留时间  c.FStatus>=1 : 检验单为保留的入库时间=真实入库时间
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>=@begindate AND a.FDate<=@enddate
--AND a.FDate>='2011-10-08' AND a.FDate<='2011-10-31'
order by a.FBillNo

if @status=0
select count(*) from #Data
else if @status=1
select count(*) from #Data a where 1=1 and a.dhrq<>'' and not exists(select * from #Data b where 1=1 and (  /*(dhrq='' and datediff(day,djrq,getDate())>1) or*/ ((datediff(day,djrq,dhrq)>1 
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-20'and djrq<>'2012-10-26'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-24'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'
and djrq<>'2013-02-02'
and djrq<>'2013-02-09'
and djrq<>'2013-02-16'
and djrq<>'2013-02-23'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) and datediff(day,djrq,dhrq)>2)
or (djrq in ('2012-10-26') and datediff(day,djrq,dhrq)>3))  ) and a.djbh=b.djbh)
else
select count(*) from #Data where 1=1 and djrq<>'2012-04-02' and (  (dhrq='' and datediff(day,djrq,getDate())>1) or ((datediff(day,djrq,dhrq)>1 
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-20'and djrq<>'2012-10-26'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-24'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'
and djrq<>'2013-02-02'
and djrq<>'2013-02-09'
and djrq<>'2013-02-16'
and djrq<>'2013-02-23'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) and datediff(day,djrq,dhrq)>2)
or (djrq in ('2012-10-26') and datediff(day,djrq,dhrq)>3))  )
end




execute list_cpjyjsl '2013-10-01','2013-10-31',2

execute list_cpjyjsl_count '2012-02-01','2012-02-29',2


select datediff(day,'2011-10-26','2011-10-28')



select FInStockInterID,FSerialID,c.FInterID/*,MIN(c.FDate) as FDate */
from ICQCBill a 
left join ICStockBillEntry b on a.FInterID=b.FSourceInterID 
left join ICStockBill c on b.FInterID=c.FInterID 
where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 group by a.FInStockInterID,a.FSerialID,c.FInterID





select * from t_ICItem where fnumber in ('07.04.0086','07.04.3022')

select * from t_ICItem where FPlanPrice = 0