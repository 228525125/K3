
select left(convert(char(10),v1.FDate,120),7),t4.FName as 'wldw',i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',i.FHelpCode as 'cpth',mu.FName as 'jldw',
u1.FQty as 'fssl',
u1.FConsignPrice/1.17 as 'wsdj',
u1.FConsignPrice as 'hsdj',
u1.FConsignAmount*0.17 as 'xxs',
u1.FConsignAmount as 'hsje', 
cast(ISNULL(ic.FTaxPrice,0) as decimal(28,2)) as 'fphsdj', 
case when ic.FTaxPrice is null then u1.FConsignAmount else u1.FQty*ISNULL(ic.FTaxPrice,0) end as 'fphsje'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN ICSaleEntry ic ON u1.FInterID=ic.FSourceInterID AND u1.FEntryID=ic.FSourceEntryID
LEFT JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2014-01-01' AND  v1.FDate<='2014-05-31'
--and ic.FTaxPrice is null and (u1.FConsignAmount is null or u1.FConsignAmount=0)





select left(convert(char(10),v1.FDate,120),7) as '月份',
sum(case when ic.FTaxPrice is null then u1.FConsignAmount else u1.FQty*ISNULL(ic.FTaxPrice,0) end) as '含税金额合计'
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN ICSaleEntry ic ON u1.FInterID=ic.FSourceInterID AND u1.FEntryID=ic.FSourceEntryID
LEFT JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
LEFT JOIN t_user us On us.FUserID=v1.FBillerID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2011-07-01' AND  v1.FDate<='2012-10-31'
group by left(convert(char(10),v1.FDate,120),7)
order by left(convert(char(10),v1.FDate,120),7)



select left(convert(char(10),v1.FDate,120),7),sum(u1.FQty) from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2014-01-01' AND  v1.FDate<='2014-05-31'
AND i.FName like '%阀%'
and t4.FNumber='01.001'
group by left(convert(char(10),v1.FDate,120),7)



select left(convert(char(10),v1.FDate,120),7),v1.FBillNo,t4.FName,i.FNumber,u1.FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization t4 ON v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0
where 1=1 
AND v1.FStatus>=1
AND (v1.FTranType=21 AND (v1.FCancellation = 0))
AND v1.FDate>='2014-01-01' AND  v1.FDate<='2014-01-31'
AND i.FName like '%阀%'





select FSourceInterId,FSourceEntryId,u1.* from ICSale v1 INNER JOIN ICSaleEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo='XZP00000243' and u1.FQty=64

