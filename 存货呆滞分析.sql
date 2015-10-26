select datediff(month,b.FDate,getDate()),a.* 
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,FBatchNo,MIN(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (1,2,6,10) AND v1.FCancellation = 0 group by i.FNumber,FBatchNo
) b on a.dm=b.FNumber


select * from ICStockBillEntry

/* 最近销售时间(包括其他出库)
update a set a.zjxssj=Convert(char(10),b.FDate,120)
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (21,29) AND v1.FCancellation = 0 group by i.FNumber
) b on a.dm=b.FNumber
*/

/* 最近入库时间（外购入库、销售入库、其他入库、虚仓入库）
update a set a.zhrksj=Convert(char(10),b.FDate,120)
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (1,2,6,10) AND v1.FCancellation = 0 group by i.FNumber
) b on a.dm=b.FNumber
*/

/* 库龄
update a set kl=datediff(month,b.FDate,getDate())
from rss.dbo.kcdz1$ a 
left join (
select i.FNumber,FBatchNo,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (1,2,6,10) AND v1.FCancellation = 0 group by i.FNumber,FBatchNo
) b on a.dm=b.FNumber


select * from rss.dbo.kcdz1$
*/

select * from rss.dbo.kcdz1$




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

Create Table #data (
wldm nvarchar(20) default('')          
,wlmc nvarchar(100) default('')          
,wlgg nvarchar(100) default('')
,cpth nvarchar(100) default('')
,jldw nvarchar(20) default('')
,jskc decimal(28,0) default(0)
,kf nvarchar(20) default('')
)

Insert Into #data(wldm,wlmc,wlgg,cpth,jldw,jskc,kf
)

Select t1.FNumber AS FLongNumber,t1.FName,t1.FModel,t1.FHelpCode,t3.FName,SUM(ROUND(u1.FQty,t1.FQtydecimal)) as FBUQty,t2.FName 
	From #TempInventory u1
	left join t_ICItem t1 on u1.FItemID = t1.FItemID
	left join t_Stock t2 on u1.FStockID=t2.FItemID
	left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
	left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
	left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
	left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID 
	left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  
	where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
	and t1.FDeleted=0 
	AND t2.FTypeID in (500,20291,20293)
	and t2.FItemID <> '4527'             --废品（工废）库
	and t2.FItemID <> '4528'             --可利用库
	and t2.FItemID <> '4739'             --返工返修库
	and t2.FItemID <> '5272'             --料废库
	and t2.FItemID <> '5888'             --封存库
	group by t1.FNumber,t1.FName,t1.FModel,t1.FHelpCode,t3.FName,t2.FName
	order by t1.FNumber


select a.*,Convert(char(10),b.FDate,120) from #data a
left join (
select i.FNumber,MAX(v1.FDate) as FDate from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID where v1.FTranType in (24,21,29) AND v1.FCancellation = 0 group by i.FNumber
) b on a.wldm=b.FNumber
where b.FDate is null





