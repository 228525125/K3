--drop procedure list_wwjyjsl drop procedure list_wwjyjsl_count

create procedure list_wwjyjsl
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
select d.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),b.FDate,120),'') as 'jyrq',isnull(convert(char(10),b.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',a.FQty as 'fssl'
FROM rss.dbo.wwzc_wwjysqd a 
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate,FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty /*只有不加审核数量，min(FCheckDate)才有意义*/) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty
LEFT JOIN ICShop_SubcOutEntry c on a.FSourceInterID=c.FInterID and a.FSourceEntryID=c.FEntryID 
LEFT JOIN ICShop_SubcOut d on c.FInterID=d.FInterID 
LEFT JOIN t_ICItem i on c.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=c.FUnitID 
where 1=1
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND (a.jyfs = '检验' or a.jyfs is null)
order by d.FBillNo

if @status=0
select * from #Data
else if @status=1
select * from #Data where 1=1 AND dhrq<>'' and ( (datediff(day,djrq,dhrq)<=1 
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-19'and djrq<>'2012-10-27'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-23'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'and djrq<>'2013-01-05'and djrq<>'2013-01-12'and djrq<>'2013-01-19'and djrq<>'2013-01-26'and djrq<>'2013-03-02'and djrq<>'2013-03-09'and djrq<>'2013-03-16'and djrq<>'2013-03-23'and djrq<>'2013-03-30'and djrq<>'2013-04-06'and djrq<>'2013-04-13'and djrq<>'2013-04-20'and djrq<>'2013-04-27'and djrq<>'2013-05-04'and djrq<>'2013-05-11'and djrq<>'2013-05-18'and djrq<>'2013-05-25'and djrq<>'2013-06-01'and djrq<>'2013-06-08'and djrq<>'2013-06-15'and djrq<>'2013-06-22'and djrq<>'2013-06-29'
and djrq<>'2013-07-15'
and djrq<>'2013-12-07'
and djrq<>'2013-12-14'
and djrq<>'2013-12-21'
and djrq<>'2013-12-28'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15',
'2013-12-07',
'2013-12-14',
'2013-12-21',
'2013-12-28'
) and datediff(day,djrq,dhrq)<=2)
or (djrq in ('2012-10-19','2012-11-23') and datediff(day,djrq,dhrq)<=3) )
else 
select * from #Data where 1=1 AND ( (dhrq = '' and datediff(day,djrq,getDate())>1) or ( (datediff(day,djrq,dhrq)>1
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-19'and djrq<>'2012-10-27'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-23'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'and djrq<>'2013-01-05'and djrq<>'2013-01-12'and djrq<>'2013-01-19'and djrq<>'2013-01-26'and djrq<>'2013-03-02'and djrq<>'2013-03-09'and djrq<>'2013-03-16'and djrq<>'2013-03-23'and djrq<>'2013-03-30'and djrq<>'2013-04-06'and djrq<>'2013-04-13'and djrq<>'2013-04-20'and djrq<>'2013-04-27'and djrq<>'2013-05-04'and djrq<>'2013-05-11'and djrq<>'2013-05-18'and djrq<>'2013-05-25'and djrq<>'2013-06-01'and djrq<>'2013-06-08'and djrq<>'2013-06-15'and djrq<>'2013-06-22'and djrq<>'2013-06-29'
and djrq<>'2013-07-15'
and djrq<>'2013-12-07'
and djrq<>'2013-12-14'
and djrq<>'2013-12-21'
and djrq<>'2013-12-28'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15',
'2013-12-07',
'2013-12-14',
'2013-12-21',
'2013-12-28'
) and datediff(day,djrq,dhrq)>2)
or (djrq in ('2012-10-19','2012-11-23') and datediff(day,djrq,dhrq)>3) ) )
end

