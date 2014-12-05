--drop procedure list_wkp 

create procedure list_wkp 
@begindate varchar(10),
@enddate varchar(10),
@query varchar(50)
as 
begin
SET NOCOUNT ON 
SET ANSI_WARNINGS OFF 

DECLARE @year int
DECLARE @month int

set @year = left(@begindate,4)
set @month = right(left(@begindate,7),2)

Create Table #Rpt110(FItemID int,FCustID int,FInterID int,FEntryID int,
     FDate Datetime,FTranType int,
     FVoucherNo Varchar(355),FBillNo Varchar(355),FNote Varchar(355),
     FSendQty     decimal(28,10)  not null default(0),
     FSendPrice   decimal(28,10)  not null default(0),
     FSendAmount  decimal(28,10)  not null default(0),
     FVerifQty     decimal(28,10)  not null default(0),
     FVerifPrice   decimal(28,10)  not null default(0),
     FVerifAmount  decimal(28,10)  not null default(0),
     FEndQty     decimal(28,10)  not null default(0),
     FEndPrice   decimal(28,10)  not null default(0),
     FEndAmount  decimal(28,10)  not null default(0),
     FQtyDecimal int Null, 
     FPriceDecimal int Null, 
     FSumSort    smallint ,
     FOrganizationID int Null ,
     FOrganizationName  Varchar(355) Null ,
     FProductNo Varchar(355) Null,
     FProductName Varchar(355) Null,
     FModel Varchar(355) Null ,
     FAuxPropName VarChar(355) Null ) 
 Insert Into #Rpt110(FItemID,FCustID,FInterID,
 
FEntryID,FDate,FVoucherNo,FBillNo,FNote,FTranType,FEndQty,FEndPrice,FEndAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
 SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
 v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  
FROM  t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), u1.FBillNo,'期初余额',u1.FTranType,
 v1.FQty-v1.FAllHookQty+isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>=@month) OR FYear>left(@begindate,4))),0),
 v1.FPrice,v1.FAmount * ((v1.FQty-v1.FAllHookQty+isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and 
v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>=@month) OR FYear>left(@begindate,4))),0)) / CAST(v1.FQty AS FLOAT)) ,
 t2.FItemID,t2.FName,t5.FNumber,t5.FName ,t5.FModel,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
 on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate <@begindate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo Insert Into #Rpt110(FItemID,FCustID,FInterID,FEntryID,
FDate,FVoucherNo,FBillNo,FNote,FTranType,FSendQty,FSendPrice,FSendAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  FROM  
t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), 
u1.FBillNo,u1.FExplanation,u1.FTranType,v1.FQty,v1.FPrice,v1.FAmount,t2.FItemID,t2.FName ,t5.FNumber,t5.FName ,t5.FModel,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID 
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate >=@begindate
 AND u1.FDate <=@enddate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo Insert Into #Rpt110(FItemID,FCustID,FInterID,FEntryID,FDate,FVoucherNo,
FBillNo,FNote,FTranType,FVerifQty,FVerifPrice,FVerifAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  FROM  
t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), u1.FBillNo,u1.FExplanation,u1.FTranType,isnull((select sum(FHookQty) from 
ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND FYear=@year AND FPeriod=@month),0)  ,v1.FPrice,v1.FAmount * (
isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND FYear=@year AND FPeriod=@month),0) / CAST(v1.FQty AS FLOAT)) ,t2.FItemID,t2.FName,t5.FNumber,t5.FName 
,t5.FModel ,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate <=@enddate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo Insert Into #Rpt110(FItemID,FCustID,FInterID,FEntryID,FDate,FVoucherNo,
FBillNo,FNote,FTranType,FEndQty,FEndPrice,FEndAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  FROM  
t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), u1.FBillNo,'期末结存',u1.FTranType,v1.FQty-v1.FAllHookQty+isnull((select 
sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>@month) OR FYear>left(@begindate,4))),0),v1.FPrice,v1.FAmount * 
((v1.FQty-v1.FAllHookQty+isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>@month) OR FYear>left(@begindate,4))),0)) / CAST(v1.FQty AS FLOAT)),t2.FItemID,t2.FName 
,t5.FNumber,t5.FName,t5.FModel ,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate <=@enddate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo
Delete #Rpt110  where FEndQty=0 AND FSendQty=0 AND FVerifQty=0   
 update a set a.FQtyDecimal=b.FQtyDecimal, a.FPriceDecimal=b.FPriceDecimal FROM #rpt110 a  inner join t_ICItem b 
