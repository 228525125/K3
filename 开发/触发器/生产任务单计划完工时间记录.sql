--DROP TRIGGER IC_PFD
CREATE TRIGGER IC_PFD ON ICMO
--WITH ENCRYPTION
FOR UPDATE,INSERT
AS
SET NOCOUNT ON
--IF UPDATE(FPlanFinishDate)
IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)      --插入生产任务单时记录，经过测试，系统每次修改都会进入这条数据
BEGIN
Insert into rss.dbo.PlanFinishDate(FBillNo,FPlanFinishDate
)
select a.FBillNo,convert(char(10),a.FPlanFinishDate,120) from inserted a --where exists(select * from ICMO b where a.FBillNo=b.FBillNo and a.FPlanFinishDate<>b.FPlanFinishDate)
END




--
Insert into rss.dbo.PlanFinishDate(FBillNo,FPlanFinishDate
)
select FBillNo,FPlanFinishDate from ICMO where FBillNo='123'


select * from rss.dbo.coc

create table PlanFinishDate(
FBillNo nvarchar(255) default '',
FPlanFinishDate nvarchar(255) default ''
)

select * from ICMO where FBillNo='WORK000215'

update ICMO set FPlanFinishDate='2012-05-06' where FBillNo='WORK000215'

select * from rss.dbo.PlanFinishDate a 


where exists(select min() from ICMO b where a.FBillNo=b.FBillNo and min(a.FPlanFinishDate)<>b.FPlanFinishDate)

select a.FBillNo,a.FPlanFinishDate,b.FPlanFinishDate from ICMO a 
inner join (
select FBillNo,Min(FPlanFinishDate) as FPlanFinishDate from rss.dbo.PlanFinishDate group by FBillNo
) b on a.FBillNo=b.FBillNo
where b.FPlanFinishDate<>convert(char(10),a.FPlanFinishDate,120)
and FCheckDate>='2011-12-01'



--delete rss.dbo.PlanFinishDate


select FBillNo,FPlanFinishDate from rss.dbo.PlanFinishDate where FBillNo='WORK000215'

select FBillNo,FPlanFinishDate from rss.dbo.PlanFinishDate where FBillNo='WORK000218'

delete rss.dbo.PlanFinishDate where FBillNo='WORK000217'

