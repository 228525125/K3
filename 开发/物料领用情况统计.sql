----
--drop procedure list_wglltj

create procedure list_wglltj
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 

create table #temp(
gys nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,wlth nvarchar(255) default('')
,wlpc nvarchar(255) default('')
,wldw nvarchar(255) default('')
,rkrq nvarchar(255) default('')
,rksl decimal(28,2) default(0)
,llrq nvarchar(255) default('')
,llsl decimal(28,2) default(0)          
,lfsl decimal(28,2) default(0)          
)

Insert Into #temp(gys,wldm,wlmc,wlgg,wlth,wlpc,wldw,rkrq,rksl,llrq,llsl,lfsl
)
Select s.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,u1.FBatchNo,mu.FName,convert(char(10),MIN(v1.FDate),120) as FDate,SUM(u1.FQty) as FQty,convert(char(10),MAX(ll.FDate),120),MAX(ll.FQty),MAX(f.FQty)
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0  
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT join t_Supplier s on v1.FSupplyID=s.FItemID 
LEFT JOIN (
select u1.FItemID,u1.FBatchNo,MAX(v1.FDate) as FDate,SUM(u1.FQty) as FQty
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1
AND (v1.FTranType=24 AND v1.FCancellation = 0)
AND v1.FROB=1
group by u1.FItemID,u1.FBatchNo
) ll on ll.FItemID=u1.FItemID and ll.FBatchNo=u1.FBatchNo
LEFT JOIN (select b.FItemID,b.FBatchNo,sum(b.FQty) as FQty from ICStockBill a inner join ICStockBillEntry b on a.FInterID=b.FInterID where a.FTranType=24 AND a.FCancellation = 0 AND a.FStatus = 1 AND a.FROB=-1 and b.FSCStockID=5272 group by b.FItemID,b.FBatchNo) f on f.FItemID=u1.FItemID and f.FBatchNo=u1.FBatchNo
where 1=1 
AND v1.FTranType=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND v1.FStatus=1 
AND (s.FName like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or i.FModel like '%'+@query+'%' or i.FHelpCode like '%'+@query+'%')
group by s.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName,u1.FBatchNo 
order by s.FName,i.FNumber

select * from #temp

end


--drop procedure list_stlltj

create procedure list_stlltj
@query varchar(50),
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 

create table #temp(
gys nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,wlth nvarchar(255) default('')
,wlpc nvarchar(255) default('')
,wldw nvarchar(255) default('')
,rkrq nvarchar(255) default('')
,rksl decimal(28,2) default(0)
,llrq nvarchar(255) default('')
,llsl decimal(28,2) default(0)
,lfsl decimal(28,2) default(0)                    
)

Insert Into #temp(gys,wldm,wlmc,wlgg,wlth,wlpc,wldw,rkrq,rksl,llrq,llsl,lfsl
)
select s.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,u1.FBatchNo,mu.FName,convert(char(10),MIN(v1.FDate),120) as FDate,SUM(u1.FQty) as FQty,convert(char(10),MAX(ll.FDate),120),MAX(ll.FQty),MAX(k.FQty)
from ICSTJGBill v1 
INNER JOIN ICSTJGBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=u1.FUnitID 
LEFT join t_Organization s on v1.FCustID=s.FItemID
LEFT JOIN (
select u1.FItemID,u1.FBatchNo,MAX(v1.FDate) as FDate,SUM(u1.FQty) as FQty
from ICSTJGBill v1 
INNER JOIN ICSTJGBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where 1=1
AND (v1.FTranType=137 AND v1.FCancellation = 0)
AND v1.FROB=1
group by u1.FItemID,u1.FBatchNo
) ll on ll.FItemID=u1.FItemID and ll.FBatchNo=u1.FBatchNo
LEFT JOIN (select b.FItemID,b.FBatchNo,sum(b.FQty) as FQty from ICSTJGBill a inner join ICSTJGBillEntry b on a.FInterID=b.FInterID where a.FTranType=137 AND a.FCancellation = 0 AND a.FStatus=1 AND a.FROB=-1 and b.FSCStockID=5766 group by b.FItemID,b.FBatchNo) k on k.FItemID=u1.FItemID and k.FBatchNo=u1.FBatchNo
WHERE 1=1
AND v1.FTranType=92 AND v1.FROB=1 AND  v1.FCancellation = 0 
AND v1.FDate>=@begindate AND  v1.FDate<=@enddate 
AND v1.FStatus=1 
AND (s.FName like '%'+@query+'%' or i.FNumber like '%'+@query+'%' or i.FName like '%'+@query+'%' or i.FModel like '%'+@query+'%' or i.FHelpCode like '%'+@query+'%')
group by s.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,u1.FBatchNo,mu.FName
order by s.FName,i.FNumber

select * from #temp

end


execute list_wglltj '','2015-01-01','2015-01-31'

execute list_stlltj 'Î÷°²','2015-01-01','2015-01-31'


select FROB from ICStockBill