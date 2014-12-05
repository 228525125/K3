--drop procedure count_wwjyjsl

create procedure count_wwjyjsl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
wwjyzs int default(0)
,wwjyasjh int default(0)
,wwjywasjh int default(0)
,wwjyjsl decimal(28,2) default(0)
,wwtoday int default(0)
)

Insert Into #Data(wwjyzs,wwjyasjh,wwjywasjh,wwtoday
)
select sum(1) as 'wwjyzs',
sum(case when (datediff(day,a.FDate,b.FDate)<=1
and a.FDate<>'2011-10-18' and a.FDate<>'2011-10-15' and a.FDate<>'2011-10-22'and a.FDate<>'2011-10-29'and a.FDate<>'2011-11-05'and a.FDate<>'2011-11-12'and a.FDate<>'2011-11-19'and a.FDate<>'2011-11-26'and a.FDate<>'2011-12-03'and a.FDate<>'2011-12-10'and a.FDate<>'2011-12-17'and a.FDate<>'2011-12-24'and a.FDate<>'2011-12-31'and a.FDate<>'2012-01-07'and a.FDate<>'2012-01-14'and a.FDate<>'2012-01-21'and a.FDate<>'2012-01-28'and a.FDate<>'2012-02-04'and a.FDate<>'2012-02-11'and a.FDate<>'2012-02-18'and a.FDate<>'2012-02-25'and a.FDate<>'2012-03-03'and a.FDate<>'2012-03-10'and a.FDate<>'2012-03-17'and a.FDate<>'2012-03-24'and a.FDate<>'2012-03-31'and a.FDate<>'2012-04-02'and a.FDate<>'2012-04-07'and a.FDate<>'2012-04-14'and a.FDate<>'2012-04-21'and a.FDate<>'2012-04-28'and a.FDate<>'2012-05-05'and a.FDate<>'2012-05-12'and a.FDate<>'2012-05-19'and a.FDate<>'2012-05-26'and a.FDate<>'2012-06-02'and a.FDate<>'2012-06-09'and a.FDate<>'2012-06-16'and a.FDate<>'2012-06-23'and a.FDate<>'2012-06-30'and a.FDate<>'2012-07-07'and a.FDate<>'2012-07-14'and a.FDate<>'2012-07-21'and a.FDate<>'2012-07-28'and a.FDate<>'2012-08-04'and a.FDate<>'2012-08-11'and a.FDate<>'2012-08-18'and a.FDate<>'2012-08-25'and a.FDate<>'2012-09-01'and a.FDate<>'2012-09-08'and a.FDate<>'2012-09-15'and a.FDate<>'2012-09-22'and a.FDate<>'2012-09-29'and a.FDate<>'2012-10-06'and a.FDate<>'2012-10-13'and a.FDate<>'2012-10-19'and a.FDate<>'2012-10-27'and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-23'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29'and a.FDate<>'2013-01-05'and a.FDate<>'2013-01-12'and a.FDate<>'2013-01-19'and a.FDate<>'2013-01-26'and a.FDate<>'2013-03-02'and a.FDate<>'2013-03-09'and a.FDate<>'2013-03-16'and a.FDate<>'2013-03-23'and a.FDate<>'2013-03-30'and a.FDate<>'2013-04-06'and a.FDate<>'2013-04-13'and a.FDate<>'2013-04-20'and a.FDate<>'2013-04-27'and a.FDate<>'2013-05-04'and a.FDate<>'2013-05-11'and a.FDate<>'2013-05-18'and a.FDate<>'2013-05-25'and a.FDate<>'2013-06-01'and a.FDate<>'2013-06-08'and a.FDate<>'2013-06-15'and a.FDate<>'2013-06-22'and a.FDate<>'2013-06-29'
and a.FDate<>'2013-07-15'
and a.FDate<>'2013-12-07'
and a.FDate<>'2013-12-14'
and a.FDate<>'2013-12-21'
and a.FDate<>'2013-12-28'
) or (datediff(day,a.FDate,b.FDate)<=2
and a.FDate in ('2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15',
'2013-12-07',
'2013-12-14',
'2013-12-21',
'2013-12-28'
) or (a.FDate in ('2012-10-19','2012-11-23') and datediff(day,a.FDate,b.FDate)<=3) )
 then 1 else 0 end) as 'wwjyasjh',
