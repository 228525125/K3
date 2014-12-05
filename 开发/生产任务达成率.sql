--drop procedure count_scrwjsl

create procedure count_scrwjsl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
scrwzs int default(0)
,scrwasjh int default(0)
,scrwwasjh int default(0)
,scrwjsl decimal(28,2) default(0)
,scrwtx int default(0)
)

Insert Into #Data(scrwzs,scrwasjh,scrwwasjh,scrwjsl,scrwtx
)
Select sum(1) as 'scrwzs'
,sum(case when (q.FDate is not null and q.FDate <= v1.FPlanFinishDate) or (r.FDate is not null and r.FDate <= v1.FPlanFinishDate) then 1 else 0 end) as 'scrwasjh'
,sum(case when case when q.FDate is not null then convert(char(10),q.FDate,120) when r.FDate is not null then convert(char(10),r.FDate,120) else convert(char(10),getDate(),120) end > v1.FPlanFinishDate then 1 else 0 end) as 'scrwwasjh'
,1--CAST(sum(case when q.FDate is not null and q.FDate <= v1.FPlanFinishDate then 1 else 0 end) as decimal(28,2))/CAST(sum(1) as decimal(28,2))*100 as 'scrwjsl'
,sum(case when q.FDate is null AND r.FDate is null AND datediff(day,v1.FPlanFinishDate,getDate())>=-2 AND v1.FPlanFinishDate>=convert(char(10),getDate(),120) then 1 else 0 end) as 'scrwtx'
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
AND v1.FStatus in (1,3)                     --状态必须是下达或结案

select scrwzs,scrwasjh,scrwwasjh,convert(decimal(28,2),convert(decimal(28,2),scrwzs-scrwwasjh)/scrwzs*100) as scrwjsl,scrwtx from #Data
end

execute count_scrwjsl '2013-01-01','2013-01-31'


select * from ICMO where FPlanFinishDate>='2011-10-08'

select * from ICMO v1 

select * from ICQCBill where FBillNo like 'SIPQC%'


select FICMOBillNo,Min(a.FDate) as FDate from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by FICMOBillNo