
select a.FNotPassQty,a.FAuxCommitQty,a.FCommitQty,a.FBasePassQty,
b.FQtyPass,b.FAuxQtyPass,b.FNotPassQty,b.FAuxNotPassQty,c.FQtyPass,c.FAuxQtyPass,
a.* from ICQCBill a 
left join QMICMOCKRequestEntry b on a.FInStockInterID=b.FInterID
left join ICMO c on a.FICMOInterID=c.FInterID
 where a.FBillNo='FQC031966'

update ICQCBill set FNotPassQty=0,FPassQty=80,FBasePassQty=80 where FBillNo='FQC031966'

update QMICMOCKRequestEntry set FQtyPass=80,FAuxQtyPass=80,FNotPassQty=0,FAuxNotPassQty=0 where FInterID=32854

update ICMO set FQtyPass=80,FAuxQtyPass=80 where FInterID=26731

select * from QMICMOCKRequestEntry where FInterID=32854

select * from ICMO where FInterID=26731