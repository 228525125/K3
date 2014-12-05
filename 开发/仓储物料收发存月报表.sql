--drop procedure report_clsfchzb

create procedure report_clsfchzb
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@beginnumber nvarchar(255),
@endnumber nvarchar(255)
as 
begin 
Set NoCount On  SET NOCOUNT ON
 CREATE TABLE #Happen(
        FStockid  int Null, 
        FItemID int Null, 
        FQtyDecimal int Null, 
        FPriceDecimal int Null, 
        FBatchNo Varchar(355),
        FBegQty decimal(28,10),
        FBegBal decimal(28,10),
        FBegDiff decimal(28,10),
        FInQty1  decimal(28,10),
	FInQty2  decimal(28,10),
	FInQty3  decimal(28,10),
	FInQty4  decimal(28,10),
        FInAmount decimal(28,10),
        FInDiff decimal(28,10),
        FOutQty1 decimal(28,10),
	FOutQty2 decimal(28,10),
	FOutQty3 decimal(28,10),
	FOutQty4 decimal(28,10),
        FOutAmount decimal(28,10),
        FOutDiff decimal(28,10))
  INSERT INTO #Happen(FStockid,FItemID,FBatchNo,FBegQty,FBegBal,
  FBegDiff,FInQty1,FInQty2,FInQty3,FInQty4,FInAmount,FInDiff,FOutQty1,FOutQty2,FOutQty3,FOutQty4,FOutAmount,FOutDiff,FQtyDecimal,FPriceDecimal) 
  SELECT v1.FStockid,v1.FItemID,
isnull(v1.FBatchNo,''),v1.FBegQty,
  CASE WHEN t1.FTrack=81 THEN round(v1.FBegBal,2)-round(v1.FBegDiff,2) else round(v1.FBegBal,2) end,v1.FBegDiff,0,0,0,0,0,0,0,0,0,0,0,0,
  t1.FQtyDecimal,t1.FPriceDecimal 
  FROM ICinvBal v1,t_ICItem t1,t_stock 

  WHERE v1.FYear=left(@begindate,4)
  AND  v1.FPeriod=convert(int,right(left(@begindate,7),2))
  AND  v1.FItemID=t1.FItemID 
  AND  v1.FStockID=t_stock.FItemID 
 AND t1.FNumber>=@beginnumber AND t1.FNumber<=@endnumber
  AND  Not (v1.FBegQty=0  AND v1.FBegBal=0 AND v1.FBegDiff=0)

  
  INSERT INTO #Happen(FStockid,FItemID,FBatchNo,FBegQty,FBegBal,FBegDiff,FInQty1,FInQty2,FInQty3,FInQty4,FInAmount,FInDiff,FOutQty1,FOutQty2,FOutQty3,FOutQty4,FOutAmount,FOutDiff,FQtyDecimal,FPriceDecimal)
 SELECT  Case When v2.FDCStockID in(Select FItemID From t_stock ) Then v2.FDCStockID else v2.FSCStockID End, v2.FItemID,
