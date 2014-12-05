--根据物料代码查询及时库存
--DROP PROCEDURE query_jskc

CREATE PROCEDURE query_jskc
@FNumber nvarchar(255),
@FBatchNo nvarchar(255)
AS
BEGIN
Set Nocount on
DECLARE @JSKC decimal(28,4)

Create Table #TempInventory( 
                            [FBrNo] [varchar] (10)  NOT NULL ,
                            [FItemID] [int] NOT NULL ,
                            [FBatchNo] [varchar] (200)  NOT NULL ,
                            [FMTONo] [varchar] (200)  NOT NULL ,
                            [FStockID] [int] NOT NULL ,
                            [FQty] [decimal](28, 10) NOT NULL ,
                            [FBal] [decimal](20, 2) NOT NULL ,
                            [FStockPlaceID] [int] NULL ,
                            [FKFPeriod] [int] NOT NULL Default(0),
                            [FKFDate] [varchar] (255)  NOT NULL ,
                            [FMyKFDate] [varchar] (255), 
                            [FStockTypeID] [Int] NOT NULL,
                            [FQtyLock] [decimal](28, 10) NOT NULL,
                            [FAuxPropID] [int] NOT NULL,
                            [FSecQty] [decimal](28, 10) NOT NULL
                             )
Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),500,u1.FQtyLock,u1.FAuxPropID,u1.FSecQty From ICInventory u1 where u1.FQty<>0 

Insert Into #TempInventory Select u1.FBrNo,u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FStockID,u1.FQty,u1.FBal,u1.FStockPlaceID,
u1.FKFPeriod,ISNULL(u1.FKFDate,''),ISNULL(u1.FKFDate,''),u1.FStockTypeID,0,u1.FAuxPropID,u1.FSecQty From POInventory u1 where u1.FQty<>0 

if @FBatchNo<>''
	Select @JSKC=SUM(ROUND(ISNull(u1.FQty,0),t1.FQtydecimal) )
 	From #TempInventory u1
 	left join t_ICItem t1 on u1.FItemID = t1.FItemID
	left join t_Stock t2 on u1.FStockID=t2.FItemID
	left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
	left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
	left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
	left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  
	where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
	Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
	and t1.FDeleted=0 
	AND t2.FTypeID in (500,20291,20293)
	AND t1.FNumber = @FNumber
	AND u1.FBatchNo = @FBatchNo
ELSE
	Select @JSKC=SUM(ROUND(ISNull(u1.FQty,0),t1.FQtydecimal) )
	From #TempInventory u1
	left join t_ICItem t1 on u1.FItemID = t1.FItemID
	left join t_Stock t2 on u1.FStockID=t2.FItemID
	left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
	left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
	left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
	left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  
	where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
	Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
	and t1.FDeleted=0 
	AND t2.FTypeID in (500,20291,20293)
	AND t1.FNumber = @FNumber

RETURN @JSKC
END

DECLARE @JSKC decimal(28,4)  

EXEC @JSKC=query_jskc '01.01.06.050',''

SELECT @JSKC


SELECT FQtydecimal,* FROM t_ICItem WHERE FNumber = '01.01.06.048'


WORK025563-2

exec query_jskc '01.01.06.050',''
