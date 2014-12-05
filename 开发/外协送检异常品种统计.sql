--drop procedure list_wxsjyc drop procedure list_wxsjyc_count

create procedure list_wxsjyc 
@begindate nvarchar(255),
@enddate nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldm nvarchar(20) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,sjsl decimal(28,2) default(0)      
,jysl decimal(28,2) default(0)      
)

Insert Into #temp(wldm,wlmc,wlgg,sjsl,jysl
)
select a.FNumber,a.FName,a.FModel,sum(c.FQty) as 'sjsl',sum(b.FQualifiedQty) as 'hgsl' 
FROM t_ICItem a 
INNER JOIN (select u1.FItemID,sum(u1.FInspRelQty) as 'FQualifiedQty' from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID where v1.FCheckDate>=@begindate and v1.FCheckDate<=@enddate group by u1.FItemID) b on a.FItemID=b.FItemID
INNER JOIN (select u1.FItemID,sum(w.FQty) as FQty from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID inner join rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID where v1.FCheckDate>=@begindate and v1.FCheckDate<=@enddate and w.jyfs='检验' group by u1.FItemID) c on a.FItemID=c.FItemID
WHERE 1=1
GROUP BY a.FNumber,a.FName,a.FModel

select * from #temp where sjsl<>jysl
end


---count-----

create procedure list_wxsjyc_count 
@begindate nvarchar(255),
@enddate nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
wldm nvarchar(20) default('')
,sjsl decimal(28,2) default(0)      
,hgsl decimal(28,2) default(0)      
)

Insert Into #temp(wldm,sjsl,hgsl
)
select a.FNumber,sum(c.FQty) as 'sjsl',sum(b.FQualifiedQty) as 'hgsl' 
FROM t_ICItem a 
INNER JOIN (select u1.FItemID,sum(u1.FInspRelQty) as 'FQualifiedQty' from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID where v1.FCheckDate>=@begindate and v1.FCheckDate<=@enddate group by u1.FItemID) b on a.FItemID=b.FItemID
INNER JOIN (select u1.FItemID,sum(w.FQty) as FQty from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID inner join rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID where v1.FCheckDate>=@begindate and v1.FCheckDate<=@enddate and w.jyfs='检验' group by u1.FItemID) c on a.FItemID=c.FItemID
WHERE 1=1
GROUP BY a.FNumber

select count(*) from #temp where sjsl<>hgsl
end




execute list_wxsjyc '2013-06-01','2013-06-30'




select * from ICShop_SubcOut a left join ICShop

select u1.FItemID,sum(w.FQty) as FQty from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID inner join rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID where v1.FCheckDate>='2013-05-01' and v1.FCheckDate<='2013-05-31'
and u1.FItemID=4007
 group by u1.FItemID

select * from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID where u1.FItemID=4007 and v1.FCheckDate>='2013-05-01' and FCheckDate<='2013-05-31'


select * from t_ICItem where FNumber='06.07.0091'


select * from ICShop_SubcOutEntry

select FQualityChkID from ICShop_FlowCardEntry

select * from rss.dbo.wwzc_wwjysqd 




select u1.FItemID,sum(u1.FInspRelQty) as 'FQualifiedQty',sum(w.FQty) as FQty          --
from ICShop_SubcOut v1 
inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID 
inner join rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID 
where v1.FCheckDate>='2013-06-01' and v1.FCheckDate<='2013-06-30' and w.jyfs='检验' and FItemID=3250
group by u1.FItemID


select v1.FBillNo,u1.FItemID,u1.FInspRelQty as 'FQualifiedQty',w.FQty as FQty 
from ICShop_SubcOut v1 
inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID 
inner join rss.dbo.wwzc_wwjysqd w on u1.FInterID=w.FSourceInterID and u1.FEntryID=w.FSourceEntryID 
where v1.FCheckDate>='2013-06-01' and v1.FCheckDate<='2013-06-30' and w.jyfs='检验' and FItemID=3250


select * from t_ICItem where FNumber = '05.02.2026'

select * from rss.dbo.wwzc_wwjysqd


select u1.* from ICShop_SubcOut v1 inner join ICShop_SubcOutEntry u1 on v1.FInterID=u1.FInterID where v1.FBillNo='wwzc002479'