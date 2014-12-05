--drop procedure count_cphgl

create procedure count_cphgl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
cppczs int default(0)
,cphgs int default(0)
,cpbhgs int default(0)
,cprbjss int default(0)
,cpjss int default(0)
)

Insert Into #Data(cppczs,cphgs,cpbhgs,cprbjss,cpjss
)
select sum(1) as 'cppczs'
,sum(case when FResult=286 then 1 else 0 end) as 'cphgs'
,sum(case when FResult<>286 then 1 else 0 end) as 'cpbhgs'
,sum(case when FSpecialUse=1077 or FSpecialUse=1037 then 1 else 0 end) as 'cprbjss'
,sum(case when FResult<>286 then 1 else 0 end) as 'cpjss'
from ICQCBill 
where FTranType=713 AND FCancellation = 0 AND FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and FResult <> 13556

select cppczs as 'cppczs',cphgs as 'cphgs',cpbhgs as 'cpbhgs',cprbjss as 'cprbjss',cpjss as 'cpjss',cphgl=convert(decimal(28,2),convert(decimal(28,2),cphgs-cprbjss)/cppczs*100),cprbjsl=convert(decimal(28,2),convert(decimal(28,2),cprbjss)/cppczs*100),cpjsl=convert(decimal(28,2),convert(decimal(28,2),cpjss)/cppczs*100) from #Data 
end


execute count_cphgl '2012-11-01','2012-11-30'




