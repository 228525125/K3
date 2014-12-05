select FICMOInterID,* from ICQCBill where FBillNo in ('FQC003557','FQC003599','FQC005402','FQC011541','FQC011770','FQC011964','FQC011969','FQC011970','FQC012047','FQC013304')

select * from ICMO a 
left join ICQCBill b on a.FInterID=b.FICMOInterID
where b.FBillNo in ('FQC003557','FQC003599','FQC005402','FQC011541','FQC011770','FQC011964','FQC011969','FQC011970','FQC012047','FQC013304')

update a set a.FStatus=3
from ICMO a 
left join ICQCBill b on a.FInterID=b.FICMOInterID
where b.FBillNo in ('FQC003557','FQC003599','FQC005402','FQC011541','FQC011770','FQC011964','FQC011969','FQC011970','FQC012047','FQC013304')

select * from ICMO where FCheckDate<='2012-01-01' and FStatus=1

update ICMO set FStatus=3 where FCheckDate<='2012-01-01' and FStatus=1