sum(case when ((datediff(day,a.FDate,b.FDate)>1 and a.FDate<>'2011-10-18' and a.FDate<>'2011-10-15' and a.FDate<>'2011-10-22'and a.FDate<>'2011-10-29'and a.FDate<>'2011-11-05'and a.FDate<>'2011-11-12'and a.FDate<>'2011-11-19'and a.FDate<>'2011-11-26'and a.FDate<>'2011-12-03'and a.FDate<>'2011-12-10'and a.FDate<>'2011-12-17'and a.FDate<>'2011-12-24'and a.FDate<>'2011-12-31'and a.FDate<>'2012-01-07'and a.FDate<>'2012-01-14'and a.FDate<>'2012-01-21'and a.FDate<>'2012-01-28'and a.FDate<>'2012-02-04'and a.FDate<>'2012-02-11'and a.FDate<>'2012-02-18'and a.FDate<>'2012-02-25'and a.FDate<>'2012-03-03'and a.FDate<>'2012-03-10'and a.FDate<>'2012-03-17'and a.FDate<>'2012-03-24'and a.FDate<>'2012-03-31'and a.FDate<>'2012-04-02'and a.FDate<>'2012-04-07'and a.FDate<>'2012-04-14'and a.FDate<>'2012-04-21'and a.FDate<>'2012-04-28'and a.FDate<>'2012-05-05'and a.FDate<>'2012-05-12'and a.FDate<>'2012-05-19'and a.FDate<>'2012-05-26'and a.FDate<>'2012-06-02'and a.FDate<>'2012-06-09'and a.FDate<>'2012-06-16'and a.FDate<>'2012-06-23'and a.FDate<>'2012-06-30'and a.FDate<>'2012-07-07'and a.FDate<>'2012-07-14'and a.FDate<>'2012-07-21'and a.FDate<>'2012-07-28'and a.FDate<>'2012-08-04'and a.FDate<>'2012-08-11'and a.FDate<>'2012-08-18'and a.FDate<>'2012-08-25'and a.FDate<>'2012-09-01'and a.FDate<>'2012-09-08'and a.FDate<>'2012-09-15'and a.FDate<>'2012-09-22'and a.FDate<>'2012-09-29'and a.FDate<>'2012-10-06'and a.FDate<>'2012-10-13'and a.FDate<>'2012-10-19'and a.FDate<>'2012-10-27'and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-23'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29'and a.FDate<>'2013-01-05'and a.FDate<>'2013-01-12'and a.FDate<>'2013-01-19'and a.FDate<>'2013-01-26'and a.FDate<>'2013-03-02'and a.FDate<>'2013-03-09'and a.FDate<>'2013-03-16'and a.FDate<>'2013-03-23'and a.FDate<>'2013-03-30'and a.FDate<>'2013-04-06'and a.FDate<>'2013-04-13'and a.FDate<>'2013-04-20'and a.FDate<>'2013-04-27'and a.FDate<>'2013-05-04'and a.FDate<>'2013-05-11'and a.FDate<>'2013-05-18'and a.FDate<>'2013-05-25'and a.FDate<>'2013-06-01'and a.FDate<>'2013-06-08'and a.FDate<>'2013-06-15'and a.FDate<>'2013-06-22'and a.FDate<>'2013-06-29'
and a.FDate<>'2013-07-15'
) or (a.FDate in ('2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15',
'2013-12-07',
'2013-12-14',
'2013-12-21',
'2013-12-28'
) and datediff(day,a.FDate,b.FDate)>2)
or (a.FDate in ('2012-10-19','2012-11-23') and datediff(day,a.FDate,b.FDate)>3) ) or (
b.FDate is null and ( (datediff(day,a.FDate,getDate())>1 
and a.FDate<>'2011-10-18' and a.FDate<>'2011-10-15' and a.FDate<>'2011-10-22'and a.FDate<>'2011-10-29'and a.FDate<>'2011-11-05'and a.FDate<>'2011-11-12'and a.FDate<>'2011-11-19'and a.FDate<>'2011-11-26'and a.FDate<>'2011-12-03'and a.FDate<>'2011-12-10'and a.FDate<>'2011-12-17'and a.FDate<>'2011-12-24'and a.FDate<>'2011-12-31'and a.FDate<>'2012-01-07'and a.FDate<>'2012-01-14'and a.FDate<>'2012-01-21'and a.FDate<>'2012-01-28'and a.FDate<>'2012-02-04'and a.FDate<>'2012-02-11'and a.FDate<>'2012-02-18'and a.FDate<>'2012-02-25'and a.FDate<>'2012-03-03'and a.FDate<>'2012-03-10'and a.FDate<>'2012-03-17'and a.FDate<>'2012-03-24'and a.FDate<>'2012-03-31'and a.FDate<>'2012-04-02'and a.FDate<>'2012-04-07'and a.FDate<>'2012-04-14'and a.FDate<>'2012-04-21'and a.FDate<>'2012-04-28'and a.FDate<>'2012-05-05'and a.FDate<>'2012-05-12'and a.FDate<>'2012-05-19'and a.FDate<>'2012-05-26'and a.FDate<>'2012-06-02'and a.FDate<>'2012-06-09'and a.FDate<>'2012-06-16'and a.FDate<>'2012-06-23'and a.FDate<>'2012-06-30'and a.FDate<>'2012-07-07'and a.FDate<>'2012-07-14'and a.FDate<>'2012-07-21'and a.FDate<>'2012-07-28'and a.FDate<>'2012-08-04'and a.FDate<>'2012-08-11'and a.FDate<>'2012-08-18'and a.FDate<>'2012-08-25'and a.FDate<>'2012-09-01'and a.FDate<>'2012-09-08'and a.FDate<>'2012-09-15'and a.FDate<>'2012-09-22'and a.FDate<>'2012-09-29'and a.FDate<>'2012-10-06'and a.FDate<>'2012-10-13'and a.FDate<>'2012-10-19'and a.FDate<>'2012-10-27'and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-23'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29'and a.FDate<>'2013-01-05'and a.FDate<>'2013-01-12'and a.FDate<>'2013-01-19'and a.FDate<>'2013-01-26'and a.FDate<>'2013-03-02'and a.FDate<>'2013-03-09'and a.FDate<>'2013-03-16'and a.FDate<>'2013-03-23'and a.FDate<>'2013-03-30'and a.FDate<>'2013-04-06'and a.FDate<>'2013-04-13'and a.FDate<>'2013-04-20'and a.FDate<>'2013-04-27'and a.FDate<>'2013-05-04'and a.FDate<>'2013-05-11'and a.FDate<>'2013-05-18'and a.FDate<>'2013-05-25'and a.FDate<>'2013-06-01'and a.FDate<>'2013-06-08'and a.FDate<>'2013-06-15'and a.FDate<>'2013-06-22'and a.FDate<>'2013-06-29'
and a.FDate<>'2013-07-15'
and a.FDate<>'2013-12-07'
and a.FDate<>'2013-12-14'
and a.FDate<>'2013-12-21'
and a.FDate<>'2013-12-28'
) or (a.FDate in ('2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15',
'2013-12-07',
'2013-12-14',
'2013-12-21',
'2013-12-28'
) and datediff(day,a.FDate,getDate())>2)
or (a.FDate in ('2012-10-19','2012-11-23') and datediff(day,a.FDate,getdate())>3) )
) then 1 else 0 end) as 'wwjywasjh',
sum(case when b.FDate is null and (datediff(day,a.FDate,getDate())<30) then 1 else 0 end) as 'wwtoday'
FROM rss.dbo.wwzc_wwjysqd a 
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate, FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty --and exists(select a1.FInterID,a1.FEntryID from ICShop_SubcOutEntry a1 inner join (select FSHSubcOutInterID,FSHSubcOutEntryID,sum(FCheckQty) as FCheckQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID) b1 on b1.FSHSubcOutInterID=a1.FInterID and b1.FSHSubcOutEntryID=a1.FEntryID and a1.FTranOutQty=b1.FCheckQty where a1.FInterID=a.FSourceInterID and a1.FEntryID=a.FSourceEntryID)
where 1=1
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND (a.jyfs = '¼ìÑé' or a.jyfs is null)
--AND a.FDate>='2012-02-01' AND a.FDate<='2012-02-28'

