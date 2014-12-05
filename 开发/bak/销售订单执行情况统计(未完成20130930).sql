
create procedure list_ddzxqktj 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #data(            
khdm nvarchar(255) default('')      
,khmc nvarchar(255) default('')     
,ddnm nvarchar(255) default('')    
,ddfl nvarchar(255) default('')   
,ddje decimal(28,2) default(0)          
,dfhje decimal(28,2) default(0)          
,fhje decimal(28,2) default(0)          
,dkpje decimal(28,2) default(0)  
,kpje decimal(28,2) default(0)   
,dskje decimal(28,2) default(0)           
,skje decimal(28,2) default(0)          
)

Insert Into #data(khdm,khmc,ddnm,ddfl,ddje,dfhje,fhje,dkpje,kpje,dskje,skje
)
SELECT a.FNumber --客户代码
,a.FName   --客户名称
,b.FInterID   --订单内码
,b.FEntryID   
,ddje=b.FAllAmount                            --税价合计
,dfhje=b.FAllAmount - b.FStockQty*b.FTaxPrice --待发货金额 
,fhje=b.FStockQty*b.FTaxPrice                 --发货金额
,dkpje=b.FStockQty*b.FTaxPrice-d.FStdAmountincludetax   --未开票=发货金额-开票金额
,kpje=d.FStdAmountincludetax                  --开票金额
,dskje=(d.FQty-d.FAllHookAmount)*d.FTaxPrice    --未收款金额
,skje=d.FStdAmountincludetax                  --收款金额
FROM t_Organization a 
LEFT JOIN (
	select a.FCustID,a.FInterID,b.FEntryID,SUM(FAllAmount) as FAllAmount,MIN(FTaxPrice) as FTaxPrice   
	from SEOrder a 
	left join SEOrderEntry b on a.FInterID=b.FInterID 
	where a.FCancellation=0 and a.FStatus=1 
	and a.FDate>=@begindate and a.FDate<=@enddate
	group by a.FCustID,left(convert(char(10),a.FDate,120),7) 
) b on a.FItemID=b.FCustID 
LEFT JOIN (
	select left(convert(char(10),a.FDate,120),7),SUM(FQty) as FQty
	from ICStockBill a 
	left join ICStockBillEntry b on a.FInterID=b.FInterID 
	where a.FTranType=21
	and a.FDate>='2013-09-01' and a.FDate<='2013-09-30'
	group by FSupplyID,left(convert(char(10),a.FDate,120),7)
) c on 
LEFT JOIN (
	select b.FOrderInterID,b.FOrderEntryID,SUM(b.FStdAmountincludetax) as FStdAmountincludetax,SUM(FQty) as FQty,SUM(FAllHookAmount) as FAllHookAmount,SUM(FTaxPrice) as FTaxPrice
	from ICSale a 
	left join ICSaleEntry b on a.FInterID=b.FInterID 
	where a.FStatus=1
	group by b.FOrderInterID,b.FOrderEntryID
) d on b.FInterID=d.FOrderInterID and b. FEntryID=d.FOrderEntryID
WHERE 1=1

SELECT khdm,khmc,SUM(ddje),SUM(dfhje),SUM(fhje),SUM(dkpje),SUM(kpje),SUM(dskje),SUM(skje) FROM #data group by khdm,khmc



select FCustID,* from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where FBillNo='SEORD006052'

select * from t_Organization where FItemID=9957


select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=21 and a.FBillNo='XOUT006489'

select FOrderInterID,FStdAmountincludetax,FStdAllHookAmount,FCheckQty,b.* from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where a.FBillNo in ('XZP00000733','XZP00000853')