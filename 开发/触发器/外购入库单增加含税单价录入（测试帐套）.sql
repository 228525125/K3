--drop trigger IC_WGRK DROP trigger IC_WGRK2

/* 增加手工输入含税单价 */
CREATE TRIGGER IC_WGRK ON ICStockBill
AFTER INSERT
AS
IF EXISTS(SELECT 1 FROM inserted WHERE FTranType=1)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted

/* FEntrySelfA0156:含税单价（填写）；FEntrySelfA0157:含税金额（填写）；FEntrySelfA0158: 含税单价；FEntrySelfA0159：含税金额；*/
UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0156/1.17,FEntrySelfA0158=FEntrySelfA0156,FAuxPrice=FEntrySelfA0156/1.17,FAmount=FEntrySelfA0156/1.17*FQty,FEntrySelfA0159=FEntrySelfA0156*FQty WHERE FInterID=@FInterID AND FSourceInterId=0      --手工单

UPDATE ICStockBillEntry SET FEntrySelfA0156=FEntrySelfA0158,FEntrySelfA0157=FEntrySelfA0159 WHERE FInterID=@FInterID AND FSourceInterId>0      --系统单

END 

/* 如果手工修改含税单价，处罚，系统单的情况除外*/
CREATE TRIGGER IC_WGRK2 ON ICStockBillEntry
AFTER UPDATE
AS
IF EXISTS(SELECT 1 FROM inserted a INNER JOIN ICStockBill b on a.FInterID=b.FInterID WHERE b.FTranType=1)
BEGIN
DECLARE @FInterID int
DECLARE @FEntryID int
SELECT @FInterID=FInterID,@FEntryID=FEntryID FROM inserted

/* FEntrySelfA0156:含税单价（填写）；FEntrySelfA0157:含税金额（填写）；FEntrySelfA0158: 含税单价；FEntrySelfA0159：含税金额；*/
UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0156/1.17,FEntrySelfA0158=FEntrySelfA0156,FAuxPrice=FEntrySelfA0156/1.17,FAmount=FEntrySelfA0156/1.17*FQty,FEntrySelfA0159=FEntrySelfA0156*FQty WHERE FInterID=@FInterID AND FEntryID=@FEntryID AND FSourceInterId=0      --手工单

UPDATE ICStockBillEntry SET FEntrySelfA0156=FEntrySelfA0158,FEntrySelfA0157=FEntrySelfA0159 WHERE FInterID=@FInterID AND FEntryID=@FEntryID AND FSourceInterId>0      --系统单

END 



select sum(b.FAmount) from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229

UPDATE a SET a.FHeadSelfA0140=b.FAmount FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229 group by a.FInterID) b on a.FInterID=b.FInterID WHERE b.FInterID=2229


SELECT * FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229 group by a.FInterID) b on a.FInterID=b.FInterID where a.FInterID=2229


select FHeadSelfA0140,* from ICStockBill where FBillNo='WIN000105'

select * from rss.dbo.kcdz1$ where dm='06.02.0802'

update rss.dbo.kcdz1$ set mc='螺套' where dm='06.02.0802'


SELECT FTranType FROM ICStockBill WHERE FInterID=2241

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
