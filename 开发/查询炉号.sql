--根据批次号查询炉号
--drop procedure query_lh

create procedure query_lh
@PH nvarchar(255)         --批号
,@LH nvarchar(255) output
as 
begin
SET NOCOUNT ON 
SET @LH=''

SELECT @LH=ISNULL(b.FEntrySelfT0241,'') FROM POInstock a left join POInstockEntry b on a.FInterID=b.FInterID left join t_ICItem c on b.FItemID=c.FItemID where a.FTranType=702 and a.FCancellation = 0 and b.FBatchNo=@PH

IF (@LH='' OR @LH is null)
SELECT @LH=ISNULL(lh,'') FROM pclh where ph=@PH

end


DECLARE @RESULT nvarchar(255)  

EXEC query_lh '111',@RESULT output

SELECT @RESULT