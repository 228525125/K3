select u1.* from ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='wwjs003680'

update u1 set u1.FUnitPrice=21.15,u1.FBaseUnitPrice=21.15
from ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='wwjs003680'

update u1 set u1.FAmount=u1.FPassQty*u1.FUnitPrice
from ICShop_SubcIn v1 
INNER JOIN ICShop_SubcInEntry u1 ON v1.FInterID=u1.FInterID
where v1.FBillNo='wwjs003680'


