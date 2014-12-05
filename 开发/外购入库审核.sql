--drop procedure check_wgrk drop procedure uncheck_wgrk

create procedure check_wgrk
@FInterID int              --单据内码
,@FName nvarchar(255)                   --审核人
as 
begin
SET NOCOUNT ON 
DECLARE @FCurCheckLevel int
DECLARE @FUserID int

select @FCurCheckLevel=FCurCheckLevel from ICStockBill where FInterID=@FInterID
select @FUserID=FUserID from t_user where FName=@FName

if (@FCurCheckLevel is null or @FCurCheckLevel=0)
	Update ICStockBill Set FMultiCheckLevel1 = @FUserID, FMultiCheckDate1 = convert(char(10),getDate(),120), FCurCheckLevel = 1 Where FInterID = @FInterID And FTranType =1
else if @FCurCheckLevel = 1 
begin
	Update ICStockBill Set FMultiCheckLevel2 = @FUserID, FMultiCheckDate2 = convert(char(10),getDate(),120), FCurCheckLevel = 2 Where FInterID = @FInterID And FTranType =1
	--Drop table #TempBill
	CREATE TABLE #TempBill
	(FID INT IDENTITY (1,1),
 	FBrNo VARCHAR(10) NOT NULL DEFAULT(''),
 	FInterID INT NOT NULL DEFAULT(0),
 	FEntryID INT NOT NULL DEFAULT(0),
 	FTranType INT NOT NULL DEFAULT(0),
 	FItemID INT NOT NULL DEFAULT(0),
 	FBatchNo NVARCHAR(255) NOT NULL DEFAULT(''),
 	FMTONo NVARCHAR(255) NOT NULL DEFAULT(''),
 	FAuxPropID INT NOT NULL DEFAULT(0),
 	FStockID INT NOT NULL DEFAULT(0),
 	FStockPlaceID INT NOT NULL DEFAULT(0),
 	FKFPeriod INT NOT NULL DEFAULT(0),
 	FKFDate VARCHAR(20) NOT NULL DEFAULT(''),
 	FQty DECIMAL(28,10) NOT NULL DEFAULT(0),
 	FSecQty DECIMAL(28,10) NOT NULL DEFAULT(0)
	)
	
	INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
	SELECT '',u1.FInterID,u1.FEntryID,1 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,ISNULL(u1.FMTONo,'') AS FMTONo,
        u1.FAuxPropID,ISNULL(u1.FDCStockID,0) AS FDCStockID,ISNULL(u1.FDCSPID,0) AS FDCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,
        LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,
	1*u1.FQty AS FQty,1*u1.FSecQty AS FSecQty
	FROM ICStockBillEntry u1 
	WHERE u1.FInterID=@FInterID



	UPDATE t1
	SET t1.FQty=round(t1.FQty,ti.FQtyDecimal)+round(u1.FQty,ti.FQtyDecimal),
	t1.FSecQty=round(t1.FSecQty,ti.FQtyDecimal)+round(u1.FSecQty,ti.FQtyDecimal)
	FROM ICInventory t1 INNER JOIN
	(SELECT FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
        ,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
	 FROM #TempBill
	 GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
	) u1
	ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
	   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
	   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate
	 INNER JOIN t_ICItemBase ti ON u1.FItemid=ti.FItemid 

	DELETE u1
	FROM ICInventory t1 INNER JOIN #TempBill u1
	ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
	   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
	   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate

	INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
	SELECT '',FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,
        SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
	FROM #TempBill
	GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate

	Drop table #TempBill


	UPDATE ICStockBill SET FOrderAffirm=0 WHERE FInterID=@FInterID  --终审完毕

	Update ICStockBill Set FCheckerID=@FUserID,FStatus=1,FCheckDate=convert(char(10),getDate(),120) WHERE FInterID=@FInterID

	IF EXISTS(SELECT FOrderInterID FROM ICStockBillEntry WHERE FOrderInterID>0 AND FInterID=@FInterID)
	 UPDATE u1
	 SET u1.FStockQty=u1.FStockQty+1* CAST(u2.FStockQty AS FLOAT)
	     ,u1.FSecStockQty=u1.FSecStockQty+1* CAST(u2.FSecStockQty AS FLOAT)
	     ,u1.FAuxStockQty=ROUND((u1.FStockQty+1* CAST(u2.FStockQty AS FLOAT))/ CAST(t3.FCoefficient AS FLOAT),t1.FQtyDecimal)
	 FROM POOrderEntry u1 
	 INNER JOIN 
	 (SELECT FOrderInterID,FOrderEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FSecQty)AS FSecStockQty,SUM(FAuxQty) AS FAuxStockQty
	  FROM ICStockBillEntry WHERE FInterID=@FInterID  GROUP BY FOrderInterID,FOrderEntryID,FItemID) u2
	 ON u1.FInterID=u2.FOrderInterID AND u1.FEntryID=u2.FOrderEntryID AND u1.FItemID=u2.FItemID
	 INNER JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
