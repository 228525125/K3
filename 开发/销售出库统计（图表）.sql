--drop procedure chart_column_xsck 

create procedure chart_column_xsck 
@begin nvarchar(255),
@end nvarchar(255),
@wldm nvarchar(255),                    --物料代码
@wldw nvarchar(255)                     --往来单位代码
as 
begin
SET NOCOUNT ON 
create table #Data(
FDate nvarchar(255),
FAllAmount decimal(28,2) default(0)
)

Insert Into #Data(FDate,FAllAmount
)
select convert(char(6),v1.FDate,112) as FDate,sum(u1.FQty*a1.FPriceDiscount) as FAllAmount 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN SEOrderEntry a1 on u1.FOrderInterID=a1.FInterID and u1.FOrderEntryID=a1.FEntryID 
LEFT JOIN SEOrder a2 on a1.FInterID = a2.FInterID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization o on o.FItemID=v1.FSupplyID
where 1=1 
AND v1.FTranType=21 AND v1.FCancellation = 0 AND v1.FStatus>0
AND a2.FAreaPS=20302                           --销售范围：购销
AND i.FErpClsID=2                              --物料属性：自制
AND v1.FDate>=@begin AND  v1.FDate<=@end
AND i.FNumber like '%'+@wldm+'%'
AND o.FNumber like '%'+@wldw+'%'
group by convert(char(6),v1.FDate,112)
order by convert(char(6),v1.FDate,112)

select * from #Data
end

--------数量--------
--drop procedure chart_column_xsck_qty

create procedure chart_column_xsck_qty 
@begin nvarchar(255),
@end nvarchar(255),
@wldm nvarchar(255),                    --物料代码
@wldw nvarchar(255)                     --往来单位代码
as 
begin
SET NOCOUNT ON 
create table #Data(
FDate nvarchar(255),
FQty decimal(28,2) default(0)
)

Insert Into #Data(FDate,FQty
)
select convert(char(6),v1.FDate,112) as FDate,sum(u1.FQty) as FQty 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN SEOrderEntry a1 on u1.FOrderInterID=a1.FInterID and u1.FOrderEntryID=a1.FEntryID 
LEFT JOIN SEOrder a2 on a1.FInterID = a2.FInterID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization o on o.FItemID=v1.FSupplyID
where 1=1 
AND v1.FTranType=21 AND v1.FCancellation = 0 AND v1.FStatus>0
AND a2.FAreaPS=20302                           --销售范围：购销
AND i.FErpClsID=2                              --物料属性：自制
AND v1.FDate>=@begin AND  v1.FDate<=@end
AND i.FNumber like '%'+@wldm+'%'
AND o.FNumber like '%'+@wldw+'%'
group by convert(char(6),v1.FDate,112)
order by convert(char(6),v1.FDate,112)

select * from #Data
end

execute chart_column_xsck_qty '2010-01-01','2012-05-31','','01.002'         --数量

execute chart_column_xsck '2013-01-01','2014-05-31','','01.144'             --金额


select FNumber,FName from t_ICItem where left(FNumber,3)=''

select * from t_ICItem where FNumber in ('06.02.2004','06.02.2011')

select i.FNumber,convert(char(6),v1.FDate,112) as FDate,sum(u1.FQty) as FQty 
--select * 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization o on o.FItemID=v1.FSupplyID
where 1=1 
AND v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FStatus>0
AND v1.FDate>='2013-09-01' AND  v1.FDate<='2013-11-30'
AND i.FNumber IN (
'05.08.0018',
'05.04.0119',
'05.04.0120',
'05.04.0121',
'05.04.0117',
'05.04.0118'
)
group by i.FNumber,convert(char(6),v1.FDate,112)
order by i.FNumber,convert(char(6),v1.FDate,112)


SELECT * FROM ICStockBill


select /*convert(char(6),v1.FDate,112) as FDate,*/i.FNumber,i.FName,i.FModel,MAX(v1.FDate)/*,sum(u1.FQty) as FQty,sum(u1.FQty*a1.FPriceDiscount) as FAllAmount*/
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN SEOrderEntry a1 on u1.FOrderInterID=a1.FInterID and u1.FOrderEntryID=a1.FEntryID 
LEFT JOIN SEOrder a2 on a1.FInterID = a2.FInterID
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization o on o.FItemID=v1.FSupplyID
where 1=1 
AND v1.FTranType=21 AND v1.FCancellation = 0 AND v1.FStatus>0
AND a2.FAreaPS=20302                           --销售范围：购销
AND i.FErpClsID=2                              --物料属性：自制
AND v1.FDate>='2013-01-01' AND  v1.FDate<='2014-05-31'
--AND i.FNumber like '%'+@wldm+'%'
AND o.FNumber in ('01.002','01.144')
group by i.FNumber,i.FName,i.FModel
--group by convert(char(6),v1.FDate,112) ,i.FNumber,i.FName,i.FModel
--order by convert(char(6),v1.FDate,112) ,i.FNumber,i.FName,i.FModel

select b.wldm,b.wlmc,b.wlgg,b.ckmc,b.jldw,sum(kcsl) as kcsl from #data1 a left join #data b on a.wldm=b.wldm group by b.wldm,b.wlmc,b.wlgg,b.ckmc,b.jldw



Create Table #Data(
wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,wlph nvarchar(255) default('')
,ckmc nvarchar(255) default('')
,jldw nvarchar(20) default('')
,kcsl decimal(28,4) default(0)
)

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

Insert Into #Data(wldm,wlmc,wlgg,wlph,ckmc,jldw,kcsl
)
Select t1.FNumber AS FMaterialNumber,t1.FName as FMaterialName,t1.FModel as FMaterialModel,u1.FBatchNo,t2.FName as FStockName,t3.FName as FBUUnitName,ROUND(u1.FQty,t1.FQtydecimal) as FBUQty
From #TempInventory u1
 left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR 
Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
 and t1.FDeleted=0 
 AND t2.FTypeID in (500,20291,20293)
and t2.FItemID <> '4527'             --废品（工废）库
	and t2.FItemID <> '4528'             --可利用库
	and t2.FItemID <> '4739'             --返工返修库
	and t2.FItemID <> '5272'             --料废库
	and t2.FItemID <> '5888'             --封存库
AND t1.FNumber in (
'06.02.2001',
'06.02.2005',
'06.02.2004',
'06.02.2006',
'06.02.2007',
'06.02.2008',
'06.02.2009',
'06.02.2011',
'06.02.2013',
'06.02.2014',
'06.02.2015',
'06.02.2017',
'06.02.2020',
'06.02.2032',
'06.02.2033',
'06.02.2037',
'06.02.2042',
'06.02.2046',
'06.02.2049',
'06.02.2059',
'06.02.2071',
'06.03.2056',
'06.03.2057'
)

Order By t1.FNumber,u1.FBatchNo,u1.FMTONo 





select * from #data

drop table #data

drop table #data1

drop table #TempInventory