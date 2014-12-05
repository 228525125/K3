--drop procedure check_stjgrk drop procedure uncheck_stjgrk

create procedure check_stjgrk
@FInterID int              --单据内码
,@FUserID int                   --审核人
as 
begin
SET NOCOUNT ON 
DECLARE @FCurCheckLevel int

select @FCurCheckLevel=FCurCheckLevel from ICSTJGBill where FInterID=@FInterID

if (@FCurCheckLevel is null or @FCurCheckLevel=0)
begin
	Update ICSTJGBill Set FMultiCheckLevel1 = @FUserID, FMultiCheckDate1 = convert(char(10),getDate(),120), FCurCheckLevel = 1 Where FInterID = @FInterID And FTranType =92
end
else if @FCurCheckLevel = 1 
begin
	Update ICSTJGBill Set FMultiCheckLevel2 = @FUserID, FMultiCheckDate2 = convert(char(10),getDate(),120), FCurCheckLevel = 2 Where FInterID = @FInterID And FTranType =92
	CREATE TABLE #TempBill
	(FID INT IDENTITY (1,1),FBrNo VARCHAR(10) NOT NULL DEFAULT(''),
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
	
	INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
	SELECT '',u1.FInterID,u1.FEntryID,92 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,
	       u1.FAuxPropID,ISNULL(u1.FDCStockID,0) AS FDCStockID,ISNULL(u1.FDCSPID,0) AS FDCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,
	       LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,
	1*u1.FQty AS FQty,1*u1.FSecQty AS FSecQty
	FROM ICSTJGBillEntry u1 
	WHERE u1.FInterID=@FInterID
	
	UPDATE t1
	SET t1.FQty=round(t1.FQty,ti.FQtyDecimal)+round(u1.FQty,ti.FQtyDecimal),
	t1.FSecQty=round(t1.FSecQty,ti.FQtyDecimal)+round(u1.FSecQty,ti.FQtyDecimal)
	FROM POInventory t1 INNER JOIN
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
	FROM POInventory t1 INNER JOIN #TempBill u1
	ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
	   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
	   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate
	
	INSERT INTO POInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
	SELECT '',FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,
	       SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
	FROM #TempBill
	GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
	
	UPDATE t1
	SET t1.FStockTypeID = t2.FTypeID
	FROM POInventory t1 INNER JOIN
	t_Stock t2 ON t1.FStockID = t2.FItemID
	INNER JOIN #TempBill t3 
	ON t1.FStockID = t3.FStockID 
	AND t1.FItemID = t3.FItemID 
	AND t1.FBatchNo = t3.FBatchNo 
	AND t1.FMTONo = t3.FMTONo 
	AND t1.FAuxPropID = t3.FAuxPropID 
	AND t1.FStockPlaceID = t3.FStockPlaceID 
	AND t1.FKFPeriod = t3.FKFPeriod 
	AND t1.FKFDate = t3.FKFDate 
	
	DROP TABLE #TempBill
	
	UPDATE ICSTJGBill SET FCheckerID=@FUserID,FStatus=1,FCheckDate=convert(char(10),getDate(),120) WHERE FInterID=@FInterID
end
end

--反审核--
create procedure uncheck_stjgrk
@FInterID int              --单据内码
,@FUserID int                   --审核人
as 
begin
SET NOCOUNT ON 
DECLARE @FCurCheckLevel int
DECLARE @count int

select @FCurCheckLevel=FCurCheckLevel from ICSTJGBill where FInterID=@FInterID

if @FCurCheckLevel = 2
begin		
	CREATE TABLE #TempBill
	(FID INT IDENTITY (1,1),FBrNo VARCHAR(10) NOT NULL DEFAULT(''),
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

	INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
	SELECT '',u1.FInterID,u1.FEntryID,92 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,
	       u1.FAuxPropID,ISNULL(u1.FDCStockID,0) AS FDCStockID,ISNULL(u1.FDCSPID,0) AS FDCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,
	       LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,
	-1*u1.FQty AS FQty,-1*u1.FSecQty AS FSecQty
	FROM ICSTJGBillEntry u1 
	WHERE u1.FInterID=@FInterID
	
	SELECT @count=count(*)--ts.FUnderStock,m1.FItemID,t2.FName,t2.FNumber,m1.FStockID,m1.FStockPlaceID,m1.FAuxPropID,t3.FName AS FAuxPropName,m1.FBatchNo,m1.FMTONo
	FROM (SELECT u1.FItemID,u1.FAuxPropID,u1.FBatchNo,u1.FMTONo,u1.FStockID ,u1.FStockPlaceID,u1.FKFdate,u1.FKFPeriod
	,SUM(u1.FQty) AS FBillQty,SUM(u1.FSecQty) AS FBillSecQty
	FROM #TempBill u1 
	GROUP BY u1.FItemID,u1.FAuxPropID,u1.FBatchNo,u1.FMTONo,u1.FStockID ,u1.FStockPlaceID,u1.FKFdate,u1.FKFPeriod) m1
	INNER JOIN t_ICItem t2 ON m1.FItemID=t2.FItemID
	INNER JOIN t_AuxItem t3 ON m1.FAuxPropID=t3.FItemID
	INNER JOIN t_Stock ts ON m1.FStockID=ts.FItemID
	LEFT OUTER JOIN POInventory t1 ON t1.FItemID=m1.FItemID AND t1.FBatchNo=m1.FBatchNo AND t1.FMTONo=m1.FMTONo AND t1.FAuxPropID=m1.FAuxPropID
	   AND t1.FStockID=m1.FStockID AND t1.FStockPlaceID=m1.FStockPlaceID 
	   AND t1.FKFPeriod=m1.FKFPeriod AND t1.FKFDate=m1.FKFDate
	WHERE (Round(ISNULL(t1.FQty,0),t2.FQtyDecimal)+m1.FBillQty)<0 OR (Round(ISNULL(t1.FSecQty,0),t2.FQtyDecimal)+m1.FBillSecQty)<0 
	
	if @count=0
	begin
		UPDATE t1
		SET t1.FQty=round(t1.FQty,ti.FQtyDecimal)+round(u1.FQty,ti.FQtyDecimal),
		t1.FSecQty=round(t1.FSecQty,ti.FQtyDecimal)+round(u1.FSecQty,ti.FQtyDecimal)
		FROM POInventory t1 INNER JOIN
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
		FROM POInventory t1 INNER JOIN #TempBill u1
		ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
		   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
		   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate
		
		INSERT INTO POInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
		SELECT '',FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,
		       SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
		FROM #TempBill
		GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate
		
		UPDATE t1
		SET t1.FStockTypeID = t2.FTypeID
		FROM POInventory t1 INNER JOIN
		t_Stock t2 ON t1.FStockID = t2.FItemID
		INNER JOIN #TempBill t3 
		ON t1.FStockID = t3.FStockID 
		AND t1.FItemID = t3.FItemID 
		AND t1.FBatchNo = t3.FBatchNo 
		AND t1.FMTONo = t3.FMTONo 
		AND t1.FAuxPropID = t3.FAuxPropID 
		AND t1.FStockPlaceID = t3.FStockPlaceID 
		AND t1.FKFPeriod = t3.FKFPeriod 
		AND t1.FKFDate = t3.FKFDate 
		
		DROP TABLE #TempBill
		Update ICSTJGBill Set FMultiCheckLevel2 = Null , FMultiCheckDate2 = Null , FCurCheckLevel = 1 Where FInterID = @FInterID And FTranType =92
		UPDATE ICSTJGBill SET FCheckerID=NULL,FStatus=0,FCheckDate=Null WHERE FInterID=@FInterID
		select '反审核成功！' as result
	end
	else
	begin
		DROP TABLE #TempBill
		select '反审核未成功，请检查！' as result
	end
end
if @FCurCheckLevel = 1
begin
	Update ICSTJGBill Set FMultiCheckLevel1 = Null , FMultiCheckDate1 = Null , FCurCheckLevel = 0 Where FInterID = @FInterID And FTranType =92
	select '反审核成功！' as result
end
end

select * from ICSTJGBill where FBillNo='STJGIN000009'

execute check_stjgrk 1017,16442

execute uncheck_stjgrk 1017,16442