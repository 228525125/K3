--drop procedure list_scrwdcl drop procedure list_scrwdcl_count

create procedure list_scrwdcl
@begindate varchar(10),
@enddate varchar(10),
@status int
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
,ddbh nvarchar(255) default('')
,ddjq nvarchar(255) default('')
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,aqkc,ddbh,ddjq
)
select v1.FBillNo as 'djbh',convert(char(10),v1.FCheckDate,120) as 'djrq',
isnull(convert(char(10),v1.FPlanFinishDate,120),'') as 'jhrq',
case when q.FDate is not null then convert(char(10),q.FDate,120) when r.FDate is not null then convert(char(10),r.FDate,120) else '' end  as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',v1.FQty as 'fssl',isnull(b.FSecInv,0) as 'aqkc',isnull(s.FBillNo,'') as ddbh,convert(char(10),se.FDate,120) as 'ddjq'
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
LEFT JOIN (
select FICMOInterID,Min(a.FDate) as FDate from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by FICMOInterID
) j on j.FICMOInterID=v1.FInterID              --委外接收
LEFT JOIN SEOrder s on s.FInterID=v1.FOrderInterID
LEFT JOIN ICMrpResult mr on v1.FPlanOrderInterID=mr.FInterID
LEFT JOIN SEOrderEntry se on se.FInterID=mr.FOrgSaleInterID and se.FEntryID=mr.FOrgEntyrID
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FPlanFinishDate>=@begindate AND  v1.FPlanFinishDate<=@enddate
--AND v1.FPlanFinishDate>='2011-11-01' AND  v1.FPlanFinishDate<='2011-11-30'
AND v1.FStatus in (1,3)                     --状态必须是下达或结案
order by b.FSecInv,v1.FBillNo

if @status=0 
select * from #Data
else if @status=1
select * from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) ) 
else
select * from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end

--count--
create procedure list_scrwdcl_count
@begindate varchar(10),
@enddate varchar(10),
@status int
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
,ddbh nvarchar(255) default('')
)

Insert Into #Data(djbh,djrq,jhrq,dhrq,wldm,wlmc,wlgg,jldw,fssl,aqkc,ddbh
)
select v1.FBillNo as 'djbh',convert(char(10),v1.FCheckDate,120) as 'djrq',
isnull(convert(char(10),v1.FPlanFinishDate,120),'') as 'jhrq',
case when q.FDate is not null then convert(char(10),q.FDate,120) when r.FDate is not null then convert(char(10),r.FDate,120) else '' end  as 'dhrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',v1.FQty as 'fssl',isnull(b.FSecInv,0) as 'aqkc',isnull(s.FBillNo,'') as ddbh
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
LEFT JOIN (
select FICMOInterID,Min(a.FDate) as FDate from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID group by FICMOInterID
) j on j.FICMOInterID=v1.FInterID              --委外接收
LEFT JOIN SEOrder s on s.FInterID=v1.FOrderInterID
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FPlanFinishDate>=@begindate AND  v1.FPlanFinishDate<=@enddate
--AND v1.FPlanFinishDate>='2011-11-01' AND  v1.FPlanFinishDate<='2011-11-30'
AND v1.FStatus in (1,3)                     --状态必须是下达或结案
order by b.FSecInv,v1.FBillNo

if @status=0 
select count(*) from #Data
else if @status=1
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq<=jhrq) ) 
else
select count(*) from #Data where 1=1 AND ( (dhrq<>'' and dhrq>jhrq) or (dhrq='' and datediff(day,jhrq,getDate())>0) )   --未按时到货，包括：交期小于今天且未到货
end


execute list_scrwdcl '2013-10-01','2013-10-31',2

execute list_scrwdcl '2011-10-08','2011-10-31','2'

execute list_scrwdcl_count '2011-10-08','2011-10-31','2'



select FOrgSaleInterID,FOrgEntyrID from ICMrpResult where FBillNo='PL031184'

select * from SEOrder where FBillNo='SEORD004407'


select FPlanOrderInterID,FOrderInterID from ICMO where FBillNo like 'WORK019597'

select FOrgSaleInterID,FOrgEntyrID from ICMrpResult where FInterID=37652

select * from SEOrderEntry where FInterID=6429 and FEntryID=3 


