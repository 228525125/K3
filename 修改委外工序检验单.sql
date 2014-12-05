select * from ICQCBill where 1=1 AND FBillNo='SIPQC001497' AND (FTranType=715 AND (FCancellation = 0))

update ICQCBill set FNotPassQty=0,FPassQty=14,FBasePassQty=14 where 1=1 AND FBillNo='SIPQC001497' AND (FTranType=715 AND (FCancellation = 0))