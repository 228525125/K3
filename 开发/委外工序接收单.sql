--drop procedure list_wwjs drop procedure list_wwjs_count

create procedure list_wwjs 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,jssl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,jssl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
,FEntryID nvarchar(20) default('')
)

Insert Into #temp(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,jssl,hgsl,gfsl,lfsl,hsdj,hsje,wlph,jgdw,FEntryID
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,
u1.FICMOBillNo as FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FReceiveQty as 'jssl',u1.FPassQty as 'hgsl',u1.FScrapQty as 'gfsl',u1.FScrapItemQty as 'lfsl',u1.FUnitPrice as 'hsdj',u1.FAmount as 'hsje',u1.FBatchNo as 'wlph',t4.FName as 'jgdw',u1.FEntryID
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' or u1.FSubcOutNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,jssl,hgsl,gfsl,lfsl,hsdj,hsje,wlph,jgdw,FEntryID)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,jssl,hgsl,gfsl,lfsl,hsdj,hsje,wlph,jgdw,FEntryID)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,hgsl)
Select '合计',sum(u1.FPassQty) as 'hgsl'
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' or u1.FSubcOutNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count--
create procedure list_wwjs_count 
@query nvarchar(255),
@begindate nvarchar(255),
@enddate nvarchar(255),
@status nvarchar(255),
@orderby nvarchar(255),
@ordertype nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,jssl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,FSourceBillNo nvarchar(20) default('')
,FDate nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,jldw nvarchar(20) default('')           
,jssl decimal(28,2) default(0)          
,hgsl decimal(28,2) default(0)
,gfsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)
,hsdj decimal(28,2) default(0)
,hsje decimal(28,2) default(0)
,wlph nvarchar(20) default('')
,jgdw nvarchar(20) default('')
)

Insert Into #temp(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,jssl,hgsl,gfsl,lfsl,hsdj,hsje,wlph,jgdw
)
Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FStatus,v1.FInterID,v1.FBillNo,
u1.FSubcOutNo as FSourceBillNo,convert(char(10),v1.FDate,120) as FDate,i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',mu.FName as 'jldw',
u1.FReceiveQty as 'jssl',u1.FPassQty as 'hgsl',u1.FScrapQty as 'gfsl',u1.FScrapItemQty as 'lfsl',u1.FUnitPrice as 'hsdj',u1.FAmount as 'hsje',u1.FBatchNo as 'wlph',t4.FName as 'jgdw'
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' or u1.FSubcOutNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,jssl,hgsl,gfsl,lfsl,hsdj,hsje,wlph,jgdw)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,FSourceBillNo,FDate,cpdm,cpmc,cpgg,jldw,jssl,hgsl,gfsl,lfsl,hsdj,hsje,wlph,jgdw)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,hgsl)
Select '合计',sum(u1.FPassQty) as 'hgsl'
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
where 1=1 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or u1.FICMOBillNo like '%'+@query+'%' or u1.FOrderBillNo like '%'+@query+'%' or u1.FSubcOutNo like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or u1.FBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end



execute list_wwjs '','2013-01-01','2014-04-30','0','null',''

execute list_wwjs_count '','2013-05-01','2013-06-30','0','null',''


execute list_wwjs_count 'WORK011866','2000-01-01','2099-12-31','','null','null'




select FReceiveQty,FPassQty,FBasePassQty,FOperReceiveQty,FOperPassQty,FAmount,u1.* FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='WWJS002420'



Select top 20000 case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as '状态',v1.FBillNo as '单据编号',
FSubcOutNo as '转出单号',u1.FICMOBillNo as '任务单',convert(char(10),v1.FDate,120) as '日期',i.FNumber as '代码',i.FName as '名称',i.FModel as '规格',mu.FName as '计量单位',
u1.FReceiveQty as '接收数量',u1.FPassQty as '合格数量',u1.FUnitPrice as '单价',u1.FAmount as '金额',u1.FBatchNo as '批号',t4.FName as '加工单位',zc.FNOTE as '转出单备注'
FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select v1.FBillNo,u1.FEntryID,FNOTE FROM  ICShop_SubcOut v1 INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID group by v1.FBillNo,u1.FEntryID,FNOTE) zc on u1.FSubcOutNo=zc.FBillNo and u1.FSubcOutEntryID=zc.FEntryID
where 1=1 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 

select * from ICShop_SubcIn where FInterID=2047


update u1 set u1.FText=ISnull(u1.FText,'')+' <转出单备注：'+zc.FNOTE+'>' FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_supplier t4 ON v1.FSupplierID = t4.FItemID   AND t4.FItemID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT JOIN (select v1.FBillNo,u1.FEntryID,FNOTE FROM  ICShop_SubcOut v1 INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID group by v1.FBillNo,u1.FEntryID,FNOTE) zc on u1.FSubcOutNo=zc.FBillNo and u1.FSubcOutEntryID=zc.FEntryID
where 1=1 
and zc.FNOTE is not null and zc.FNOTE <> ''


select * from ICShop_SubcInEntry where FInterID=2047

select * FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where 






select * FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='WWJS004100'
and FEntryID=8450

update u1 set u1.FPassQty=504,u1.FBasePassQty=504,u1.FOperPassQty=504,u1.FInvoiceRelQty=504,u1.FInvoiceRelBaseQty=504,FAllHookQTY=504 FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='WWJS004100'
and FEntryID=8450


update u1 set FReceiveQty=504,FOperReceiveQty=504 FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='WWJS004100'
and FEntryID=8450



select FOperTranOutQty,* FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('WWZC003547')


update u1 set u1.FReceiptQty=504 FROM  ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('WWZC003547')


504.0000000000


update v1 set v1.FSupplierID=15753 FROM  ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='wwjs003760'