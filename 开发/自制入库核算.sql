--drop procedure report_cz

create procedure report_cz 
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #data(
wldm nvarchar(255) default ''
,wlmc nvarchar(255) default ''
,wlgg nvarchar(255) default ''
,jldw nvarchar(255) default ''
,fssl nvarchar(255) default ''
,xsdj decimal(28,2) default 0
,xsje decimal(28,2) default 0
,hsdj decimal(28,2) default 0
,hsje decimal(28,2) default 0
)

create table #tmp(
       FDate nvarchar(10) null,
       FItemID nvarchar(255) null
)

insert into #tmp(FDate,FItemID
)
select Convert(char(10),max(v1.FDate),120) as FDate,u1.FItemID from ICSale v1 INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 group by u1.FItemID order by v1.FDate

Create table #tmpBill(
       FItemID int null,
       FQty decimal(28,10) null,
       FBatchNo varchar(255) null,
       FPrice decimal(28,10) null,
       FAmount money null )
  INSERT INTO #tmpBill(FItemID,FQty,FBatchNo,FPrice,FAmount) 
  SELECT t1.FItemID, sum(t1.FQty),Case WHEN t3.FTrack=80 Or t3.FTrack=20308 THEN   t1.FBatchNo ELSE '' END, 0, Sum(t1.FAmount) 
  FROM ICStockBillEntry t1,ICStockBill t2,t_ICItem t3 
  WHERE   t1.FInterID=t2.FInterID 
  AND t1.FItemID=t3.FItemID 
  AND t2.FTranType=2
  AND t2.FDate>=@begindate AND t2.FDate<=@enddate
--and t2.FDate>='2012-08-01' AND t2.FDate<='2012-08-31'
  AND t2.FCancellation=0 
  AND (t2.FVchInterID=0 or t2.FVchInterID is null) 
  AND t2.FStatus>0 
  AND (t2.FCheckerID>0 or t2.FCheckerID<0)

  Group By  t1.FItemID,Case WHEN t3.FTrack=80 or t3.FTrack=20308 THEN   t1.FBatchNo ELSE '' END 
Update #tmpBill SET FPrice=FAmount/FQty WHERE FQty<>0

Insert Into #data(wldm,wlmc,wlgg,jldw,fssl,xsdj,xsje,hsdj,hsje
)
SELECT t2.FNumber,t2.FName,t2.FModel,t3.FName as FUnitName,t1.FQty,b.FPrice,t1.FQty*b.FPrice as 'je' ,round(t1.FPrice,t2.FPriceDecimal) as FPrice,t1.FAmount
 /*,t1.FBatchNo,t1.FQty/t5.FCoefficient AS FCUQty,round(convert(decimal(28,14),t1.FPrice)*convert(decimal(28,14),t5.FCoefficient),t2.FPriceDecimal) as FCUPrice,
 round(t2.FPlanPrice,t2.FPriceDecimal) as FPPrice ,Round(t2.FPlanPrice*t1.FQty,2) as FPAmount, 
 round(convert(decimal(28,14),t2.FPlanPrice)*convert(decimal(28,14),t5.FCoefficient),t2.FPriceDecimal) as FPCUPrice, 
 Round(t1.FAmount-t2.FPlanPrice*t1.FQty,2) as FDiff,t2.FShortNumber,t5.FUnitGroupID, 
 t2.FQtyDecimal,t2.FPriceDecimal,t5.FName as FCUUnitName,t5.FCoefficient*/
FROM #tmpBill t1
LEFT JOIN t_ICItem t2 on t1.FItemID = t2.FItemID and t2.FTrack <> 81 
LEFT JOIN t_MeasureUnit t3 on t2.FUnitID = t3.FItemID
LEFT JOIN t_MeasureUnit t5  on t2.FStoreUnitID=t5.FItemID
LEFT JOIN (select u1.FItemID,min(u1.FPrice) as FPrice,min(FTaxPrice) as FTaxPrice from ICSale v1 INNER JOIN ICSaleEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 INNER JOIN #tmp t on v1.FDate=t.FDate and u1.FItemID=t.FItemID group by u1.FItemID) b on t1.FItemID=b.FItemID
Order by  t2.FNumber

Insert into #data(wldm,xsje,hsje
)
select 'ºÏ¼Æ',sum(xsje),sum(hsje) from #data

select * from #data

end

execute report_cz '2012-06-01','2012-06-30'