--count--
create procedure list_wwjyjsl_count
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
select d.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),b.FDate,120),'') as 'jyrq',isnull(convert(char(10),b.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',a.FQty as 'fssl'
FROM rss.dbo.wwzc_wwjysqd a 
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate,FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty /*只有不加审核数量，min(FCheckDate)才有意义*/) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty
LEFT JOIN ICShop_SubcOutEntry c on a.FSourceInterID=c.FInterID and a.FSourceEntryID=c.FEntryID 
LEFT JOIN ICShop_SubcOut d on c.FInterID=d.FInterID 
LEFT JOIN t_ICItem i on c.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=c.FUnitID 
where 1=1
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND (a.jyfs = '检验' or a.jyfs is null)
order by d.FBillNo

if @status=0
select count(*) from #Data
else if @status=1
select count(*) from #Data where 1=1 AND dhrq<>'' and ( (datediff(day,djrq,dhrq)<=1 
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-19'and djrq<>'2012-10-27'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-23'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'and djrq<>'2013-01-05'and djrq<>'2013-01-12'and djrq<>'2013-01-19'and djrq<>'2013-01-26'and djrq<>'2013-03-02'and djrq<>'2013-03-09'and djrq<>'2013-03-16'and djrq<>'2013-03-23'and djrq<>'2013-03-30'and djrq<>'2013-04-06'and djrq<>'2013-04-13'and djrq<>'2013-04-20'and djrq<>'2013-04-27'and djrq<>'2013-05-04'and djrq<>'2013-05-11'and djrq<>'2013-05-18'and djrq<>'2013-05-25'and djrq<>'2013-06-01'and djrq<>'2013-06-08'and djrq<>'2013-06-15'and djrq<>'2013-06-22'and djrq<>'2013-06-29'
and djrq<>'2013-07-15'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15'
) and datediff(day,djrq,dhrq)<=2)
or (djrq in ('2012-10-19','2012-11-23') and datediff(day,djrq,dhrq)<=3) )
else 
select count(*) from #Data where 1=1 AND ( (dhrq = '' and datediff(day,djrq,getDate())>1) or ( (datediff(day,djrq,dhrq)>1
and djrq<>'2011-10-18' and djrq<>'2011-10-15' and djrq<>'2011-10-22'and djrq<>'2011-10-29'and djrq<>'2011-11-05'and djrq<>'2011-11-12'and djrq<>'2011-11-19'and djrq<>'2011-11-26'and djrq<>'2011-12-03'and djrq<>'2011-12-10'and djrq<>'2011-12-17'and djrq<>'2011-12-24'and djrq<>'2011-12-31'and djrq<>'2012-01-07'and djrq<>'2012-01-14'and djrq<>'2012-01-21'and djrq<>'2012-01-28'and djrq<>'2012-02-04'and djrq<>'2012-02-11'and djrq<>'2012-02-18'and djrq<>'2012-02-25'and djrq<>'2012-03-03'and djrq<>'2012-03-10'and djrq<>'2012-03-17'and djrq<>'2012-03-24'and djrq<>'2012-03-31'and djrq<>'2012-04-02'and djrq<>'2012-04-07'and djrq<>'2012-04-14'and djrq<>'2012-04-21'and djrq<>'2012-04-28'and djrq<>'2012-05-05'and djrq<>'2012-05-12'and djrq<>'2012-05-19'and djrq<>'2012-05-26'and djrq<>'2012-06-02'and djrq<>'2012-06-09'and djrq<>'2012-06-16'and djrq<>'2012-06-23'and djrq<>'2012-06-30'and djrq<>'2012-07-07'and djrq<>'2012-07-14'and djrq<>'2012-07-21'and djrq<>'2012-07-28'and djrq<>'2012-08-04'and djrq<>'2012-08-11'and djrq<>'2012-08-18'and djrq<>'2012-08-25'and djrq<>'2012-09-01'and djrq<>'2012-09-08'and djrq<>'2012-09-15'and djrq<>'2012-09-22'and djrq<>'2012-09-29'and djrq<>'2012-10-06'and djrq<>'2012-10-13'and djrq<>'2012-10-19'and djrq<>'2012-10-27'and djrq<>'2012-11-03'and djrq<>'2012-11-10'and djrq<>'2012-11-17'and djrq<>'2012-11-23'and djrq<>'2012-12-01'and djrq<>'2012-12-08'and djrq<>'2012-12-15'and djrq<>'2012-12-22'and djrq<>'2012-12-29'and djrq<>'2013-01-05'and djrq<>'2013-01-12'and djrq<>'2013-01-19'and djrq<>'2013-01-26'and djrq<>'2013-03-02'and djrq<>'2013-03-09'and djrq<>'2013-03-16'and djrq<>'2013-03-23'and djrq<>'2013-03-30'and djrq<>'2013-04-06'and djrq<>'2013-04-13'and djrq<>'2013-04-20'and djrq<>'2013-04-27'and djrq<>'2013-05-04'and djrq<>'2013-05-11'and djrq<>'2013-05-18'and djrq<>'2013-05-25'and djrq<>'2013-06-01'and djrq<>'2013-06-08'and djrq<>'2013-06-15'and djrq<>'2013-06-22'and djrq<>'2013-06-29'
and djrq<>'2013-07-15'
) or (djrq in (
'2011-10-18', '2011-10-15','2011-10-22','2011-10-29','2011-11-05','2011-11-12','2011-11-19','2011-11-26','2011-12-03','2011-12-10','2011-12-17','2011-12-24','2011-12-31','2012-01-07','2012-01-14','2012-01-21','2012-01-28','2012-02-04','2012-02-11','2012-02-18','2012-02-25','2012-03-03','2012-03-10','2012-03-17','2012-03-24','2012-03-31','2012-04-02','2012-04-07','2012-04-14','2012-04-21','2012-04-28','2012-05-05','2012-05-12','2012-05-19','2012-05-26','2012-06-02','2012-06-09','2012-06-16','2012-06-23','2012-06-30','2012-07-07','2012-07-14','2012-07-21','2012-07-28','2012-08-04','2012-08-11','2012-08-18','2012-08-25','2012-09-01','2012-09-08','2012-09-15','2012-09-22','2012-09-29','2012-10-06','2012-10-13','2012-10-27','2012-11-03','2012-11-10','2012-11-17','2012-12-01','2012-12-08','2012-12-15','2012-12-22','2012-12-29','2013-01-05','2013-01-12','2013-01-19','2013-01-26','2013-03-02','2013-03-09','2013-03-16','2013-03-23','2013-03-30','2013-04-06','2013-04-13','2013-04-20','2013-04-27','2013-05-04','2013-05-11','2013-05-18','2013-05-25','2013-06-01','2013-06-08','2013-06-15','2013-06-22','2013-06-29'
,'2013-07-15'
) and datediff(day,djrq,dhrq)>2) 
or (djrq in ('2012-10-19','2012-11-23') and datediff(day,djrq,dhrq)>3)) )
end


execute list_wwjyjsl '2013-12-01','2013-12-31',2


select * from wwzc_wwjysqd

--delete wwzc_wwjysqd

--update wwzc_wwjysqd set FDate='2012-02-01'


select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate,FCheckQty as FQty 
from ICQCBill 
where FTranType=715 AND FCancellation = 0 AND FStatus>0 
--and FBillNo=''
group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty


select * from wwzc_wwjysqd where FDate='2012-12-17' and FID=1139








20.00

select * from ICQCBill where  FSHSubcOutInterID=2683 and FSHSubcOutEntryID=2686


select b.* from ICShop_SubcOut a left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID where FBillNo='WWZC001684'

2683
2686
