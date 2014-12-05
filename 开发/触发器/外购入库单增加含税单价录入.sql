--drop trigger IC_WGRK DROP trigger IC_WGRK2

/* 增加手工输入含税单价 */
CREATE TRIGGER IC_WGRK ON ICStockBill
AFTER INSERT
AS
IF EXISTS(SELECT 1 FROM inserted WHERE FTranType=1)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted

/* FEntrySelfA0158:含税单价（填写）；FEntrySelfA0159:含税金额（填写）；FEntrySelfA0156: 含税单价；FEntrySelfA0157：含税金额；*/
UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0158/1.17,FEntrySelfA0156=FEntrySelfA0158,FAuxPrice=FEntrySelfA0158/1.17,FAmount=FEntrySelfA0158/1.17*FQty,FEntrySelfA0157=FEntrySelfA0158*FQty WHERE FInterID=@FInterID AND FSourceInterId=0      --手工单

UPDATE ICStockBillEntry SET FEntrySelfA0158=round(FEntrySelfA0156,3),FEntrySelfA0156=round(FEntrySelfA0156,3),FEntrySelfA0159=round(FEntrySelfA0157,3),FEntrySelfA0157=round(FEntrySelfA0157,3) WHERE FInterID=@FInterID AND FSourceInterId>0 AND FEntrySelfA0158 = 0      --系统单 四舍五入是因为K3系统计算出来的含税单价可能会多0.0001

UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0158/1.17,FEntrySelfA0156=FEntrySelfA0158,FAuxPrice=FEntrySelfA0158/1.17,FAmount=FEntrySelfA0158/1.17*FQty,FEntrySelfA0157=FEntrySelfA0158*FQty WHERE FInterID=@FInterID AND FSourceInterId>0 and FEntrySelfA0158<>0      --修改系统单单价

END 

/* 如果手工修改含税单价，处罚，系统单的情况除外, 未启用，原因主要是修改外购入库单时，系统执行Insert语句*/
CREATE TRIGGER IC_WGRK2 ON ICStockBillEntry
AFTER UPDATE
AS
IF EXISTS(SELECT 1 FROM inserted a INNER JOIN ICStockBill b on a.FInterID=b.FInterID WHERE b.FTranType=1) and EXISTS(SELECT 1 FROM inserted a INNER JOIN deleted b on a.FInterID=b.FInterID and a.FEntryID=b.FEntryID where a.FEntrySelfA0158<>b.FEntrySelfA0158)
BEGIN
DECLARE @FInterID int
DECLARE @FEntryID int
SELECT @FInterID=FInterID,@FEntryID=FEntryID FROM inserted

/* FEntrySelfA0158:含税单价（填写）；FEntrySelfA0159:含税金额（填写）；FEntrySelfA0156: 含税单价；FEntrySelfA0157：含税金额；*/
UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0158/1.17,FEntrySelfA0156=FEntrySelfA0158,FAuxPrice=FEntrySelfA0158/1.17,FAmount=FEntrySelfA0158/1.17*FQty,FEntrySelfA0157=FEntrySelfA0158*FQty WHERE FInterID=@FInterID AND FSourceInterId=0      --手工单

UPDATE ICStockBillEntry SET FEntrySelfA0158=FEntrySelfA0156,FEntrySelfA0159=FEntrySelfA0157 WHERE FInterID=@FInterID AND FSourceInterId>0      --系统单

END 


select * from ICStockBillEntry WHERE FTranType=1

create table test1(
tab nvarchar(10) default('')
,FBillNo nvarchar(20) default('')
,FAuxQtyInvoice decimal(28,2) default(0)
)

insert into  rss.dbo.test1(tab,FBillNo,FAuxQtyInvoice)
select 'insert',FInterID,FAuxQtyInvoice from inserted

insert into  rss.dbo.test1(tab,FBillNo,FAuxQtyInvoice)
select 'delete',FInterID,FAuxQtyInvoice from deleted

select sum(b.FAmount) from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229

UPDATE a SET a.FHeadSelfA0140=b.FAmount FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229 group by a.FInterID) b on a.FInterID=b.FInterID WHERE b.FInterID=2229


SELECT * FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229 group by a.FInterID) b on a.FInterID=b.FInterID where a.FInterID=2229


select b.* from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where FBillNo='WIN003484'

select * from rss.dbo.kcdz1$ where dm='06.02.0802'

update rss.dbo.kcdz1$ set mc='螺套' where dm='06.02.0802'

/* 更新2012-12-06 之前的金额*/
/*SELECT a.FDate,b.FQty,b.FPrice as '无税单价',b.FAmount as '无税金额', b.FEntrySelfA0158 as '含税单价（填写）',b.FEntrySelfA0159 as '含税金额（填写）',FEntrySelfA0156 as '含税单价', FEntrySelfA0157 as '含税金额' 
FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID 
WHERE FTranType=1
and a.FDate >='2012-06-01' and a.FDate<='2012-12-06'

update b set b.FEntrySelfA0157 = b.FEntrySelfA0156*b.FQty 
FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID 
WHERE FTranType=1
and a.FDate >='2012-06-01' and a.FDate<='2012-12-06'

update b set b.FEntrySelfA0158 = b.FEntrySelfA0156 , b.FEntrySelfA0159 =  b.FEntrySelfA0157
FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID 
WHERE FTranType=1
and a.FDate >='2012-06-01' and a.FDate<='2012-12-06'*/


SELECT * FROM ICStockBillEntry WHERE FInterID=2241



/*CREATE TRIGGER IC_WGRK ON ICStockBill
AFTER INSERT
AS
IF EXISTS(SELECT 1 FROM inserted WHERE FTranType=1)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted

--主表-FHeadSelfA0140 : 汇总含税金额
UPDATE a SET a.FHeadSelfA0140=b.FAmount FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=@FInterID group by a.FInterID) b on a.FInterID=b.FInterID WHERE b.FInterID=@FInterID

END */

select * from rss.dbo.test1


select 0.4274*1.17

select round(.500058,3)

delete rss.dbo.test1