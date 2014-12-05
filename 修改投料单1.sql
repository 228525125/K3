
select * from ICSTJGBill a left join ICSTJGBillEntry b on a.FInterID=b.FInterID where FBillNo='STJGOUT001183' and FSourceInterID=0

update b set b.FSourceTranType=85,b.FSourceInterId=29004,b.FSourceBillNo='WORK027512',b.FICMOBillNo='WORK027512',b.FICMOInterID=29004,FPPBomEntryID=1 from ICSTJGBill a left join ICSTJGBillEntry b on a.FInterID=b.FInterID where FBillNo='STJGOUT001183' and FSourceInterID=0

select * from ICMO where FBillNo='WORK027512'

update ICMO set FCheckCommitQty=96,FAuxCheckCommitQty=96 where FBillNo='WORK027512'


select * from PPBOM p1 left join PPBOMEntry p2 on p1.FInterID=p2.FInterID where 1=1 and p1.FBillNo = 'PBOM028123'

update p2 set p2.FQty=1152,p2.FAuxQty=1152,p2.FStockQty=1152,p2.FAuxStockQty=1152 from PPBOM p1 left join PPBOMEntry p2 on p1.FInterID=p2.FInterID where 1=1 and p1.FBillNo = 'PBOM028123'