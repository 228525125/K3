
select Convert(char(10),v1.Fdate,111) as Fdate,
v1.FBillNo as FBillNo,t4.FNumber as 'dwdm',t4.FName as 'wldw',
us.FDescription as 'ywy',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',u1.FQty as 'fssl',i.FNumber as 'cpdm',u1.FBatchNo as 'cpph',
c1.FQty as 'kpsl',isnull(s1.FPriceDiscount,0) as 'hsdj',isnull(s1.FPriceDiscount,0)*u1.FQty as 'hsje'
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
LEFT JOIN (
select b.FSourceInterID,b.FSourceEntryID,sum(b.FQty) as FQty 
from ICSale a 
inner join ICSaleEntry b on a.FInterID=b.FInterID and b.FInterID <>0 
where a.FTranType=80 and a.FCancellation = 0
group by FSourceInterID,FSourceEntryID
) c1 ON u1.FInterID=c1.FSourceInterID and u1.FEntryID=c1.FSourceEntryID
LEFT JOIN SEOrderEntry s1 on s1.FInterID=u1.FOrderInterID and s1.FEntryID=u1.FOrderEntryID
where 1=1 
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2013-01-01' AND  v1.FDate<='2013-06-30'
AND v1.FStatus > 0
AND t4.FNumber = '01.001'
AND c1.FQty is null
order by v1.FBillNo,u1.FItemID








--------发货金额---------

select t4.FNumber,
sum(u1.FConsignAmount) as 'hsje'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2013-12-01' AND  v1.FDate<='2013-12-31'
group by t4.FNumber
order by t4.FName

------------本期收款-------------

select b.FName,sum(a.FAmount) from t_RP_NewReceiveBill a 
left join t_Organization b on a.FCustomer=b.FItemID
where a.FNumber like 'XSKD%' and a.FDate>='2013-12-01' and a.FDate<='2013-12-31'
group by b.FName


----------期末余额--------
select a.FName,a.FNumber,b.ckje,c.skje 
from t_Organization a 
left join (
	select t4.FName, 
	sum(u1.FConsignAmount) as 'ckje'
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
	where 1=1 
	AND v1.FStatus>=1
	AND (v1.FTranType=21 AND (v1.FCancellation = 0))
	AND  v1.FDate<='2013-12-31'
	group by t4.FName
) b on a.FName=b.FName
left join (
	select b.FName,sum(a.FAmount) as 'skje'  from t_RP_NewReceiveBill a 
	left join t_Organization b on a.FCustomer=b.FItemID
	where a.FNumber like 'XSKD%' and a.FDate<='2013-12-31'
	group by b.FName	
) c on a.FName = c.FName



--drop procedure list_ysk

create procedure list_ysk 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FNumber nvarchar(255) default('')
,FName nvarchar(255) default('')
,qc decimal(28,2) default(0)
,bqys decimal(28,2) default(0)
,bqyishou decimal(28,2) default(0)
,qm decimal(28,2) default(0)
)

Insert Into #temp(FNumber,FName,qc,bqys,bqyishou,qm
)
select a.FNumber,a.FName,isnull(b.hsje,0) as '期初未开票'  ,isnull(c.hsje,0) as '本期发货',isnull(d.hsje,0) as '本期开票',isnull(b.hsje,0) + isnull(c.hsje,0) - isnull(d.hsje,0) as '期末未开票'
from t_Organization a 
left join (
	select t4.FNumber,
	sum(u1.FConsignAmount) as 'hsje'
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
	where 1=1 
	AND v1.FStatus>=1
	AND (v1.FTranType=21 AND (v1.FCancellation = 0))
	AND v1.FDate<=@begindate
	AND v1.FHookStatus=0
	group by t4.FNumber
) b on b.FNumber=a.FNumber
left join (
	select t4.FNumber,
	sum(u1.FConsignAmount) as 'hsje'
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
	where 1=1 
	AND v1.FStatus>=1
	AND (v1.FTranType=21 AND (v1.FCancellation = 0))
	AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
	group by t4.FNumber
) c on a.FNumber = c.FNumber
left join (
	select t4.FNumber,
	sum(u1.FConsignAmount) as 'hsje'
	from ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
	LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
	where 1=1 
	AND v1.FStatus>=1
	AND (v1.FTranType=21 AND (v1.FCancellation = 0))
	AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
	AND v1.FHookStatus=2
	group by t4.FNumber
) d on a.FNumber = d.FNumber
where 1=1
and a.FNumber like '%'+@query+'%'
order by a.FNumber

select FNumber as '客户代码',FName as '客户名称', qc as '期初未开票', bqys as '本期发货', bqyishou as '本期开票', qm as '期末未开票' from #temp
end



exec list_ysk '','2013-12-01','2013-12-31'


select * from 


select t4.FNumber,t4.FName,
sum(u1.FConsignAmount) as 'hsje'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate<='2013-12-31'
AND v1.FHookStatus=0
group by t4.FNumber,t4.FName
order by t4.FNumber



select v1.FHookStatus from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2013-12-01' AND  v1.FDate<='2013-12-31'
AND v1.FHookStatus=0
