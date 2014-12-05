--drop procedure report_zzpmx

create procedure report_zzpmx
@query nvarchar(255)
as 
begin
SET NOCOUNT ON 

create table #Data(
djbh nvarchar(255) default('')
,cpdm nvarchar(255) default('')          
,cpmc nvarchar(255) default('')           
,cpgg nvarchar(255) default('')       
,cpth nvarchar(255) default('')               
,jldw nvarchar(255) default('')                     
,jhsl decimal(28,2) default(0)     
,rksl decimal(28,2) default(0)     
,wldm nvarchar(255) default('')           
,wlmc nvarchar(255) default('')           
,wlgg nvarchar(255) default('')           
,dw nvarchar(255) default('')           
,tlsl decimal(28,2) default(0)           
,llsl decimal(28,2) default(0)          
,blsl decimal(28,2) default(0)   
,bfsl decimal(28,2) default(0)         
,zzpsl decimal(28,2) default(0)         
)

Insert into #Data(djbh,cpdm,cpmc,cpgg,cpth,jldw,jhsl,rksl,wldm,wlmc,wlgg,dw,tlsl,llsl,blsl,bfsl,zzpsl
)
select a.FBillNo as 'djbh',i1.FNumber as 'cpdm',i1.FName as 'cpmc',i1.FModel as 'cpgg',i1.FHelpCode as 'cpth',mu1.FName as 'jldw',a.FCommitQty as 'jhsl',isnull(g.FQty,0) as 'rksl',i2.FNumber as 'wldm',i2.FName as 'wlmc',i2.FModel as 'wlgg',mu2.FName as 'dw',c.FAuxQtyPick as 'tlsl',isnull(c.FAuxStockQty,0) as 'llsl',isnull(c.FAuxQtySupply,0) as 'blsl',isnull(c.FDiscardAuxQty,0) as 'bfsl',(isnull(c.FAuxStockQty,0)-((c.FAuxQtyPick/a.FCommitQty)*isnull(g.FQty,0)) + isnull(c.FAuxQtySupply,0) - isnull(c.FDiscardAuxQty,0))/* /(c.FAuxQtyPick/a.FCommitQty)*/ as 'zzpsl'  --zzpsl为材料数量
from ICMO a                                                                                                                                                                                                                                                                                                                                                                                          --       （ 领料数量       -               理论消耗                          +           补料数量         -     报废数量）                /        单件消耗                
LEFT JOIN PPBOM b ON   b.FICMOInterID = a.FInterID  AND a.FInterID<>0
LEFT JOIN PPBOMEntry c ON c.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i1 on a.FItemID=i1.FItemID
LEFT JOIN t_MeasureUnit mu1 on mu1.FItemID=a.FUnitID
LEFT JOIN t_ICItem i2 on c.FItemID=i2.FItemID
LEFT JOIN t_MeasureUnit mu2 on mu2.FItemID=c.FUnitID
INNER JOIN (
select u1.FICMOBillNo,u1.FItemID,sum(u1.FQty) as FQty from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FTranType=2 AND v1.FCancellation = 0 AND v1.FCheckerID>0 
group by u1.FICMOBillNo,u1.FItemID
) g on a.FBillNo=g.FICMOBillNo and a.FItemID=g.FItemID
where 1=1
AND a.FCheckDate>='2012-01-01' --AND  a.FCheckDate<='2012-08-31'
and a.FStatus=1 --状态为下达
order by a.FBillNo

if @query=''
select * from #Data
else
select * from #Data where cpdm like '%'+@query+'%' or wldm like '%'+@query+'%'
end

execute report_zzpmx ''
