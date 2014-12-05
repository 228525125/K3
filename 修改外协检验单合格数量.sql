select * FROM ICQCBill
where 1=1
AND (FTranType=715 AND FCancellation = 0)
AND FBillNo in ('SIPQC006968')


update ICQCBill set FPassQty=2,FNotPassQty=0,FBasePassQty=2 where 1=1 AND (FTranType=715 AND FCancellation = 0) and FBillNo='SIPQC006968'