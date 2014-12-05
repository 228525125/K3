--drop trigger IC_WGRK DROP trigger IC_WGRK2

/* �����ֹ����뺬˰���� */
CREATE TRIGGER IC_WGRK ON ICStockBill
AFTER INSERT
AS
IF EXISTS(SELECT 1 FROM inserted WHERE FTranType=1)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted

/* FEntrySelfA0156:��˰���ۣ���д����FEntrySelfA0157:��˰����д����FEntrySelfA0158: ��˰���ۣ�FEntrySelfA0159����˰��*/
UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0156/1.17,FEntrySelfA0158=FEntrySelfA0156,FAuxPrice=FEntrySelfA0156/1.17,FAmount=FEntrySelfA0156/1.17*FQty,FEntrySelfA0159=FEntrySelfA0156*FQty WHERE FInterID=@FInterID AND FSourceInterId=0      --�ֹ���

UPDATE ICStockBillEntry SET FEntrySelfA0156=FEntrySelfA0158,FEntrySelfA0157=FEntrySelfA0159 WHERE FInterID=@FInterID AND FSourceInterId>0      --ϵͳ��

END 

/* ����ֹ��޸ĺ�˰���ۣ�������ϵͳ�����������*/
CREATE TRIGGER IC_WGRK2 ON ICStockBillEntry
AFTER UPDATE
AS
IF EXISTS(SELECT 1 FROM inserted a INNER JOIN ICStockBill b on a.FInterID=b.FInterID WHERE b.FTranType=1)
BEGIN
DECLARE @FInterID int
DECLARE @FEntryID int
SELECT @FInterID=FInterID,@FEntryID=FEntryID FROM inserted

/* FEntrySelfA0156:��˰���ۣ���д����FEntrySelfA0157:��˰����д����FEntrySelfA0158: ��˰���ۣ�FEntrySelfA0159����˰��*/
UPDATE ICStockBillEntry SET FPrice=FEntrySelfA0156/1.17,FEntrySelfA0158=FEntrySelfA0156,FAuxPrice=FEntrySelfA0156/1.17,FAmount=FEntrySelfA0156/1.17*FQty,FEntrySelfA0159=FEntrySelfA0156*FQty WHERE FInterID=@FInterID AND FEntryID=@FEntryID AND FSourceInterId=0      --�ֹ���

UPDATE ICStockBillEntry SET FEntrySelfA0156=FEntrySelfA0158,FEntrySelfA0157=FEntrySelfA0159 WHERE FInterID=@FInterID AND FEntryID=@FEntryID AND FSourceInterId>0      --ϵͳ��

END 



select sum(b.FAmount) from ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229

UPDATE a SET a.FHeadSelfA0140=b.FAmount FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229 group by a.FInterID) b on a.FInterID=b.FInterID WHERE b.FInterID=2229


SELECT * FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=2229 group by a.FInterID) b on a.FInterID=b.FInterID where a.FInterID=2229


select FHeadSelfA0140,* from ICStockBill where FBillNo='WIN000105'

select * from rss.dbo.kcdz1$ where dm='06.02.0802'

update rss.dbo.kcdz1$ set mc='����' where dm='06.02.0802'


SELECT FTranType FROM ICStockBill WHERE FInterID=2241

SELECT * FROM ICStockBillEntry WHERE FInterID=2241



/*CREATE TRIGGER IC_WGRK ON ICStockBill
AFTER INSERT
AS
IF EXISTS(SELECT 1 FROM inserted WHERE FTranType=1)
BEGIN
DECLARE @FInterID int
SELECT @FInterID=FInterID FROM inserted

--����-FHeadSelfA0140 : ���ܺ�˰���
UPDATE a SET a.FHeadSelfA0140=b.FAmount FROM ICStockBill a INNER JOIN (SELECT a.FInterID,sum(b.FAmount) as FAmount FROM ICStockBill a left join ICStockBillEntry b on a.FInterID=b.FInterID where a.FInterID=@FInterID group by a.FInterID) b on a.FInterID=b.FInterID WHERE b.FInterID=@FInterID

END */
