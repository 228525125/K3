
select V1.* from ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('wwjs003775','wwjs003776','wwjs003777','wwjs003778')

update v1 set v1.FSupplierID=15753 from ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('wwjs003782')


select V1.* from ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('wwzc003268','wwzc003269','wwzc003270','wwzc003271','wwzc003280')

update v1 set v1.FSupplierID=15753 from ICShop_SubcOut v1 
INNER JOIN ICShop_SubcOutEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo in ('wwzc003268','wwzc003269','wwzc003270','wwzc003271','wwzc003280')


select FItemID,FNumber,FName,* from t_Supplier where FNumber = '01.160'


15753
