--drop procedure count_cpjyjsl

create procedure count_cpjyjsl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
cpjyzs int default(0)
,cpjyasjh int default(0)
,cpjywasjh int default(0)
,cpjyjsl decimal(28,2) default(0)
,cptoday int default(0)
)

Insert Into #Data(cpjyzs,cpjyasjh,cpjywasjh,cpjyjsl,cptoday
)
select sum(1) as 'cpjyzs'
,sum(case when (datediff(day,a.FDate,c.FDate)<=1 
and a.FDate<>'2011-10-18' and a.FDate<>'2011-10-15' and a.FDate<>'2011-10-22'and a.FDate<>'2011-10-29'and a.FDate<>'2011-11-05'and a.FDate<>'2011-11-12'and a.FDate<>'2011-11-19'and a.FDate<>'2011-11-26'and a.FDate<>'2011-12-03'and a.FDate<>'2011-12-10'and a.FDate<>'2011-12-17'and a.FDate<>'2011-12-24'and a.FDate<>'2011-12-31'and a.FDate<>'2012-01-07'and a.FDate<>'2012-01-14'and a.FDate<>'2012-01-21'and a.FDate<>'2012-01-28'and a.FDate<>'2012-02-04'and a.FDate<>'2012-02-11'and a.FDate<>'2012-02-18'and a.FDate<>'2012-02-25'and a.FDate<>'2012-03-03'and a.FDate<>'2012-03-10'and a.FDate<>'2012-03-17'and a.FDate<>'2012-03-24'and a.FDate<>'2012-03-31'and a.FDate<>'2012-04-02'and a.FDate<>'2012-04-07'and a.FDate<>'2012-04-14'and a.FDate<>'2012-04-21'and a.FDate<>'2012-04-28'and a.FDate<>'2012-05-05'and a.FDate<>'2012-05-12'and a.FDate<>'2012-05-19'and a.FDate<>'2012-05-26'and a.FDate<>'2012-06-02'and a.FDate<>'2012-06-09'and a.FDate<>'2012-06-16'and a.FDate<>'2012-06-23'and a.FDate<>'2012-06-30'and a.FDate<>'2012-07-07'and a.FDate<>'2012-07-14'and a.FDate<>'2012-07-21'and a.FDate<>'2012-07-28'and a.FDate<>'2012-08-04'and a.FDate<>'2012-08-11'and a.FDate<>'2012-08-18'and a.FDate<>'2012-08-25'and a.FDate<>'2012-09-01'and a.FDate<>'2012-09-08'and a.FDate<>'2012-09-15'and a.FDate<>'2012-09-22'and a.FDate<>'2012-09-29'and a.FDate<>'2012-10-06'and a.FDate<>'2012-10-13'and a.FDate<>'2012-10-19'and a.FDate<>'2012-10-26'and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-24'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29' 
and a.FDate<>'2013-02-02'
and a.FDate<>'2013-02-09'
and a.FDate<>'2013-02-16'
and a.FDate<>'2013-02-23'
) or (datediff(day,a.FDate,c.FDate)<=2
and a.FDate in (
'2011-10-18','2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) or (a.FDate in ('2012-10-19','2012-10-26') and datediff(day,a.FDate,c.FDate)<=3) )
then 1 else 0 end) as 'cpjyasjh'
--,1 as 'cpjyasjh'
,sum(case when ((datediff(day,a.FDate,c.FDate)>1 
and a.FDate<>'2011-10-18' and a.FDate<>'2011-10-15' and a.FDate<>'2011-10-22'and a.FDate<>'2011-10-29'and a.FDate<>'2011-11-05'and a.FDate<>'2011-11-12'and a.FDate<>'2011-11-19'and a.FDate<>'2011-11-26'and a.FDate<>'2011-12-03'and a.FDate<>'2011-12-10'and a.FDate<>'2011-12-17'and a.FDate<>'2011-12-24'and a.FDate<>'2011-12-31'and a.FDate<>'2012-01-07'and a.FDate<>'2012-01-14'and a.FDate<>'2012-01-21'and a.FDate<>'2012-01-28'and a.FDate<>'2012-02-04'and a.FDate<>'2012-02-11'and a.FDate<>'2012-02-18'and a.FDate<>'2012-02-25'and a.FDate<>'2012-03-03'and a.FDate<>'2012-03-10'and a.FDate<>'2012-03-17'and a.FDate<>'2012-03-24'and a.FDate<>'2012-03-31'and a.FDate<>'2012-04-02'and a.FDate<>'2012-04-07'and a.FDate<>'2012-04-14'and a.FDate<>'2012-04-21'and a.FDate<>'2012-04-28'and a.FDate<>'2012-05-05'and a.FDate<>'2012-05-12'and a.FDate<>'2012-05-19'and a.FDate<>'2012-05-26'and a.FDate<>'2012-06-02'and a.FDate<>'2012-06-09'and a.FDate<>'2012-06-16'and a.FDate<>'2012-06-23'and a.FDate<>'2012-06-30'and a.FDate<>'2012-07-07'and a.FDate<>'2012-07-14'and a.FDate<>'2012-07-21'and a.FDate<>'2012-07-28'and a.FDate<>'2012-08-04'and a.FDate<>'2012-08-11'and a.FDate<>'2012-08-18'and a.FDate<>'2012-08-25'and a.FDate<>'2012-09-01'and a.FDate<>'2012-09-08'and a.FDate<>'2012-09-15'and a.FDate<>'2012-09-22'and a.FDate<>'2012-09-29'and a.FDate<>'2012-10-06'and a.FDate<>'2012-10-13'and a.FDate<>'2012-10-19'and a.FDate<>'2012-10-26'and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-24'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29'
and a.FDate<>'2013-02-02'
and a.FDate<>'2013-02-09'
and a.FDate<>'2013-02-16'
and a.FDate<>'2013-02-23'
) or (a.FDate in (
'2011-10-18','2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) and datediff(day,a.FDate,c.FDate)>2) 
or (a.FDate in ('2012-10-26') and datediff(day,a.FDate,c.FDate)>3) ) or (
c.FDate is null and ( (datediff(day,a.FDate,getDate())>1 
and a.FDate<>'2011-10-18' and a.FDate<>'2011-10-15' and a.FDate<>'2011-10-22'and a.FDate<>'2011-10-29'and a.FDate<>'2011-11-05'and a.FDate<>'2011-11-12'and a.FDate<>'2011-11-19'and a.FDate<>'2011-11-26'and a.FDate<>'2011-12-03'and a.FDate<>'2011-12-10'and a.FDate<>'2011-12-17'and a.FDate<>'2011-12-24'and a.FDate<>'2011-12-31'and a.FDate<>'2012-01-07'and a.FDate<>'2012-01-14'and a.FDate<>'2012-01-21'and a.FDate<>'2012-01-28'and a.FDate<>'2012-02-04'and a.FDate<>'2012-02-11'and a.FDate<>'2012-02-18'and a.FDate<>'2012-02-25'and a.FDate<>'2012-03-03'and a.FDate<>'2012-03-10'and a.FDate<>'2012-03-17'and a.FDate<>'2012-03-24'and a.FDate<>'2012-03-31'and a.FDate<>'2012-04-02'and a.FDate<>'2012-04-07'and a.FDate<>'2012-04-14'and a.FDate<>'2012-04-21'and a.FDate<>'2012-04-28'and a.FDate<>'2012-05-05'and a.FDate<>'2012-05-12'and a.FDate<>'2012-05-19'and a.FDate<>'2012-05-26'and a.FDate<>'2012-06-02'and a.FDate<>'2012-06-09'and a.FDate<>'2012-06-16'and a.FDate<>'2012-06-23'and a.FDate<>'2012-06-30'and a.FDate<>'2012-07-07'and a.FDate<>'2012-07-14'and a.FDate<>'2012-07-21'and a.FDate<>'2012-07-28'and a.FDate<>'2012-08-04'and a.FDate<>'2012-08-11'and a.FDate<>'2012-08-18'and a.FDate<>'2012-08-25'and a.FDate<>'2012-09-01'and a.FDate<>'2012-09-08'and a.FDate<>'2012-09-15'and a.FDate<>'2012-09-22'and a.FDate<>'2012-09-29'and a.FDate<>'2012-10-06'and a.FDate<>'2012-10-13'and a.FDate<>'2012-10-20'and a.FDate<>'2012-10-26'and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-24'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29'
and a.FDate<>'2013-02-02'
and a.FDate<>'2013-02-09'
and a.FDate<>'2013-02-16'
and a.FDate<>'2013-02-23'
) or (a.FDate in (
'2011-10-18','2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-20','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-11-24','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29',
'2013-02-02',
'2013-02-09',
'2013-02-16',
'2013-02-23'
) and datediff(day,a.FDate,getDate())>2)
or (a.FDate in ('2012-10-26') and datediff(day,a.FDate,getdate())>3) )
) then 1 else 0 end) as 'cpjywasjh'
--,CAST(sum(case when datediff(day,a.FDate,c.FDate)<=1 then 1 else 0 end) as decimal(28,2))/CAST(sum(1) as decimal(28,2))*100 as 'cpjyjsl'
,1 as 'cpjyjsl'
,sum(case when c.FDate is null and (datediff(day,a.FDate,getDate())<30) then 1 else 0 end) as 'cptoday'
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
left join (select FInStockInterID,FSerialID,MIN(case when a.FResult=286 then c.FDate else a.FDate end) as FDate from ICQCBill a left join ICStockBillEntry b on a.FInterID=b.FSourceInterID left join ICStockBill c on b.FInterID=c.FInterID where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 group by FInStockInterID,FSerialID) c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>=@begindate AND a.FDate<=@enddate

select cpjyzs,cpjyasjh,cpjywasjh,CONVERT(decimal(28,2),CONVERT(decimal(28,2),(cpjyzs-cpjywasjh))/cpjyzs*100) as cpjyjsl,cptoday from #Data
end


execute count_cpjyjsl '2013-02-01','2013-02-28'


select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND  v1.FCancellation = 0





select * 
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
left join (select FInStockInterID,FSerialID,MIN(c.FDate) as FDate from ICQCBill a left join ICStockBillEntry b on a.FInterID=b.FSourceInterID left join ICStockBill c on b.FInterID=c.FInterID where a.FTranType=713 AND a.FCancellation = 0 AND a.FInStockInterID>0 group by FInStockInterID,FSerialID) c on c.FInStockInterID=b.FInterID and c.FSerialID=b.FEntryID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>='2011-11-01' AND a.FDate<='2011-11-30'