on(a.FItemID=b.FItemID)


update #rpt110 set FNote='本期发出' where FNote='' and FSendQty<>0
update #rpt110 set FNote='本期勾稽' where FNote='' and FVerifQty<>0

--select * from #rpt110

select convert(char(4),@year)+'.'+convert(char(4),@month) as '会计期间', a.FNumber,a.FName,sum(case when b.FNote='期初余额' then b.FAmount else 0 end) as '期初余额', sum(case when b.FNote='本期发出' then b.FAmount else 0 end) as '本期发出', sum(case when b.FNote='本期勾稽' then b.FAmount else 0 end) as '本期勾稽', sum(case when b.FNote='期末结存' then b.FAmount else 0 end) as '期末结存'
from t_Organization a
left join (
	select a.FCustID,a.FNote,sum(b.FConsignAmount) as FAmount 
	from #rpt110 a
	left join (
		select v1.FBillNo,u1.FEntryID,u1.FConsignAmount from ICStockBill v1 left join ICStockBillEntry u1 on u1.FInterID=v1.FInterID 
	) b on a.FBillNo=b.FBillNo and a.FEntryID=b.FEntryID
	group by a.FCustID,a.FNote
) b on a.FItemID=b.FCustID
where a.FNumber like '%'+@query+'%'
group by a.FNumber,a.FName
order by a.FNumber

end


execute list_wkp '2014-01-01', '2014-01-31','' 


------明细------
--drop procedure list_wkp_mx

create procedure list_wkp_mx 
@begindate varchar(10),
@enddate varchar(10),
@query varchar(50)
as 
begin
SET NOCOUNT ON 
SET ANSI_WARNINGS OFF 

DECLARE @year int
DECLARE @month int

set @year = left(@begindate,4)
set @month = right(left(@begindate,7),2)

Create Table #Rpt110(FItemID int,FCustID int,FInterID int,FEntryID int,
     FDate Datetime,FTranType int,
     FVoucherNo Varchar(355),FBillNo Varchar(355),FNote Varchar(355),
     FSendQty     decimal(28,10)  not null default(0),
     FSendPrice   decimal(28,10)  not null default(0),
     FSendAmount  decimal(28,10)  not null default(0),
     FVerifQty     decimal(28,10)  not null default(0),
     FVerifPrice   decimal(28,10)  not null default(0),
     FVerifAmount  decimal(28,10)  not null default(0),
     FEndQty     decimal(28,10)  not null default(0),
     FEndPrice   decimal(28,10)  not null default(0),
     FEndAmount  decimal(28,10)  not null default(0),
     FQtyDecimal int Null, 
     FPriceDecimal int Null, 
     FSumSort    smallint ,
     FOrganizationID int Null ,
     FOrganizationName  Varchar(355) Null ,
     FProductNo Varchar(355) Null,
     FProductName Varchar(355) Null,
     FModel Varchar(355) Null ,
     FAuxPropName VarChar(355) Null ) 
 Insert Into #Rpt110(FItemID,FCustID,FInterID,
 FEntryID,FDate,FVoucherNo,FBillNo,FNote,FTranType,FEndQty,FEndPrice,FEndAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
 SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
 v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  
FROM  t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), u1.FBillNo,'期初余额',u1.FTranType,
 v1.FQty-v1.FAllHookQty+isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>=@month) OR FYear>left(@begindate,4))),0),
 v1.FPrice,v1.FAmount * ((v1.FQty-v1.FAllHookQty+isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and 
v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>=@month) OR FYear>left(@begindate,4))),0)) / CAST(v1.FQty AS FLOAT)) ,
 t2.FItemID,t2.FName,t5.FNumber,t5.FName ,t5.FModel,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
 on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate <@begindate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo Insert Into #Rpt110(FItemID,FCustID,FInterID,FEntryID,
FDate,FVoucherNo,FBillNo,FNote,FTranType,FSendQty,FSendPrice,FSendAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  FROM  
t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), 
u1.FBillNo,u1.FExplanation,u1.FTranType,v1.FQty,v1.FPrice,v1.FAmount,t2.FItemID,t2.FName ,t5.FNumber,t5.FName ,t5.FModel,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID 
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate >=@begindate
 AND u1.FDate <=@enddate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo Insert Into #Rpt110(FItemID,FCustID,FInterID,FEntryID,FDate,FVoucherNo,
