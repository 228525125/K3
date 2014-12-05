--DROP TRIGGER IC_POORDER
CREATE TRIGGER IC_POORDER ON POOrder
--WITH ENCRYPTION
FOR UPDATE,INSERT
AS
SET NOCOUNT ON
--IF NOT UPDATE(FPlanFinishDate)  RETURN
Insert into rss.dbo.PlanFinishDate(FBillNo,FPlanFinishDate
)
select FBillNo,convert(char(10),getDate(),120) from Deleted
--select b.FBillNo,convert(char(10),a.FDate,120) from Deleted a left join POOrder b on a.FInterID=b.FInterID




select FBillNo,FPlanFinishDate from rss.dbo.PlanFinishDate where FBillNo='WORK000215'

delete rss.dbo.PlanFinishDate where FBillNo='WORK000215'


delete rss.dbo.PlanFinishDate where FBillNo='JH-10-54'

select * from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='JH-10-54'

update b set b.FDate='2012-01-21' from POOrder a left join POOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='JH-10-54'
--DROP TRIGGER IC_ITEM

CREATE TRIGGER IC_ITEM ON t_ICItem    
After INSERT
AS
SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM inserted)
BEGIN
RETURN
END 

