--drop procedure list_scrw drop procedure list_scrw_count

create procedure list_scrw 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
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
,sfll nvarchar(50) default('')
,rksl decimal(28,2) default(0)      
,rkrq nvarchar(50) default('')  
,sfbf nvarchar(50) default('')  
,aqkc decimal(28,2) default(0)                    
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
,sfll nvarchar(50) default('')
,rksl decimal(28,2) default(0)
,rkrq nvarchar(50) default('')          
,sfbf nvarchar(50) default('')          
,aqkc decimal(28,2) default(0)
)

Insert Into #temp(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,sfll,rksl,rkrq,sfbf,aqkc
)
Select top 20000 case when v1.FStatus=0 then '计划' when v1.FStatus=5 then '确认' when v1.FStatus=1 then '下达' when v1.FStatus=3 then '结案' else '' end as FStatus,v1.FInterID as FInterID,v1.FBillNo as FBillNo,
i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',v1.FGMPBatchNo as 'cpph',mu.FName as 'jldw',v1.FQty as 'jhsl',
Convert(char(10),v1.FPlanCommitDate,111) as 'jhkgsj',Convert(char(10),v1.FPlanFinishDate,111) as 'jhwgsj',case when v1.FWorktypeID=56 then '返工' when v1.FWorktypeID=55 then '普通订单' when v1.FWorktypeID=69 then '流转卡跟踪' end as FType,
Convert(char(10),v1.FCommitDate,111) as 'xdrq',Convert(char(10),v1.FCheckDate,111) as 'djrq',i.FHelpCode as 'cpth',
case when d.FSourceBillNo is null then 'N' else 'Y' end as 'sfll',isnull(e.FQty,0) as 'rksl',isnull(e.FDate,'') as 'rkrq',
case when f.FICMOBillNo is null then 'N' else 'Y' end as 'sfbf',isnull(b.FSecInv,0) as 'aqkc'
from ICMO v1 
LEFT JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (
select u1.FSourceBillNo from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FSourceBillNo
) d on v1.FBillNo=d.FSourceBillNo
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty,MIN(v1.FDate) as FDate from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) e on v1.FBillNo=e.FICMOBillNo and v1.FItemID=e.FItemID
LEFT JOIN (
select u1.FICMOBillNo from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0
where v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) f on v1.FBillNo=f.FICMOBillNo
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FQty like '%'+@query+'%' or v1.FGMPBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,sfll,rksl,rkrq,sfbf,aqkc)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,sfll,rksl,rkrq,sfbf,aqkc)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,jhsl,rksl)
Select '合计',sum(v1.FQty) as 'jhsl',sum(e.FQty) as 'rksl'
from ICMO v1 
LEFT OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (
select u1.FSourceBillNo from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FSourceBillNo
) d on v1.FBillNo=d.FSourceBillNo
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) e on v1.FBillNo=e.FICMOBillNo and v1.FItemID=e.FItemID
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FQty like '%'+@query+'%' or v1.FGMPBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select * from #Data 
end

--count---
create procedure list_scrw_count 
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10),
@status varchar(10),
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
,sfll nvarchar(50) default('')
,rksl decimal(28,2) default(0)      
,rkrq nvarchar(50) default('')  
,sfbf nvarchar(50) default('')  
,aqkc decimal(28,2) default(0)                    
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
,sfll nvarchar(50) default('')
,rksl decimal(28,2) default(0)
,rkrq nvarchar(50) default('')          
,sfbf nvarchar(50) default('')          
,aqkc decimal(28,2) default(0)
)

Insert Into #temp(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,sfll,rksl,rkrq,sfbf,aqkc
)
Select top 20000 case when v1.FStatus=0 then '计划' when v1.FStatus=5 then '确认' when v1.FStatus=1 then '下达' when v1.FStatus=3 then '结案' else '' end as FStatus,v1.FInterID as FInterID,v1.FBillNo as FBillNo,
i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',v1.FGMPBatchNo as 'cpph',mu.FName as 'jldw',v1.FQty as 'jhsl',
Convert(char(10),v1.FPlanCommitDate,111) as 'jhkgsj',Convert(char(10),v1.FPlanFinishDate,111) as 'jhwgsj',case when v1.FWorktypeID=56 then '返工' when v1.FWorktypeID=55 then '普通订单' when v1.FWorktypeID=69 then '流转卡跟踪' end as FType,
Convert(char(10),v1.FCommitDate,111) as 'xdrq',Convert(char(10),v1.FCheckDate,111) as 'djrq',i.FHelpCode as 'cpth',
case when d.FSourceBillNo is null then 'N' else 'Y' end as 'sfll',isnull(e.FQty,0) as 'rksl',isnull(e.FDate,'') as 'rkrq',
case when f.FICMOBillNo is null then 'N' else 'Y' end as 'sfbf',isnull(b.FSecInv,0) as 'aqkc'
from ICMO v1 
LEFT JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (
select u1.FSourceBillNo from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FSourceBillNo
) d on v1.FBillNo=d.FSourceBillNo
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty,MIN(v1.FDate) as FDate from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) e on v1.FBillNo=e.FICMOBillNo and v1.FItemID=e.FItemID
LEFT JOIN (
select u1.FICMOBillNo from ICItemScrap v1 
INNER JOIN ICItemScrapEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0
where v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) f on v1.FBillNo=f.FICMOBillNo
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FQty like '%'+@query+'%' or v1.FGMPBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
order by v1.FBillNo

