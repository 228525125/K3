-----修改投料单默认仓库------
select * from PPBOM a INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0 where FBillNo='pbom027413' and b.FStockID=342

update b set b.FStockID=340 from PPBOM a INNER JOIN PPBOMEntry b ON a.FInterID = b.FInterID  AND b.FInterID<>0 where FBillNo='pbom027413' and b.FStockID=342

-----修改BOM默认仓库------
select b.FStockID,a.FBOMNumber,c.FNumber,FName,b.* 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
where c.FNumber like '06.04.0083' 
and b.FStockID<>342

UPDATE b set b.FStockID=340 
from ICBOM a 
left join ICBOMCHILD b on a.FInterID=b.FInterID
left join t_ICItem c on b.FItemID=c.FItemID
where c.FNumber like '06.04.0083' 
and b.FStockID<>342