FBillNo,FNote,FTranType,FVerifQty,FVerifPrice,FVerifAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  FROM  
t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), u1.FBillNo,u1.FExplanation,u1.FTranType,isnull((select sum(FHookQty) from 
ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND FYear=@year AND FPeriod=@month),0)  ,v1.FPrice,v1.FAmount * (
isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND FYear=@year AND FPeriod=@month),0) / CAST(v1.FQty AS FLOAT)) ,t2.FItemID,t2.FName,t5.FNumber,t5.FName 
,t5.FModel ,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate <=@enddate
 AND u1.FStatus>0 And u1.FCancelLation=0 
  AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo Insert Into #Rpt110(FItemID,FCustID,FInterID,FEntryID,FDate,FVoucherNo,
FBillNo,FNote,FTranType,FEndQty,FEndPrice,FEndAmount,FOrganizationID,FOrganizationName,FProductNo,FProductName,FModel,FAuxPropName)
SELECT v1.FItemID,u1.FSupplyID,v1.FInterID,
v1.FEntryID,u1.FDate,(SELECT (SELECT FName FROM t_VoucherGroup WHERE  FGroupID=t4.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)  FROM  
t_Voucher t4 WHERE  t4.FVoucherid=u1.FVchInterID), u1.FBillNo,'期末结存',u1.FTranType,v1.FQty-v1.FAllHookQty+isnull((select 
sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>@month) OR FYear>left(@begindate,4))),0),v1.FPrice,v1.FAmount * 
((v1.FQty-v1.FAllHookQty+isnull((select sum(FHookQty) from ICHookRelations where u1.FInterID=FIBInterID and v1.FEntryID=FEntryID 
 and FHookType=1 AND FIBTag=1  AND ((FYear=@year AND FPeriod>@month) OR FYear>left(@begindate,4))),0)) / CAST(v1.FQty AS FLOAT)),t2.FItemID,t2.FName 
,t5.FNumber,t5.FName,t5.FModel ,t9.FName
 from  ICStockBill u1 inner join ICStockBillEntry v1 
on u1.FInterID=v1.FInterID 
 inner join t_Organization t2 on t2.FItemID=u1.FSupplyID
 inner join t_Emp t3 on t3.FItemID=u1.FFManagerID
 inner join t_stock t4 on t4.FItemID=v1.FDCStockID
 inner join t_ICItem t5 on v1.FItemID=t5.FItemID
 Left  Join t_AuxItem t9 on v1.FAuxPropID=t9.FItemID 

 Where  u1.FTranType=21 AND u1.FSaleStyle=102 
 AND u1.FDate <=@enddate
 AND u1.FStatus>0 And u1.FCancelLation=0 
 AND  t2.FNumber like '%'+@query+'%'

 Order by u1.FDate,u1.FBillNo
Delete #Rpt110  where FEndQty=0 AND FSendQty=0 AND FVerifQty=0   
 update a set a.FQtyDecimal=b.FQtyDecimal, a.FPriceDecimal=b.FPriceDecimal FROM #rpt110 a  inner join t_ICItem b 
on(a.FItemID=b.FItemID)


update #rpt110 set FNote='本期发出' where FNote='' and FSendQty<>0
update #rpt110 set FNote='本期勾稽' where FNote='' and FVerifQty<>0

select convert(char(4),@year)+'.'+convert(char(4),@month) as '会计期间',a.*,t2.FNumber,b.FConsignAmount 
from #rpt110 a
left join (
	select v1.FBillNo,u1.FEntryID,u1.FConsignAmount from ICStockBill v1 left join ICStockBillEntry u1 on u1.FInterID=v1.FInterID 
) b on a.FBillNo=b.FBillNo and a.FEntryID=b.FEntryID 
left join t_Organization t2 on t2.FItemID=a.FOrganizationID
where t2.FNumber like '%'+@query+'%'

--select * from #rpt110

end


execute list_wkp '2013-12-01', '2013-12-31','01.001'

execute list_wkp_mx '2013-12-01', '2013-12-31','01.001'



select * from t_Voucher