if @orderby='null'
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,sfll,rksl,rkrq,sfbf,aqkc)select * from #temp')
else
exec('Insert Into #Data(FStatus,FInterID,FBillNo,cpdm,cpmc,cpgg,cpph,jldw,jhsl,jhkgsj,jhwgsj,FType,xdrq,djrq,cpth,sfll,rksl,rkrq,sfbf,aqkc)select * from #temp order by '+ @orderby+' '+ @ordertype)

Insert Into  #Data(FStatus,jhsl,rksl)
Select '合计',sum(v1.FQty) as 'jhsl',sum(e.FQty) as 'rksl'
from ICMO v1 
LEFT OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_ICItemBase b on i.FItemID=b.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (
select u1.FSourceBillNo from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0
where v1.FTranType=24 and v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FSourceBillNo
) d on v1.FBillNo=d.FSourceBillNo
LEFT JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0
group by u1.FICMOBillNo,u1.FItemID
) e on v1.FBillNo=e.FICMOBillNo and v1.FItemID=e.FItemID
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FCheckDate>=@begindate AND  v1.FCheckDate<=@enddate
AND (FBillNo like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%'
or i.FModel like '%'+@query+'%' or v1.FQty like '%'+@query+'%' or v1.FGMPBatchNo like '%'+@query+'%')
AND v1.FStatus like '%'+@status+'%'
select count(*) from #Data 
end

execute list_scrw 'WORK006286','2010-01-01','2011-11-30','','null',''

execute list_scrw_count '','2010-01-01','2011-08-31','','null',''


execute list_scrw 'WORK006286','2000-01-01','2099-12-31','1','null','null'







select * from t_ICItem

select * from ICMO where FBillNo='WORK023777'

update ICMO set FGMPBatchNo='13D28' where FBillNo='WORK023777'


SELECT * FROM ICShop_FlowCard where FSourceBillNo='WORK023777'

update ICShop_FlowCard set FText1='4A616' where FSourceBillNo='work024751'



SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select top 20000 v1.FStatus as FStatus,v1.FTranType as FTranType,v1.FInterID as FInterID,v1.FBillNo as FBillNo,case when v1.FCancellation=1 then 'Y' else '' end as 
FCancellation,CASE  V1.FSuspend WHEN 0 THEN '' ELSE 'Y' END as FSuspend,v1.FType as FICMOType2,v1.FWorktypeID as FWorkTypeID2, 0 As FBOSCloseFlag from ICMO v1 LEFT 
OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
 where 1=1 
AND  (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
order by FBillNo DESC


--5：确认
--1：下达
--0：计划
--3：结案


select v1.FPlanFinishDate from ICMO v1


--update ICMO set FCardClosed=1059 where FBillNo in ('WORK020870','WORK020869','WORK020868')       --修改生成任务单-流转卡关联关闭 1059为N 1058为Y

select * from ICMO where FBillNo in ('WORK030709')

--update ICMO set FCardClosed=1059 where FBillNo in ('WORK024670')

--UPDATE ICMO SET FPlanFinishDate='2013-02-20' where FBillNo='WORK020868'

--UPDATE ICMO SET FPlanCommitDate='2013-02-18',FPlanFinishDate='2013-02-20',FCommitDate='2013-02-18',FCheckDate='2013-02-18',FConfirmDate='2013-02-18' where FBillNo='WORK020868'



select FMrpClosed,FClosed,* from ICMO where FBillNo in ('work024507','work024508')

--UPDATE ICMO SET FCardClosed=1059 where FBillNo in ('work024507','work024508')      --批次号和流转卡关联关闭

select FGMPBatchNo,* from ICMO where FBillNo='WORK033920'

--UPDATE ICMO SET FGMPBatchNo='Q1406' where FBillNo='WORK033920'


----反结案----
select FStatus,FCheckerID,FMrpClosed,FHandworkClose,FCloseDate,* from ICMO where FBillNo='WORK034295'

update ICMO set FStatus=1,FCheckerID=null,FMrpClosed=0,FHandworkClose=0,FCloseDate=null
where FBillNo='WORK033298'