isnull(v2.FBatchNo,'')
,0,0,0,
 CASE WHEN v1.FTranType IN(1) or (v1.FTranType=100 and v1.FBillTypeID=12542) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(2) or (v1.FTranType=100 and v1.FBillTypeID=12542) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(10) or (v1.FTranType=100 and v1.FBillTypeID=12542) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(40) or (v1.FTranType=100 and v1.FBillTypeID=12542) THEN  v2.FQty ELSE 0 END , 
 CASE WHEN (v1.FTranType IN(1,2,5,10,40,101,102) or (v1.FTranType=100 and v1.FBillTypeID=12542)) AND t1.FTrack<>81 THEN  round(v2.FAmount,2) 
 WHEN (v1.FTranType IN(1,2,5,10,40,100,101,102) or (v1.FTranType=100 and v1.FBillTypeID=12542)) AND t1.FTrack=81 THEN v2.FPlanAmount ELSE 0 END , 
 CASE WHEN v1.FTranType IN(1,2,5,10,40,101,102) or (v1.FTranType=100 and v1.FBillTypeID=12542) THEN v2.FAmount- v2.FPlanAmount ELSE 0 END , 
 CASE WHEN v1.FTranType IN(21) or (v1.FTranType=100 and v1.FBillTypeID=12541) THEN  v2.FQty ELSE 0 END , 
 CASE WHEN v1.FTranType IN(24) or (v1.FTranType=100 and v1.FBillTypeID=12541) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(29) or (v1.FTranType=100 and v1.FBillTypeID=12541) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(43) or (v1.FTranType=100 and v1.FBillTypeID=12541) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN (v1.FTranType IN(21,24,28,29,43) or (v1.FTranType=100 and v1.FBillTypeID=12541)) AND t1.FTrack<>81 THEN  round(v2.FAmount,2) 
 WHEN (v1.FTranType IN(21,24,28,29,43)  or (v1.FTranType=100 and v1.FBillTypeID=12541))  AND t1.FTrack=81 THEN v2.FPlanAmount ELSE 0 END ,
 CASE WHEN v1.FTranType IN(21,24,28,29,43) or (v1.FTranType=100 and v1.FBillTypeID=12541)  THEN v2.FAmount-v2.FPlanAmount ELSE 0 END  ,t1.FQtyDecimal,t1.FPriceDecimal
 FROM ICStockBill v1,ICStockBillEntry v2,t_ICItem t1 

 WHERE v1.FInterID=v2.FInterID 
 AND v2.FItemID=t1.FItemID 
 AND t1.FNumber>=@beginnumber AND t1.FNumber<=@endnumber
 AND v1.FDate >=@begindate
 AND v1.FDate <=@enddate
 AND v1.FTranType <>41  AND v1.FStatus>0 And v1.FCancelLation=0  union all SELECT Case When v2.FDCStockID in(Select FItemID From t_stock ) Then v2.FDCStockID else 
v2.FSCStockID End,v2.FItemID,
isnull(v2.FBatchNo,'')
,0,0,0,
CASE WHEN v1.FTranType IN(1) THEN  v2.FQty ELSE 0 END , 
CASE WHEN v1.FTranType IN(2) THEN  v2.FQty ELSE 0 END , 
CASE WHEN v1.FTranType IN(10) THEN  v2.FQty ELSE 0 END , 
 CASE WHEN v1.FTranType IN(40) THEN  v2.FQty ELSE 0 END , 
 CASE WHEN v1.FTranType IN(1,2,5,10,40,100,101,102,41) AND t1.FTrack<>81 THEN  round(v2.FAmtRef,2) 
 WHEN v1.FTranType IN(1,2,5,10,40,100,101,102,41) AND t1.FTrack=81 THEN v2.FPlanAmount ELSE 0 END , 
 CASE WHEN v1.FTranType IN(1,2,5,10,40,100,101,102,41) THEN v2.FAmtRef-v2.FPlanAmount ELSE 0 END , 
 0 , 
 0 ,
0 ,
0 ,
0 ,
 0 ,t1.FQtyDecimal,t1.FPriceDecimal 
 FROM ICStockBill v1,ICStockBillEntry v2,t_ICItem t1 

 WHERE v1.FInterID=v2.FInterID 
 AND v2.FItemID=t1.FItemID 
 AND t1.FNumber>=@beginnumber AND t1.FNumber<=@endnumber
 AND v1.FDate >=@begindate
 AND v1.FDate <=@enddate
 AND v1.FTranType =41  AND v1.FStatus>0 And v1.FCancelLation=0  
