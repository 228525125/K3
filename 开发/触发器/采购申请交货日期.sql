--DROP TRIGGER IC_CGSQDHQ

CREATE TRIGGER IC_CGSQDHQ ON POrequestEntry
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM inserted where datediff(day,FFetchTime,getdate())=0 )        --到货日期为当天的
BEGIN
DECLARE @FInterID int
DECLARE @FEntryID int
SELECT @FInterID=FInterID,@FEntryID=FEntryID FROM inserted
UPDATE POrequestEntry SET FFetchTime=DateAdd(day,90,getdate()) WHERE FInterID=@FInterID AND FEntryID=@FEntryID

END 



select datediff(day,'2012-11-26',getdate())

select u1.* from POrequest v1 
INNER JOIN POrequestEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where v1.FBillNo='POREQ001966'
and FFetchTime=


select DateAdd(day,90,getdate()) 
