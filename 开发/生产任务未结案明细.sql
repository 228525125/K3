--drop procedure list_scrw_wja drop procedure list_scrw_wja_count

create procedure list_scrw_wja 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpph nvarchar(255) default('')               
,jldw nvarchar(20) default('')           
,jhsl decimal(28,2) default(0)          
,jhkgsj nvarchar(50) default('')
,jhwgsj nvarchar(50) default('')
,FType nvarchar(20) default('')
,xdrq nvarchar(50) default('')
,djrq nvarchar(50) default('')
,cpth nvarchar(50) default('')           
,rksl decimal(28,2) default(0)                  
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,jhsl decimal(28,2) default(0)          
,jhkgsj nvarchar(50) default('')
,jhwgsj nvarchar(50) default('')
,FType nvarchar(20) default('')
,xdrq nvarchar(50) default('')
,djrq nvarchar(50) default('')
,cpth nvarchar(50) default('')
,rksl decimal(28,2) default(0)          
)

Insert Into #temp(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,rksl
)
Select top 20000 case when v1.FStatus=0 then '计划' when v1.FStatus=5 then '确认' when v1.FStatus=1 then '下达' when v1.FStatus=3 then '结案' else '' end as FStatus,v1.FInterID as FInterID,v1.FBillNo as FBillNo,
i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',v1.FGMPBatchNo as 'cpph',mu.FName as 'jldw',v1.FQty as 'jhsl',
Convert(char(10),v1.FPlanCommitDate,120) as 'jhkgsj',Convert(char(10),v1.FPlanFinishDate,120) as 'jhwgsj',case when v1.FWorktypeID=56 then '返工' when v1.FWorktypeID=55 then '普通订单' when v1.FWorktypeID=69 then '流转卡跟踪' end as FType,
Convert(char(10),v1.FCommitDate,120) as 'xdrq',Convert(char(10),v1.FCheckDate,120) as 'djrq',i.FHelpCode as 'cpth',v1.FAuxStockQty as 'rksl'
from ICMO v1 
LEFT JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
where 1=1
AND v1.FCancellation = 0
--AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FQty like '%'+@query+'%' or v1.FGMPBatchNo like '%'+@query+'%')
AND v1.FStatus=1 
--AND v1.FAuxStockQty/v1.FQty>0.8  --入库数量大于计划数量的80%
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,rksl)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,rksl)select * from #temp order by '+ @orderby+' '+ @ordertype)

select * from #Data 
end

--count--
create procedure list_scrw_wja_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@orderby nvarchar(100),
@ordertype nvarchar(4)
as 
begin
SET NOCOUNT ON 
create table #temp(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpph nvarchar(255) default('')               
,jldw nvarchar(20) default('')           
,jhsl decimal(28,2) default(0)          
,jhkgsj nvarchar(50) default('')
,jhwgsj nvarchar(50) default('')
,FType nvarchar(20) default('')
,xdrq nvarchar(50) default('')
,djrq nvarchar(50) default('')
,cpth nvarchar(50) default('')                   
)

create table #Data(
FStatus nvarchar(20) default('')
,FInterID nvarchar(20) default('')
,FBillNo nvarchar(20) default('')
,cpdm nvarchar(30) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')           
,cpph nvarchar(255) default('')           
,jldw nvarchar(20) default('')           
,jhsl decimal(28,2) default(0)          
,jhkgsj nvarchar(50) default('')
,jhwgsj nvarchar(50) default('')
,FType nvarchar(20) default('')
,xdrq nvarchar(50) default('')
,djrq nvarchar(50) default('')
,cpth nvarchar(50) default('')
)

Insert Into #temp(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth
)
Select top 20000 case when v1.FStatus=0 then '计划' when v1.FStatus=5 then '确认' when v1.FStatus=1 then '下达' when v1.FStatus=3 then '结案' else '' end as FStatus,v1.FInterID as FInterID,v1.FBillNo as FBillNo,
i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',v1.FGMPBatchNo as 'cpph',mu.FName as 'jldw',v1.FQty as 'jhsl',
Convert(char(10),v1.FPlanCommitDate,111) as 'jhkgsj',Convert(char(10),v1.FPlanFinishDate,111) as 'jhwgsj',case when v1.FWorktypeID=56 then '返工' when v1.FWorktypeID=55 then '普通订单' when v1.FWorktypeID=69 then '流转卡跟踪' end as FType,
Convert(char(10),v1.FCommitDate,111) as 'xdrq',Convert(char(10),v1.FCheckDate,111) as 'djrq',i.FHelpCode as 'cpth'
from ICMO v1 
LEFT JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
where 1=1
AND v1.FCancellation = 0
--AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (v1.FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FQty like '%'+@query+'%' or v1.FGMPBatchNo like '%'+@query+'%')
AND v1.FStatus=1 
--AND v1.FAuxStockQty/v1.FQty>0.8
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth)select * from #temp order by '+ @orderby+' '+ @ordertype)

select count(*) from #Data 
end


execute list_scrw_wja '','2012-09-01','2012-09-29','null','null'


select FAuxQtyForItem,FAuxQtyScrap,* from ICMO where FBillNo='WORK012376'