union all 
SELECT Case When v2.FSCStockID in(Select FItemID From t_stock ) Then v2.FSCStockID else 
v2.FDCStockID End,v2.FItemID,
isnull(v2.FBatchNo,'')
,0,0,0,
 0, 
 0, 
 0,
 0, 
 0, 
 0, 
 CASE WHEN v1.FTranType IN(21) THEN  v2.FQty ELSE 0 END , 
 CASE WHEN v1.FTranType IN(24) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(29) THEN  v2.FQty ELSE 0 END ,
 CASE WHEN v1.FTranType IN(43) THEN  v2.FQty ELSE 0 END , 
 CASE WHEN v1.FTranType IN(21,24,28,29,43,41) AND t1.FTrack<>81 THEN  v2.FAmount 
 WHEN v1.FTranType IN(21,24,28,29,43,41) AND t1.FTrack=81 THEN v2.FPlanAmount ELSE 0 END ,
 CASE WHEN v1.FTranType IN(21,24,28,29,43,41) THEN  v2.FAmount- v2.FPlanAmount ELSE 0 END ,t1.FQtyDecimal,t1.FPriceDecimal
 FROM ICStockBill v1,ICStockBillEntry v2,t_ICItem t1 

 WHERE v1.FInterID=v2.FInterID 
 AND v2.FItemID=t1.FItemID 
 AND t1.FNumber>=@beginnumber AND t1.FNumber<=@endnumber
 AND v1.FDate >=@begindate
 AND v1.FDate <=@enddate
 AND v1.FTranType =41  AND v1.FStatus>0 And v1.FCancelLation=0 SET NOCOUNT ON
CREATE TABLE #DATA(
 FBatchNo   VARCHAR(355) null,
     FNumber  VARCHAR(355) null,
     FShortNumber  VARCHAR(355) null,
     FName  VARCHAR(355) null,
     FModel  VARCHAR(355) null,
     FUnitName  VARCHAR(355) null,
     FQtyDecimal smallint null, 
     FPriceDecimal smallint null, 
     FBegQty decimal(28,10),     --期初数量
     FBegPrice decimal(28,10),   --期初单价
     FBegBal decimal(28,10),     --期初金额
     FBegDiff decimal(28,10),    
     FInQty1  decimal(28,10),     --本期外购入库数量
     FInQty2  decimal(28,10),     --本期产品入库数量
     FInQty3  decimal(28,10),     --本期其他入库数量
     FInQty4  decimal(28,10),     --本期盘盈数量
     FInPrice  decimal(28,10),   --本期单价
     FInAmount decimal(28,10),   --本期金额
     FInDiff decimal(28,10),
     FOutQty1 decimal(28,10),     --本期发出
     FOutQty2 decimal(28,10),     --本期发出
     FOutQty3 decimal(28,10),     --本期发出
     FOutQty4 decimal(28,10),     --本期发出
     FOutPrice decimal(28,10),   --本期单价
     FOutAmount decimal(28,10),  --本期金额
     FOutDiff decimal(28,10),
     FEndQty decimal(28,10),     --期末结存数量
     FEndPrice decimal(28,10),   --期末单价
     FEndAmount decimal(28,10),  --期末金额
     FEndDiff decimal(28,10),
     FSumSort smallint not null Default(0),
     FID int IDENTITY)

 INSERT INTO #DATA ( FBatchNo,FNumber,FShortNumber,FName,FModel,FUnitName,
 FQtyDecimal,FPriceDecimal,FBegQty,FBegPrice,
 FBegBal,FBegDiff,FInQty1,FInQty2,FInQty3,FInQty4,FInPrice,FInAmount,FInDiff,FOutQty1,FOutQty2,FOutQty3,FOutQty4,
 FOutPrice,FOutAmount,FOutDiff,FEndQty,FEndPrice,FEndAmount,FEndDiff,FSumSort)
 SELECT CASE  WHEN GROUPING(t1.FNumber)=1  THEN '合计'
 WHEN GROUPING(v2.FBatchNo)=1 THEN  isnull(v2.FBatchNo,'')+'小计'
 ELSE v2.FBatchNo END, 
 t1.FNumber,'','','','',Max(v2.FQtyDecimal),Max(v2.FPriceDecimal), 
