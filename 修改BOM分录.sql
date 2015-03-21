select b.FStockID,a.FBOMNumber,c.FNumber,FName,b.* 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
where c.FNumber = '06.07.0088' 
and b.FStockID<>342

UPDATE b set b.FStockID=340 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
where 1=1
and c.FNumber like '06.04.0083' 
and b.FStockID<>342

07.08.0003

select * from ICBOMCHILD

select * from t_stock 342

--update b set b.FItemID=2086 from ICBOM a left join ICBOMCHILD b on a.FInterID=b.FInterID where FBOMNumber = 'BOM001316'

select FItemID,* from t_ICItem where FNumber='07.08.0002'

--查询包含指定物料代码的BOM
select a.* from ICBOM a left join ICBOMCHILD b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where c.FNumber='06.06.0018'

select * from t_ICItem where FItemID=5121



----------导出BOM-----------
select c.FNumber,c.FName,c.FModel,c.FHelpCode,a.FBOMNumber,d.FNumber,d.FName,d.FModel,d.FHelpCode,mu.FName,b.FQty 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on a.FItemID=c.FItemID
left join t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID
where c.FName like '%阀组%' 
order by c.FNumber,a.FBOMNumber,d.FNumber
