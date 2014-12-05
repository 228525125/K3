--销售月报表
--drop procedure list_xsybb

create procedure list_xsybb 
@begindate varchar(255),
@enddate varchar(255),
@query varchar(255)
as 
begin
SET NOCOUNT ON 
/*DECLARE @begindate nvarchar(255)
DECLARE @enddate nvarchar(255)

set @begindate=left(@date,4)+'-'+right(@date,2)+'-01'

set @enddate=case 
when right(@date,2)='01' then left(@date,4)+'-01-31'
when right(@date,2)='02' and @date='201202' then left(@date,4)+'-02-29'
when right(@date,2)='02' and @date='201216' then left(@date,4)+'-02-29'
when right(@date,2)='02' and @date<>'201202' and @date<>'201602' then left(@date,4)+'-02-28'
when right(@date,2)='03' then left(@date,4)+'-03-31'
when right(@date,2)='04' then left(@date,4)+'-04-30'
when right(@date,2)='05' then left(@date,4)+'-05-31'
when right(@date,2)='06' then left(@date,4)+'-06-30'
when right(@date,2)='07' then left(@date,4)+'-07-31'
when right(@date,2)='08' then left(@date,4)+'-08-31'
when right(@date,2)='09' then left(@date,4)+'-09-30'
when right(@date,2)='10' then left(@date,4)+'-10-31'
when right(@date,2)='11' then left(@date,4)+'-11-30'
when right(@date,2)='12' then left(@date,4)+'-12-31'
end*/

create table #data(            
khdm nvarchar(255) default('')      
,khmc nvarchar(255) default('')       
,ddje decimal(28,2) default(0)          
,dfhje decimal(28,2) default(0)          
,fhje decimal(28,2) default(0)          
,dkpje decimal(28,2) default(0)  
,kpje decimal(28,2) default(0)   
,dskje decimal(28,2) default(0)           
,skje decimal(28,2) default(0)          
)

Insert Into #data(khdm,khmc,ddje,dfhje,fhje,dkpje,kpje,dskje,skje
)
SELECT a.FNumber --客户代码
,a.FName   --客户名称
,ddje=ISNULL(b.FAllAmount,0)                 --税价合计
,dfhje=ISNULL(e.FAllAmount,0)                --待发货金额 
,fhje=ISNULL(c.FAllAmount,0)                 --发货金额
,dkpje=ISNULL(f.FAllAmount,0)                --未开票=发货金额-开票金额
,kpje=ISNULL(d.FStdAmountincludetax,0)       --开票金额
,dskje=ISNULL(g.FAllAmount,0)                --未收款金额
,skje=ISNULL(d.FAllHookAmount,0)             --收款金额
FROM t_Organization a 
LEFT JOIN (                        --订单金额
	select a.FCustID,SUM(FAllAmount) as FAllAmount   
	from SEOrder a 
	left join SEOrderEntry b on a.FInterID=b.FInterID 
	where a.FCancellation=0 
	and a.FCheckerID>0
	and a.FDate>=@begindate and a.FDate<=@enddate
	group by a.FCustID
) b on a.FItemID=b.FCustID 
LEFT JOIN (                 --发货金额
	select a.FSupplyID,SUM(b.FQty*c.FTaxPrice) as FAllAmount
	from ICStockBill a 
	left join ICStockBillEntry b on a.FInterID=b.FInterID 
	left join SEOrderEntry c on b.FOrderInterID=c.FInterID and b.FOrderEntryID=c.FEntryID
	where a.FTranType=21
	and a.FCheckerID>0
	and a.FDate>=@begindate and a.FDate<=@enddate
	group by a.FSupplyID
) c on a.FItemID=c.FSupplyID
LEFT JOIN (                 --发票金额                     含税金额       
	select a.FCustID,SUM(b.FStdAmountincludetax) as FStdAmountincludetax,SUM(FAllHookQty*FTaxPrice) as FAllHookAmount
	from ICSale a 
	left join ICSaleEntry b on a.FInterID=b.FInterID 
	where a.FCheckerID>0
	and a.FDate>=@begindate and a.FDate<=@enddate
	group by a.FCustID
) d on d.FCustID=a.FItemID
LEFT JOIN (            --未发货金额（时点数）                                  
	select a.FCustID,SUM((b.FQty-b.FAuxStockQty)*b.FTaxPrice) as FAllAmount    --未发货金额=订单金额-发货金额
	from SEOrder a 
	left join SEOrderEntry b on a.FInterID=b.FInterID 
	where a.FCancellation=0 
	and a.FClosed=0 and b.FMrpClosed=0
	and a.FCheckerID>0
	and a.FDate<=@enddate
	and a.FDate>='2012-01-01'
	group by a.FCustID
) e on e.FCustID=a.FItemID
LEFT JOIN (            --未开票金额（时点数）                                 
	select a.FSupplyID,SUM((b.FQty-b.FQtyInvoice)*c.FTaxPrice) as FAllAmount
	from ICStockBill a 
	left join ICStockBillEntry b on a.FInterID=b.FInterID 
	left join SEOrderEntry c on b.FOrderInterID=c.FInterID and b.FOrderEntryID=c.FEntryID
	where a.FTranType=21
	and a.FCheckerID>0
	and a.FDate<=@enddate
	and a.FDate>='2012-01-01'
	group by a.FSupplyID
) f on f.FSupplyID=a.FItemID
LEFT JOIN (            --未收款金额（时点数）                                         核销含税金额              
	select a.FCustID,SUM((b.FQty-b.FAllHookQty)*b.FTaxPrice) as FAllAmount
	from ICSale a 
	left join ICSaleEntry b on a.FInterID=b.FInterID 
	where a.FCheckerID>0
	and a.FDate<=@enddate
	and a.FDate>='2012-01-01'
	group by a.FCustID
) g on g.FCustID=a.FItemID
WHERE 1=1
AND (a.FNumber like '%'+@query+'%' or a.FName like '%'+@query+'%')

select * from #data
end


exec list_xsybb '201309','01.001'




SELECT khdm,khmc,SUM(ddje),SUM(dfhje),SUM(fhje),SUM(dkpje),SUM(kpje),SUM(dskje),SUM(skje) FROM #data group by khdm,khmc



select FCustID,* from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where FBillNo='SEORD005876'

select * from t_Organization where FItemID=9957


select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=21 and a.FBillNo='XOUT006489'

select FSourceInterID,FSourceEntryID,FOrderInterID,FStdAmountincludetax,FStdAllHookAmount,FQty,* from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where a.FBillNo in ('XZP00000733','XZP00000853')

,left(convert(char(10),a.FDate,120),7)



select a.FSupplyID,a.FBillNo,b.FEntryID,b.FQty,b.FQtyInvoice--,SUM((b.FQty-b.FQtyInvoice)*c.FTaxPrice) as FAllAmount
	from ICStockBill a 
	left join ICStockBillEntry b on a.FInterID=b.FInterID 
	left join SEOrderEntry c on b.FOrderInterID=c.FInterID and b.FOrderEntryID=c.FEntryID
	where a.FTranType=21
	and a.FCheckerID>0
	and a.FDate<='2013-09-30'
	and a.FSupplyID=127
	group by a.FSupplyID




XOUT003972
XOUT000806

select b.FInterID,b.FEntryID,b.FQty,b.FQtyInvoice,* from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID  where a.FBillNo='XOUT000165'

select FStdAmountincludetax,FStdAllHookAmount,FQty,* from ICSale a left join ICSaleEntry b on a.FInterID=b.FInterID where b.FSourceInterID=6589 and b.FSourceEntryID=2