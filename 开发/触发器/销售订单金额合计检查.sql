--DROP TRIGGER IC_XSDD_JEHJ         手工填写订单金额合计

CREATE TRIGGER IC_XSDD_JEHJ ON SEOrder
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted  WHERE FStatus=1 and FChangeUser=0)        --订单变更不进行判断
BEGIN
DECLARE @FInterID int
DECLARE @jshj decimal(28,2)
DECLARE @sgtx decimal(28,2)
DECLARE @msg nvarchar(255)

SELECT @FInterID=FInterID FROM inserted

SELECT @sgtx=a.FHeadSelfS0149,@jshj=sum(b.FAllAmount) 
FROM SEOrder a 
INNER JOIN SEOrderEntry b on a.FInterID=b.FInterID
WHERE a.FStatus=1 and FCancellation=0
AND a.FInterID=@FInterID
group by a.FHeadSelfS0149

IF @jshj<>@sgtx
BEGIN
	set @msg='订单合计金额有误'
	EXEC(@msg)
END

END

---------

CREATE TRIGGER IC_XSDD_JEHJ ON SEOrderEntry
After UPDATE
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted a WHERE exists(select 1 from deleted b where a.FQty<>b.FQty or a.FPrice<>b.FPrice or a.FAllAmount<>b.FAllAmount or a.FPriceDiscount<>b.FPriceDiscount or a.FTaxPrice<>b.FTaxPrice))
BEGIN
DECLARE @FInterID int
DECLARE @jshj decimal(28,2)
DECLARE @sgtx decimal(28,2)
DECLARE @msg nvarchar(255)

SELECT @FInterID=FInterID FROM inserted

SELECT @sgtx=a.FHeadSelfS0149,@jshj=sum(b.FAllAmount) 
FROM SEOrder a 
INNER JOIN SEOrderEntry b on a.FInterID=b.FInterID
WHERE a.FStatus=1 and FCancellation=0
AND a.FInterID=@FInterID
group by a.FHeadSelfS0149

IF @jshj<>@sgtx
BEGIN
	set @msg='订单合计金额有误'+Convert(char(20),@jshj)
	EXEC(@msg)
END

END


select a.* from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where FBillNo='SEORD006796' and FCancellation=0 and b.FEntryID=1


select * from t_user where FUserID=16469

16469

FHeadSelfS0149 = sum(FAllAmount)

select a.FBillNo,FHeadSelfS0149,b.FAllAmount FROM SEOrder a
left join (
	SELECT a.FBillNo,sum(b.FAllAmount) as FAllAmount
	FROM SEOrder a 
	left join SEorderEntry b on a.FInterID = b.FInterID
	where 1=1
	and a.FCancellation=0
	group by a.FBillNo
) b on a.FBillNo=b.FBillNo
where FHeadSelfS0149 is null or FHeadSelfS0149 =0



update a set a.FHeadSelfS0149=b.FAllAmount FROM SEOrder a
left join (
	SELECT a.FBillNo,sum(b.FAllAmount) as FAllAmount
	FROM SEOrder a 
	left join SEorderEntry b on a.FInterID = b.FInterID
	where 1=1
	and a.FCancellation=0
	group by a.FBillNo
) b on a.FBillNo=b.FBillNo
where FHeadSelfS0149 is null or FHeadSelfS0149 =0




select * from SEOrder 