SUM(isNull(v2.FBegQty,0)),0,SUM(isNull(v2.FBegBal,0)),SUM(isNull(v2.FBegDiff,0)),SUM(isNull(FInQty1,0)),SUM(isNull(FInQty2,0)),SUM(isNull(FInQty3,0)),SUM(isNull(FInQty4,0)),0,SUM(isNull(FInAmount,0)),SUM(isNull(v2.FInDiff,0)),SUM(isNull(FOutQty1,0)), SUM(isNull(FOutQty2,0)), SUM(isNull(FOutQty3,0)), SUM(isNull(FOutQty4,0)), 
0,SUM(isNull(FOutAmount,0)),SUM(isNull(v2.FOutDiff,0)),0,0,0,0, CASE WHEN GROUPING(t1.FNumber)=1 THEN 101
 WHEN  GROUPING(v2.FBatchNo)=1 THEN 102 ELSE 0 END  FROM #Happen v2,t_ICItem t1  WHERE  v2.FItemID=t1.FItemID 
 AND t1.FNumber>=@beginnumber AND t1.FNumber<=@endnumber

 GROUP BY t1.FNumber,v2.FBatchNo WITH ROLLUP
 UPDATE t1 SET t1.FName=t2.FName,t1.FShortNumber=t2.FShortNumber,t1.FModel=t2.FModel, 
t1.FUnitName=t3.FName,t1.FQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal  FROM #DATA t1,t_ICItem t2,t_MeasureUnit t3  WHERE t1.FNumber=t2.FNumber  AND 
t2.FUnitGroupID=t3.FUnitGroupID  AND t3.FStandard=1
 UPDATE #Data SET FEndQty=FBegQty+(FInQty1+FInQty2+FInQty3+FInQty4)-(FOutQty1+FOutQty2+FOutQty3+FOutQty4), FEndAmount=ROUND(FBegBal,2)+ROUND(FInAmount,2)-ROUND(FOutAmount,2) Update #Data SET FBegPrice=FBegBal/FBegQty WHERE 
FBegQty<>0
 Update #Data SET FInPrice=FInAmount/(FInQty1+FInQty2+FInQty3+FInQty4) WHERE FInQty1<>0 or FInQty2<>0 or FInQty3<>0 or FInQty4<>0
 Update #Data SET FOutPrice=FOutAmount/(FOutQty1+FOutQty2+FOutQty3+FOutQty4) WHERE FOutQty1<>0 or FOutQty2<>0 or FOutQty3<>0 or FOutQty4<>0 
 Update #Data SET FEndPrice=FEndAmount/FEndQty WHERE FEndQty<>0
SELECT FBatchNo,FNumber,FShortNumber,FName,FModel,FUnitName,FQtyDecimal,FPriceDecimal,FBegQty,FBegPrice,FBegBal,FBegDiff,FInQty1,FInAmount1=FInQty1*FInPrice,FInQty2,FInAmount2=FInQty2*FInPrice,FInQty3,FInAmount3=FInQty3*FInPrice,FInQty4,FInAmount4=FInQty4*FInPrice,FInPrice,FInAmount,FInDiff,FOutQty1,FOutAmount1=FOutQty1*FOutPrice,FOutQty2,FOutAmount2=FOutQty2*FOutPrice,FOutQty3,FOutAmount3=FOutQty3*FOutPrice,FOutQty4,FOutAmount4=FOutQty4*FOutPrice,FOutPrice,FOutAmount,FOutDiff,FEndQty,FEndPrice,FEndAmount,FEndDiff,FSumSort,FID 
FROM #DATA  WHERE FSumSort>100 and (FNumber like '%'+@query+'%' or FName like '%'+@query+'%' or FModel like '%'+@query+'%')
 ORDER BY FID 
end

drop table #Happen

drop table #Data

execute report_clsfchzb '','2012-01-01','2012-01-31','01.01.01.001','04.05.134'






21 销售出库
24 生产领料
29 其他出库 
43 盘亏


select left('2012-01-01',4)

select convert(int,right(left('2012-12-01',7),2))