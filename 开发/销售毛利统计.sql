--drop procedure report_xsml

create procedure report_xsml 
@begindate nvarchar(255),
@enddate nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,jldw nvarchar(20) default('')
,kpsl decimal(28,2) default(0)
,xssr decimal(28,2) default(0)
,cbdj decimal(28,2) default(0)
,xscb decimal(28,2) default(0)
)

Insert Into #temp(cpdm,cpmc,cpgg,jldw,kpsl,xssr,cbdj,xscb
)
select i.FNumber,i.FName,i.FModel,mu.FName,u1.FQty,case when v1.FTranType=86 then u1.FAmountincludetax else u1.FAmount end as 'xssr',c.FPrice as 'cbdj',c.FPrice*u1.FQty as 'xscb'--,mlr=u1.FAmount-(c.FPrice*u1.FQty),mll=(u1.FAmount-(c.FPrice*u1.FQty))/u1.FAmount*100
from ICSale v1 
INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN (select a.FInterID,b.FEntryID,b.FPrice from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID) c on u1.FSourceInterID=c.FInterID and u1.FSourceEntryID=c.FEntryID
where 1=1
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
--AND v1.FDate>='2012-07-01' AND  v1.FDate<='2012-07-31'
--AND (i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or i.FModel like '%'+@query+'%')
--AND (i.FNumber>=@wldm1 and i.FNumber<=@wldm2)
AND v1.FStatus = 1

create table #data(
cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,jldw nvarchar(20) default('')
,kpsl decimal(28,2) default(0)
,xssr decimal(28,2) default(0)
,xscb decimal(28,2) default(0)
,mlr decimal(28,2) default(0)
,mll nvarchar(20) default('')
)

Insert Into #data(cpdm,cpmc,cpgg,jldw,kpsl,xssr,xscb,mlr,mll
)
select cpdm,cpmc,cpgg,jldw,sum(kpsl) as 'kpsl',sum(xssr) as 'xssr',sum(xscb) as 'xscb',mlr=sum(xssr)-sum(xscb),mll=LTRIM(str((sum(xssr)-sum(xscb))/sum(xssr)*100)+'%') from #temp group by cpdm,cpmc,cpgg,jldw

select * from #data
union
select 'ºÏ¼Æ£º','','','',sum(kpsl),sum(xssr),sum(xscb),sum(mlr),mll=LTRIM(str((sum(xssr)-sum(xscb))/sum(xssr)*100)+'%') from #data
end


execute report_xsml '2012-07-01','2012-07-31'


select a.*,b.FAmount,b.* from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where FBillNo='XPP00000030' 86 FTranType FAmountincludetax

select a.*,b.FAmount,b.* from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where FBillNo='XZP00000507' 80

select str(10)+'%'

select FOrderBillNo,FItemID,max(FDate) as FDate,sum(FQty) as FQty from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID group by 
