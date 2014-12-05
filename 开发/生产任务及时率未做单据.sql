--drop procedure list_scrwwzdj drop procedure list_scrwwzdj_count

create procedure list_scrwwzdj
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
,aqkc decimal(28,2) default(0)
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,aqkc
)
select v1.FBillNo as 'djbh',convert(char(10),v1.FCheckDate,120) as 'djrq',
isnull(convert(char(10),v1.FPlanFinishDate,120),'') as 'jhrq',
case when q.FDate is not null then convert(char(10),q.FDate,120) when r.FDate is not null then convert(char(10),r.FDate,120) else '' end  as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',v1.FQty as 'fssl',isnull(b.FSecInv,0) as 'aqkc'
from ICMO v1 
LEFT OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
left join t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (
select a.FICMOInterID,MIN(a.FDate) as FDate,b.FItemID,sum(b.FQty) as FQty from QMICMOCKRequest a left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID,b.FItemID
) q on q.FICMOInterID=v1.FInterID and v1.FItemID=q.FItemID                              --送检日期
LEFT JOIN (
select MIN(FDate) as FDate,FICMOInterID,FItemID,sum(FPassQty) as FPassQty from ICQCBill where FBillNo like 'SIPQC%' group by FICMOInterID,FItemID
) w on v1.FInterID=w.FICMOInterID and v1.FItemID=w.FItemID
LEFT JOIN (
select FInterID,FItemID,MAX(FDate) as FDate,sum(FQty) as FQty from SEOrderEntry group by FInterID,FItemID
) o on v1.FOrderInterID=o.FInterID and o.FItemID=v1.FItemID        --订单交期
LEFT JOIN (
select u1.FICMOInterID,u1.FICMOBillNo,sum(u1.FQty) as FQty,Min(v1.FCheckDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 where v1.FCheckerID>0 AND v1.FTranType=2 AND  v1.FCancellation = 0 group by u1.FICMOInterID,u1.FICMOBillNo
) r on r.FICMOInterID=v1.FInterID 
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FPlanFinishDate>=@begindate AND  v1.FPlanFinishDate<=@enddate
--AND v1.FPlanFinishDate>='2011-11-01' AND  v1.FPlanFinishDate<='2011-11-30'
AND v1.FStatus in (1,3)                     --状态必须是下达或结案
AND q.FDate is null 
AND r.FDate is null
AND datediff(day,v1.FPlanFinishDate,getDate())>=-2 
AND v1.FPlanFinishDate>=convert(char(10),getDate(),120)
order by b.FSecInv,v1.FBillNo

select * from #Data
end

--count--
create procedure list_scrwwzdj_count
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,jhrq nvarchar(255) default('')
,dhrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,fssl decimal(28,2) default(0)
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl
)
select v1.FBillNo as 'djbh',convert(char(10),v1.FCheckDate,120) as 'djrq',
isnull(convert(char(10),v1.FPlanFinishDate,120),'') as 'jhrq',
case when q.FDate is not null then convert(char(10),q.FDate,120) when r.FDate is not null then convert(char(10),r.FDate,120) else '' end  as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',v1.FQty as 'fssl'
from ICMO v1 
LEFT OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (
select a.FICMOInterID,MIN(a.FDate) as FDate,b.FItemID,sum(b.FQty) as FQty from QMICMOCKRequest a left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID,b.FItemID
) q on q.FICMOInterID=v1.FInterID and v1.FItemID=q.FItemID                              --送检日期
LEFT JOIN (
select MIN(FDate) as FDate,FICMOInterID,FItemID,sum(FPassQty) as FPassQty from ICQCBill where FBillNo like 'SIPQC%' group by FICMOInterID,FItemID
) w on v1.FInterID=w.FICMOInterID and v1.FItemID=w.FItemID
LEFT JOIN (
select FInterID,FItemID,MAX(FDate) as FDate,sum(FQty) as FQty from SEOrderEntry group by FInterID,FItemID
) o on v1.FOrderInterID=o.FInterID and o.FItemID=v1.FItemID        --订单交期
LEFT JOIN (
select u1.FICMOInterID,u1.FICMOBillNo,sum(u1.FQty) as FQty,Min(v1.FCheckDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 where v1.FCheckerID>0 AND v1.FTranType=2 AND  v1.FCancellation = 0 group by u1.FICMOInterID,u1.FICMOBillNo
) r on r.FICMOInterID=v1.FInterID 
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FPlanFinishDate>=@begindate AND  v1.FPlanFinishDate<=@enddate
--AND v1.FPlanFinishDate>='2011-11-01' AND  v1.FPlanFinishDate<='2011-11-30'
AND v1.FStatus in (1,3)                     --状态必须是下达或结案
AND q.FDate is null 
AND r.FDate is null
AND datediff(day,v1.FPlanFinishDate,getDate())>=-2 
AND v1.FPlanFinishDate>=convert(char(10),getDate(),120)
order by v1.FBillNo

select count(*) from #Data
end

select datediff(day,'2011-11-30',getDate())


