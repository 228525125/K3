--销售出库
--drop procedure report_xsckfbtj_yf

create procedure report_xsckfbtj_yf
@begin nvarchar(255),
@end nvarchar(255),
@wldm nvarchar(255),
@wldw nvarchar(255)
as
begin
SET NOCOUNT ON 
create table #tempcc(
FDate nvarchar(20) default('')
,FNumber nvarchar(30) default('')          
,FName nvarchar(255) default('')           
,FModel nvarchar(255) default('')       
,FHelpCode nvarchar(20) default('')           
,FQty decimal(28,2) default(0)
,FPrice decimal(28,2) default(0)
)

Insert Into #tempcc(FDate,FNumber,FName,FModel,FHelpCode,FQty,FPrice
)
select convert(char(6),v1.FDate,112) as FDate,i.FNumber,i.FName,i.FModel,i.FHelpCode,sum(u1.FQty) as FQty,max(u1.FConsignPrice) as FPrice 
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
group by convert(char(6),v1.FDate,112),i.FNumber,i.FName,i.FModel,i.FHelpCode
order by convert(char(6),v1.FDate,112)

declare @sql varchar(4000)
set @sql = 'select FNumber, FName, FModel, FHelpCode ' 
select 
@sql = @sql + ' , ISNULL(sum(case FDate when '''+FDate+''' then FQty end),0) as ['+FDate+'] , ISNULL(max(case FDate when '''+FDate+''' then FPrice end),0) as ['+FDate+']'
from (select distinct FDate from #tempcc) as a
set @sql = 
@sql + ' from #tempcc group by FNumber, FName, FModel, FHelpCode '
exec(@sql)

end

execute report_xsckfbtj_yf '2014-01-01','2014-03-31','',''
execute report_xsckfbtj_yf '2015-01-01','2015-03-31','',''








create table #tempcc(
FDate nvarchar(20) default('')
,FNumber nvarchar(30) default('')          
,FName nvarchar(255) default('')           
,FModel nvarchar(255) default('')       
,FHelpCode nvarchar(20) default('')           
,FQty decimal(28,2) default(0)
)

Insert Into #tempcc(FDate,FNumber,FName,FModel,FHelpCode,FQty
)
select convert(char(6),v1.FDate,112) as FDate,i.FNumber,i.FName,i.FModel,i.FHelpCode,sum(u1.FQty) as FQty,max(u1.FConsignPrice) as FPrice 
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
AND v1.FDate>='2014-09-01' AND  v1.FDate<='2014-11-30'
--AND i.FNumber like '%'+@wldm+'%'
AND o.FNumber like '%01.001%'
group by convert(char(6),v1.FDate,112),i.FNumber,i.FName,i.FModel,i.FHelpCode
order by convert(char(6),v1.FDate,112)

declare @sql varchar(4000)
set @sql = 'select FNumber, FName, FModel, FHelpCode ' 
select 
@sql = @sql + ' , ISNULL(sum(case FDate when '''+FDate+''' then FQty end),0) 
['+FDate+']'
from (select distinct FDate from #tempcc) as a
set @sql = 
@sql + ' from #tempcc group by FNumber, FName, FModel, FHelpCode '
exec(@sql)

drop table #tempcc



select FNumber, FName, FModel, FHelpCode  , 
ISNULL(sum(case FDate when '201409' then FQty end),0),   [201409] , 
ISNULL(sum(case FDate when '201410' then FQty end),0),   [201410] , 
ISNULL(sum(case FDate when '201411' then FQty end),0),   [201411] , 
ISNULL(s





