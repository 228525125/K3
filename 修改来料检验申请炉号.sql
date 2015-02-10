SELECT i.FNumber,u1.FEntrySelfT0241,FBatchNo,u1.FInterID,u1.FEntryID,v1.*,u1.* from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where 1=1 
AND v1.FBillNo='IQCR001945'
--and FBatchNo='14D58'
and FEntryID in (1)
--and FBatchNo IN ('13L01','13L05','13L03','13L07','13L02') AND FDate>='2013-09-01' 
--AND FQty in (90)

11F322
13A0911-2220


select FEntrySelfT0241,* from POInstockEntry where 1=1 AND FInterID IN (7660) and FEntryID IN (1)

select FHeadSelft1256,* from ICQCBill v1 where 1=1 and FTranType=711 and FInStockInterID IN (7660) and FSerialID IN (1) 

select * from ICMO where FGMPBatchNo='13E01' and FCheckDate>='2013-10-01'

--------------改炉号----------------

--update POInstockEntry set /*FBatchNo=FEntrySelfT0241,*/FEntrySelfT0241='1410528' where 1=1 AND FInterID IN (7660) and FEntryID IN (1)

--update ICQCBill set /*FBatchNo=FHeadSelft1256,*/FHeadSelft1256='1410528' where 1=1 and FTranType=711 and FInStockInterID IN (7660) and FSerialID IN (1) 

--update ICMO set FGMPBatchNo='Q11306' where FGMPBatchNo='Q1306' and FCheckDate>='2013-10-01'


----------------改批次号---------------

--update POInstockEntry set FEntrySelfT0241='' where 1=1 and FBatchNo IN ('13L01','13L05','13L03','13L07','13L02')

--update ICQCBill set FHeadSelft1256='' where 1=1 and FBatchNo IN ('13L01','13L05','13L03','13L07','13L02')

1AC931

select i.FNumber,i.FName,i.FModel,b.FQty,* from POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem i on b.FItemID=i.FItemID where FEntrySelfT0241='YT32034'


--2014-03-17-- 修改炉号 YT32032 - YT32034
SELECT i.FNumber,u1.FEntrySelfT0241,FBatchNo,u1.* from POInstock v1 
INNER JOIN POInstockEntry u1 ON   v1.FInterID = u1.FInterID  AND u1.FInterID<>0 
LEFT JOIN t_ICItem i on u1.FItemID=i.FItemID
where 1=1 
AND v1.FBillNo='IQCR001415' 
and FEntryID in (5,6)



select * from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo='WIN006300' and u1.FEntryID=2


update u1 set u1.FEntrySelfA0160='2760 3 3762' from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo='WIN006300' and u1.FEntryID=2