select wwjyzs,wwjyasjh,wwjywasjh,CONVERT(decimal(28,2),CONVERT(decimal(28,2),(wwjyzs-wwjywasjh))/wwjyzs*100) as wwjyjsl,wwtoday from #Data
end

select datediff(day,'2012-10-23','2012-10-26')

execute count_wwjyjsl '2013-12-01','2013-12-31'

execute count_wwjyjsl '2012-11-01','2012-11-30'



select * from ICQCBill where 1=1 AND (FTranType=715 AND FCancellation = 0)


execute count_wwjyjsl '2012-04-01','2012-04-30'


select FSpecialUse,* from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0
and FBillNo in ('SIPQC002377','SIPQC000002')


select sum(1) as 'wxpczs'
,sum(case when FResult=286 then 1 else 0 end) as 'wxhgs'
,sum(case when FResult<>286 then 1 else 0 end) as 'bhgs'
,sum(case when FSpecialUse=1077 or FSpecialUse=1037 then 1 else 0 end) as 'rbjss'
,sum(case when FResult<>286 then 1 else 0 end) as 'jss'
from ICQCBill 
where FTranType=715 AND FCancellation = 0 AND FStatus>0
and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and FResult <> 13556



select *
FROM rss.dbo.wwzc_wwjysqd a 
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate, FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty --and exists(select a1.FInterID,a1.FEntryID from ICShop_SubcOutEntry a1 inner join (select FSHSubcOutInterID,FSHSubcOutEntryID,sum(FCheckQty) as FCheckQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID) b1 on b1.FSHSubcOutInterID=a1.FInterID and b1.FSHSubcOutEntryID=a1.FEntryID and a1.FTranOutQty=b1.FCheckQty where a1.FInterID=a.FSourceInterID and a1.FEntryID=a.FSourceEntryID)
where 1=1
AND a.FDate>='2012-11-01' AND a.FDate<='2012-11-30'
and ( datediff(day,a.FDate,b.FDate)>1 and a.FDate<>'2012-11-03'and a.FDate<>'2012-11-10'and a.FDate<>'2012-11-17'and a.FDate<>'2012-11-23'and a.FDate<>'2012-12-01'and a.FDate<>'2012-12-08'and a.FDate<>'2012-12-15'and a.FDate<>'2012-12-22'and a.FDate<>'2012-12-29') 
or (a.FDate in ('2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29') and datediff(day,a.FDate,b.FDate)>2)
or (a.FDate in ('2012-10-19','2012-11-23') and datediff(day,a.FDate,b.FDate)>3) ) 
or (
b.FDate is null and ( (datediff(day,a.FDate,getDate())>1 
and a.FDate<>'2011-10-18' 
and a.FDate<>'2011-10-15' 
and a.FDate<>'2011-10-22'
and a.FDate<>'2011-10-29'
and a.FDate<>'2011-11-05'
and a.FDate<>'2011-11-12'
and a.FDate<>'2011-11-19'
and a.FDate<>'2011-11-26'
and a.FDate<>'2011-12-03'
and a.FDate<>'2011-12-10'
and a.FDate<>'2011-12-17'
and a.FDate<>'2011-12-24'
and a.FDate<>'2011-12-31'
and a.FDate<>'2012-01-07'
and a.FDate<>'2012-01-14'
and a.FDate<>'2012-01-21'
and a.FDate<>'2012-01-28'
and a.FDate<>'2012-02-04'
and a.FDate<>'2012-02-11'
and a.FDate<>'2012-02-18'
and a.FDate<>'2012-02-25'
and a.FDate<>'2012-03-03'
and a.FDate<>'2012-03-10'
and a.FDate<>'2012-03-17'
and a.FDate<>'2012-03-24'
and a.FDate<>'2012-03-31'
and a.FDate<>'2012-04-02'
and a.FDate<>'2012-04-07'
and a.FDate<>'2012-04-14'
and a.FDate<>'2012-04-21'
and a.FDate<>'2012-04-28'
and a.FDate<>'2012-05-05'
and a.FDate<>'2012-05-12'
and a.FDate<>'2012-05-19'
and a.FDate<>'2012-05-26'
and a.FDate<>'2012-06-02'
and a.FDate<>'2012-06-09'
and a.FDate<>'2012-06-16'
and a.FDate<>'2012-06-23'
and a.FDate<>'2012-06-30'
and a.FDate<>'2012-07-07'
and a.FDate<>'2012-07-14'
and a.FDate<>'2012-07-21'
and a.FDate<>'2012-07-28'
and a.FDate<>'2012-08-04'
and a.FDate<>'2012-08-11'
and a.FDate<>'2012-08-18'
and a.FDate<>'2012-08-25'
and a.FDate<>'2012-09-01'
and a.FDate<>'2012-09-08'
and a.FDate<>'2012-09-15'
and a.FDate<>'2012-09-22'
and a.FDate<>'2012-09-29'
and a.FDate<>'2012-10-06'
and a.FDate<>'2012-10-13'
and a.FDate<>'2012-10-19'
and a.FDate<>'2012-10-27'
and a.FDate<>'2012-11-03'
and a.FDate<>'2012-11-10'
and a.FDate<>'2012-11-17'
and a.FDate<>'2012-11-23'
and a.FDate<>'2012-12-01'
and a.FDate<>'2012-12-08'
and a.FDate<>'2012-12-15'
and a.FDate<>'2012-12-22'
and a.FDate<>'2012-12-29'
) or (a.FDate in (
'2011-10-18', 
'2011-10-15',
'2011-10-22',
'2011-10-29',
'2011-11-05',
'2011-11-12',
'2011-11-19',
'2011-11-26',
'2011-12-03',
'2011-12-10',
'2011-12-17',
'2011-12-24',
'2011-12-31',
'2012-01-07',
'2012-01-14',
'2012-01-21',
'2012-01-28',
'2012-02-04',
'2012-02-11',
'2012-02-18',
'2012-02-25',
'2012-03-03',
'2012-03-10',
'2012-03-17',
'2012-03-24',
'2012-03-31',
'2012-04-02',
'2012-04-07',
'2012-04-14',
'2012-04-21',
'2012-04-28',
'2012-05-05',
'2012-05-12',
'2012-05-19',
'2012-05-26',
'2012-06-02',
'2012-06-09',
'2012-06-16',
'2012-06-23',
'2012-06-30',
'2012-07-07',
'2012-07-14',
'2012-07-21',
'2012-07-28',
'2012-08-04',
'2012-08-11',
'2012-08-18',
'2012-08-25',
'2012-09-01',
'2012-09-08',
'2012-09-15',
'2012-09-22',
'2012-09-29',
'2012-10-06',
'2012-10-13',
'2012-10-27',
'2012-11-03',
'2012-11-10',
'2012-11-17',
'2012-12-01',
'2012-12-08',
'2012-12-15',
'2012-12-22',
'2012-12-29'
) and datediff(day,a.FDate,getDate())>2)
or (a.FDate in ('2012-10-19','2012-11-23') and datediff(day,a.FDate,getdate())>3) )


select * from rss.dbo.wwzc_wwjysqd where fsourceinterid in (99999)

delete rss.dbo.wwzc_wwjysqd where fsourceinterid in (99999)

update rss.dbo.wwzc_wwjysqd set FDate='2012-11-23' where fid in (1065,1064)


select * from 

ALTER TABLE wwzc_wwjysqd ADD curdate datetime DEFAULT getDate()



insert rss.dbo.wwzc_wwjysqd(FSourceInterID,FSourceEntryID,FQty,FDate,remark,curdate) values (99999,99999,1,convert(char(10),getDate(),120),'remark+',getDate())

select * f

