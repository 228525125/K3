

select a.FBillNo,a.FPlanFinishDate,b.FDate from ICMO a 
left join (select FBillNo,MIN(FPlanFinishDate) as FDate from rss.dbo.PlanFinishDate where FPlanFinishDate >='2012-02-01' group by FBillNo) b on a.FBillNo=b.FBillNo
where a.FPlanFinishDate >='2012-02-01' and a.FPlanFinishDate<>b.FDate

--select * from PlanFinishDate a where exists(select * from PlanFinishDate b where MAX(a.FPlanFinishDate)<>MIN(b.FPlanFinishDate) group by FBillNo) group by FBillNo