--drop procedure count_wxhgl

create procedure count_wxhgl
@begindate varchar(10),
@enddate varchar(10)
as 
begin
SET NOCOUNT ON 
create table #Data(
pczs int default(0)
,hgs int default(0)
,bhgs int default(0)
,rbjss int default(0)
,jss int default(0)
)

Insert Into #Data(pczs,hgs,bhgs,rbjss,jss
)
select sum(1) as 'pczs'
,sum(case when FResult=286 then 1 else 0 end) as 'hgs'
,sum(case when FResult<>286 then 1 else 0 end) as 'bhgs'
,sum(case when FSpecialUse=1077 or FSpecialUse=1037 then 1 else 0 end) as 'rbjss'
,sum(case when FResult<>286 then 1 else 0 end) as 'jss'
from ICQCBill 
where FTranType=715 AND FCancellation = 0 AND FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and FResult <> 13556

select pczs as 'wxpczs',hgs as 'wxhgs',bhgs as 'wxbhgs',rbjss as 'wxrbjss',jss as 'wxjss',wxhgl=convert(decimal(28,2),convert(decimal(28,2),hgs-rbjss)/pczs*100),wxrbjsl=convert(decimal(28,2),convert(decimal(28,2),rbjss)/pczs*100),wxjushoulv=convert(decimal(28,2),convert(decimal(28,2),jss)/pczs*100) from #Data 
end



execute count_wxhgl '2012-11-01','2012-11-30'


