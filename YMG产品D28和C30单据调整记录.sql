select * from ICStockBill
where FBillNo in ('XOUT007519','XOUT007520','XOUT007521','XOUT007522','CIN006914','CIN006915','CIN006916','CIN006917')   --需要删除的


update ICStockBill set FDate='2013-08-28',FCheckDate='2013-08-28'
where FBillNo in ('XOUT007519','XOUT007520','XOUT007521','XOUT007522','CIN006914','CIN006915','CIN006916','CIN006917')

--需要修改日期
select * from ICStockBill where FBillNo in ('CIN006525','CIN006527','CIN006574','CIN006648','CIN006648','XOUT007040','XOUT007303','XOUT007016A','XOUT007098A')


2013-06-28 00:00:00.000	CIN006525
2013-06-28 00:00:00.000	CIN006527
2013-07-03 00:00:00.000	CIN006574
2013-07-11 00:00:00.000	CIN006648
2013-06-26 00:00:00.000	XOUT007016A
2013-06-28 00:00:00.000	XOUT007040
2013-07-05 00:00:00.000	XOUT007098A
2013-07-27 00:00:00.000	XOUT007303

update ICStockBill set FDate='2013-06-26',FCheckDate='2013-06-26' where FBillNo in ('XOUT007016A')
update ICStockBill set FDate='2013-06-28',FCheckDate='2013-06-28' where FBillNo in ('CIN006525','CIN006527','XOUT007040')
update ICStockBill set FDate='2013-07-03',FCheckDate='2013-07-03' where FBillNo in ('CIN006574')
update ICStockBill set FDate='2013-07-11',FCheckDate='2013-07-11' where FBillNo in ('CIN006648')
update ICStockBill set FDate='2013-07-05',FCheckDate='2013-07-05' where FBillNo in ('XOUT007098A')
update ICStockBill set FDate='2013-07-27',FCheckDate='2013-07-27' where FBillNo in ('XOUT007303')


select * from ICStockBill where FBillNo IN ('XOUT007524')

update ICStockBill set FDate='2013-08-27',FCheckDate='2013-08-27' where FBillNo in ('XOUT007524') --需要删除的

select * from ICStockBill where FBillNo IN ('CIN007014')

update ICStockBill set FDate='2013-08-06',FCheckDate='2013-08-06',FMultiCheckDate1='2013-08-06',FMultiCheckDate2='2013-08-06' where FBillNo IN ('CIN007014')  --需要删除的

select * from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where b.FICMOBillNo='WORK023777000'      --修改任务单关联

update b set b.FICMOBillNo='WORK023777',b.FICMOInterID=24907 from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where b.FICMOBillNo='WORK023777000'   --修改任务单关联