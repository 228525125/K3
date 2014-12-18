--销售订单
--drop procedure report_xsddfbtj_yf

create procedure report_xsddfbtj_yf
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
select convert(char(6),v1.FDate,112) as FDate,i.FNumber,i.FName,i.FModel,i.FHelpCode,sum(u1.FQty) as FQty,max(u1.FPriceDiscount) as FPrice 
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization o on o.FItemID=v1.FCustID
where 1=1 
AND v1.FTranType=81 AND v1.FCancellation = 0 AND v1.FStatus>0
AND v1.FAreaPS=20302                           --销售范围：购销
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

execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','01.001'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','01.144'

execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','02.001'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','02.007'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','61.001'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','61.002'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','61.003'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','61.004'

execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','16.02'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','16.03'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','01.003'
execute report_xsddfbtj_yf '2014-01-01','2014-12-31','','61.005'






select * from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD008201'


select convert(char(6),v1.FDate,112) as FDate,i.FNumber,i.FName,i.FModel,i.FHelpCode,sum(u1.FQty) as FQty,max(u1.FPriceDiscount) as FPrice 
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_Organization o on o.FItemID=v1.FCustID
where 1=1 
AND v1.FTranType=81 AND v1.FCancellation = 0 AND v1.FStatus>0
AND v1.FAreaPS=20302                           --销售范围：购销
AND i.FErpClsID=2                              --物料属性：自制
AND v1.FDate>='2014-11-01' AND  v1.FDate<='2014-12-31'
AND o.FNumber like '%02.001%'
group by convert(char(6),v1.FDate,112),i.FNumber,i.FName,i.FModel,i.FHelpCode
order by convert(char(6),v1.FDate,112)



select * from t_Organization
