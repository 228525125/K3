/*委外检验未做单据明细*/
--drop procedure list_wwjywzdj drop procedure list_wwjywzdj_count

create procedure list_wwjywzdj
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
,wlth nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
)

Insert Into #Data(djbh,djrq,jyrq,dhrq,wldm,wlmc,wlgg,wlth,jldw,fssl
)
select d.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),b.FDate,120),'') as 'jyrq',isnull(convert(char(10),b.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',i.FHelpCode as 'wlth',mu.FName as 'jldw',a.FQty as 'fssl'
FROM rss.dbo.wwzc_wwjysqd a 
LEFT JOIN ICShop_SubcOutEntry c on a.FSourceInterID=c.FInterID and a.FSourceEntryID=c.FEntryID 
LEFT JOIN ICShop_SubcOut d on c.FInterID=d.FInterID 
--LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate,case when MAX(FResult)=13556 then MAX(FCheckQty) else sum(FCheckQty) end as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 AND FResult<>13556 group by FSHSubcOutInterID,FSHSubcOutEntryID) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty       因为有多次送检的情况，所以这种方式不成立
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MAX(FCheckDate) as FDate,FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty and a.FDate<=b.FDate                           --a.FDate<=b.FDate 表示检验日期必须大于等于送检日期，才算到货检验
LEFT JOIN t_ICItem i on c.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=c.FUnitID 
where 1=1
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND (a.jyfs = '检验' or a.jyfs is null)
AND b.FDate is null 
AND datediff(day,a.FDate,getDate())<30
AND not exists(select * from ICShop_SubcOutEntry a1 inner join (select FSHSubcOutInterID,FSHSubcOutEntryID,sum(FCheckQty) as FCheckQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID) b1 on b1.FSHSubcOutInterID=a1.FInterID and b1.FSHSubcOutEntryID=a1.FEntryID and a1.FTranOutQty=b1.FCheckQty where a1.FInterID=a.FSourceInterID and a1.FEntryID=a.FSourceEntryID) 
order by d.FBillNo

select * from #Data
end

--count--
create procedure list_wwjywzdj_count
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
select d.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),b.FDate,120),'') as 'jyrq',isnull(convert(char(10),b.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FHelpCode as 'wlgg',mu.FName as 'jldw',a.FQty as 'fssl'
FROM rss.dbo.wwzc_wwjysqd a 
--LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate,case when MAX(FResult)=13556 then MAX(FCheckQty) else sum(FCheckQty) end as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 AND FResult<>13556 group by FSHSubcOutInterID,FSHSubcOutEntryID) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty       因为有多次送检的情况，所以这种方式不成立
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MAX(FCheckDate) as FDate,FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty and a.FDate<=b.FDate                           --a.FDate<=b.FDate 表示检验日期必须大于等于送检日期，才算到货检验
LEFT JOIN ICShop_SubcOutEntry c on a.FSourceInterID=c.FInterID and a.FSourceEntryID=c.FEntryID 
LEFT JOIN ICShop_SubcOut d on c.FInterID=d.FInterID 
LEFT JOIN t_ICItem i on c.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=c.FUnitID 
where 1=1
AND a.FDate>=@begindate AND a.FDate<=@enddate
AND (a.jyfs = '检验' or a.jyfs is null)
AND b.FDate is null
AND datediff(day,a.FDate,getDate())<30
AND not exists(select * from ICShop_SubcOutEntry a1 inner join (select FSHSubcOutInterID,FSHSubcOutEntryID,sum(FCheckQty) as FCheckQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID) b1 on b1.FSHSubcOutInterID=a1.FInterID and b1.FSHSubcOutEntryID=a1.FEntryID and a1.FTranOutQty=b1.FCheckQty where a1.FInterID=a.FSourceInterID and a1.FEntryID=a.FSourceEntryID) 
order by d.FBillNo

select count(*) from #Data
end


execute list_wwjywzdj '2013-11-01','2013-11-30'

execute list_wwjywzdj_count '2012-09-01','2012-09-30'



select d.FInterID,c.FEntryID,d.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
isnull(convert(char(10),b.FDate,120),'') as 'jyrq',isnull(convert(char(10),b.FDate,120),'') as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',i.FHelpCode as 'wlth',mu.FName as 'jldw',a.FQty as 'fssl'
FROM rss.dbo.wwzc_wwjysqd a 
LEFT JOIN ICShop_SubcOutEntry c on a.FSourceInterID=c.FInterID and a.FSourceEntryID=c.FEntryID 
LEFT JOIN ICShop_SubcOut d on c.FInterID=d.FInterID 
--LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FCheckDate) as FDate,case when MAX(FResult)=13556 then MAX(FCheckQty) else sum(FCheckQty) end as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 AND FResult<>13556 group by FSHSubcOutInterID,FSHSubcOutEntryID) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty       因为有多次送检的情况，所以这种方式不成立
LEFT JOIN (select FSHSubcOutInterID,FSHSubcOutEntryID,MAX(FCheckDate) as FDate,FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty) b on b.FSHSubcOutInterID=a.FSourceInterID and b.FSHSubcOutEntryID=a.FSourceEntryID and a.FQty=b.FQty and a.FDate<=b.FDate                           --a.FDate<=b.FDate 表示检验日期必须大于等于送检日期，才算到货检验
LEFT JOIN t_ICItem i on c.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=c.FUnitID 
where 1=1
AND a.FDate>='2013-11-01' AND a.FDate<='2013-11-30'
AND (a.jyfs = '检验' or a.jyfs is null)
--AND b.FDate is null 
AND datediff(day,a.FDate,getDate())<30
--AND not exists(select * from ICShop_SubcOutEntry a1 inner join (select FSHSubcOutInterID,FSHSubcOutEntryID,sum(FCheckQty) as FCheckQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0 group by FSHSubcOutInterID,FSHSubcOutEntryID) b1 on b1.FSHSubcOutInterID=a1.FInterID and b1.FSHSubcOutEntryID=a1.FEntryID and a1.FTranOutQty=b1.FCheckQty where a1.FInterID=a.FSourceInterID and a1.FEntryID=a.FSourceEntryID) 
AND d.FBillNo='wwzc003087'
order by d.FBillNo


4075	5572

4086    5586	

select FSHSubcOutInterID,FSHSubcOutEntryID,MAX(FCheckDate) as FDate,FCheckQty as FQty from ICQCBill where FTranType=715 AND FCancellation = 0 AND FStatus>0
and FSHSubcOutInterID=4086 and FSHSubcOutEntryID=5586
 group by FSHSubcOutInterID,FSHSubcOutEntryID,FCheckQty

select * from ICQCBill where FTranType=715