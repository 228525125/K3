--drop procedure list_jcwz drop procedure list_jcwz_count

create procedure list_jcwz
@query varchar(50)
as 
begin
SET NOCOUNT ON 
create table #temp(
jyr nvarchar(20) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,fssl decimal(28,2) default(0)
,jyrq nvarchar(255) default('')
,ghrq nvarchar(255) default('')
)

Insert Into #temp(jyr,wldm,wlmc,wlgg,fssl,jyrq,ghrq)
select e.FName,i.FNumber,i.FName,i.FModel,sum(case when u1.FSCStockID=9366 then u1.FQty-(u1.FQty*2) else u1.FQty end) as FQty,convert(char(10),MAX(v1.FDate),120) as FDate, convert(char(10),MAX(u1.FKFDate),120) as FKFDate
from ICStockBill v1 
LEFT JOIN ICStockBillEntry u1 on v1.FInterID=u1.FInterID 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
INNER JOIN t_emp e on e.FItemID=v1.FEmpID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN t_stock s1 on u1.FSCStockID=s1.FItemID
LEFT JOIN t_stock s2 on u1.FDCStockID=s2.FItemID
where v1.FTranType=41
and FCheckerID is not null
and FDate>='2012-05-01'
AND (e.FName like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%')
AND (u1.FSCStockID=9366 or u1.FDCStockID=9366)
group by e.FName,i.FNumber,i.FName,i.FModel
order by e.FName,i.FNumber,i.FName,i.FModel

select * from #temp where fssl<>0
end

------count-------
create procedure list_jcwz_count
@query varchar(50)
as 
begin
SET NOCOUNT ON 
create table #temp(
jyr nvarchar(20) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,fssl decimal(28,2) default(0)
)

Insert Into #temp(jyr,wldm,wlmc,wlgg,fssl)
select e.FName,i.FNumber,i.FName,i.FModel,sum(case when u1.FSCStockID=9366 then u1.FQty-(u1.FQty*2) else u1.FQty end) as FQty 
from ICStockBill v1 
LEFT JOIN ICStockBillEntry u1 on v1.FInterID=u1.FInterID 
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
INNER JOIN t_emp e on e.FItemID=v1.FEmpID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN t_stock s1 on u1.FSCStockID=s1.FItemID
LEFT JOIN t_stock s2 on u1.FDCStockID=s2.FItemID
where v1.FTranType=41
and FCheckerID is not null
and FDate>='2012-05-01'
AND (u1.FSCStockID=9366 or u1.FDCStockID=9366)
AND (e.FName like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' 
or i.FModel like '%'+@query+'%')
group by e.FName,i.FNumber,i.FName,i.FModel
order by e.FName,i.FNumber,i.FName,i.FModel

select count(*) from #temp where fssl<>0
end

execute list_jcwz ''


select u1.* from ICStockBill v1 
LEFT JOIN ICStockBillEntry u1 on v1.FInterID=u1.FInterID 
where v1.FTranType=41

select * from t_stock where FItemID=9366