end
end

--反审核--
create procedure uncheck_wgrk
@FInterID int              --单据内码
,@FName nvarchar(255)                   --审核人
as 
begin
SET NOCOUNT ON 
DECLARE @FCurCheckLevel int
DECLARE @FUserID int
DECLARE @count int

select @FCurCheckLevel=FCurCheckLevel from ICStockBill where FInterID=@FInterID
select @FUserID=FUserID from t_user where FName=@FName

if @FCurCheckLevel = 2 
begin
	CREATE TABLE #TempBill
	(FID INT IDENTITY (1,1),
	 FBrNo VARCHAR(10) NOT NULL DEFAULT(''),
	 FInterID INT NOT NULL DEFAULT(0),
	 FEntryID INT NOT NULL DEFAULT(0),
	 FTranType INT NOT NULL DEFAULT(0),
	 FItemID INT NOT NULL DEFAULT(0),
	 FBatchNo NVARCHAR(255) NOT NULL DEFAULT(''),
	 FMTONo NVARCHAR(255) NOT NULL DEFAULT(''),
	 FAuxPropID INT NOT NULL DEFAULT(0),
	 FStockID INT NOT NULL DEFAULT(0),
	 FStockPlaceID INT NOT NULL DEFAULT(0),
	 FKFPeriod INT NOT NULL DEFAULT(0),
	 FKFDate VARCHAR(20) NOT NULL DEFAULT(''),
	 FQty DECIMAL(28,10) NOT NULL DEFAULT(0),
	 FSecQty DECIMAL(28,10) NOT NULL DEFAULT(0)
	)
	
	INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
	SELECT '',u1.FInterID,u1.FEntryID,1 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,ISNULL(u1.FMTONo,'') AS FMTONo,
	       u1.FAuxPropID,ISNULL(u1.FDCStockID,0) AS FDCStockID,ISNULL(u1.FDCSPID,0) AS FDCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,
	       LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,
	-1*u1.FQty AS FQty,-1*u1.FSecQty AS FSecQty
	FROM ICStockBillEntry u1 
	WHERE u1.FInterID=@FInterID
	
	SELECT @count=count(*)--ts.FUnderStock,m1.FItemID,t2.FName,t2.FNumber,m1.FStockID,m1.FStockPlaceID,m1.FAuxPropID,t3.FName AS FAuxPropName,m1.FBatchNo,m1.FMTONo
	FROM (SELECT u1.FItemID,u1.FAuxPropID,u1.FBatchNo,u1.FMTONo,u1.FStockID ,u1.FStockPlaceID,u1.FKFdate,u1.FKFPeriod
	,SUM(u1.FQty) AS FBillQty,SUM(u1.FSecQty) AS FBillSecQty
	FROM #TempBill u1 
	GROUP BY u1.FItemID,u1.FAuxPropID,u1.FBatchNo,u1.FMTONo,u1.FStockID ,u1.FStockPlaceID,u1.FKFdate,u1.FKFPeriod) m1
	INNER JOIN t_ICItem t2 ON m1.FItemID=t2.FItemID
	INNER JOIN t_AuxItem t3 ON m1.FAuxPropID=t3.FItemID
	INNER JOIN t_Stock ts ON m1.FStockID=ts.FItemID
	LEFT OUTER JOIN ICInventory t1 ON t1.FItemID=m1.FItemID AND t1.FBatchNo=m1.FBatchNo AND t1.FMTONo=m1.FMTONo AND t1.FAuxPropID=m1.FAuxPropID
	   AND t1.FStockID=m1.FStockID AND t1.FStockPlaceID=m1.FStockPlaceID 
	   AND t1.FKFPeriod=m1.FKFPeriod AND t1.FKFDate=m1.FKFDate
	WHERE (Round(ISNULL(t1.FQty,0),t2.FQtyDecimal)+m1.FBillQty)<0 OR (Round(ISNULL(t1.FSecQty,0),t2.FQtyDecimal)+m1.FBillSecQty)<0 

	if @count=0
	begin
		UPDATE t1
		SET t1.FQty=round(t1.FQty,ti.FQtyDecimal)+round(u1.FQty,ti.FQtyDecimal),
		t1.FSecQty=round(t1.FSecQty,ti.FQtyDecimal)+round(u1.FSecQty,ti.FQtyDecimal)
		FROM ICInventory t1 INNER JOIN
		(SELECT FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
		        ,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
		 FROM #TempBill
		 GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
		) u1
		ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
		   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
		   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate
		 INNER JOIN t_ICItemBase ti ON u1.FItemid=ti.FItemid 
		
		DELETE u1
		FROM ICInventory t1 INNER JOIN #TempBill u1
		ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
		   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
		   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate
		
		INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
		SELECT '',FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,
		       SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
		FROM #TempBill
		GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
		
		Update ICStockBill Set FMultiCheckLevel2 = Null , FMultiCheckDate2 = Null , FCurCheckLevel = 1  Where FInterID = @FInterID And FTranType =1

		UPDATE ICStockBill SET FOrderAffirm=0 WHERE FInterID=@FInterID
		
		Update ICStockBill Set FCheckerID=Null,FStatus=0,FCheckDate=Null WHERE FInterID=@FInterID
		
		IF EXISTS(SELECT FOrderInterID FROM ICStockBillEntry WHERE FOrderInterID>0 AND FInterID=@FInterID)
		 UPDATE u1
		 SET u1.FStockQty=u1.FStockQty+-1* CAST(u2.FStockQty AS FLOAT)
		     ,u1.FSecStockQty=u1.FSecStockQty+-1* CAST(u2.FSecStockQty AS FLOAT)
		     ,u1.FAuxStockQty=ROUND((u1.FStockQty+-1* CAST(u2.FStockQty AS FLOAT))/ CAST(t3.FCoefficient AS FLOAT),t1.FQtyDecimal)
		 FROM POOrderEntry u1 
		 INNER JOIN 
		 (SELECT FOrderInterID,FOrderEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FSecQty)AS FSecStockQty,SUM(FAuxQty) AS FAuxStockQty
		  FROM ICStockBillEntry WHERE FInterID=@FInterID  GROUP BY FOrderInterID,FOrderEntryID,FItemID) u2
		 ON u1.FInterID=u2.FOrderInterID AND u1.FEntryID=u2.FOrderEntryID AND u1.FItemID=u2.FItemID
		 INNER JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
		
		 Drop table #TempBill
		 select '反审核成功！' as result
	end
	else
	begin
		Drop table #TempBill
		select '反审核未成功，请检查！' as result
	end
end
else if @FCurCheckLevel = 1
begin
	Update ICStockBill Set FMultiCheckLevel1 = Null , FMultiCheckDate1 = Null , FCurCheckLevel = 0 Where FInterID = @FInterID And FTranType =1
	select '反审核成功！' as result
end
end


execute check_wgrk 2222,16442

execute uncheck_wgrk 2222,16442

select * from t_user where FUserID=16442

select * from ICStockBill where FBillNo='WIN000095'





select * from t_item where FNumber='03.01.012'

select * from POrequestEntry where FInterID=1302 and FEntryID=2

select * from POrequest where FInterID=78

select * from POrequestEntry where FInterID=78 and FEntryID=1

select * from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo in ('POREQ000017','POREQ000063')

