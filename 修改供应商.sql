select FSupplyID,* from ICStockBill where FBillNo='WIN006843'

update ICStockBill set FSupplyID=271 where FBillNo='WIN007016'

select * from POInstock v1 where FBillNo='IQCR000632'

update POInstock set FSupplyID=8629 where FBillNo='IQCR000632'

select * from POOrder where FBillNo LIKE 'JH-1112-26'

UPDATE POOrder SET FSupplyID=8629 where FBillNo LIKE 'JH-1112-26'


select * from t_Supplier where FNumber = '01.009'

select * from t_Supplier where FNumber = '05.007'

271

