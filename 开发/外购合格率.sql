--drop procedure count_wghgl

create procedure count_wghgl
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
,sum(case when b.FDefectHandlingID = 1077 then 1 else 0 end) as 'rbjss'
,sum(case when b.FDefectHandlingID =1036 then 1 else 0 end) as 'jss'
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and FResult <> 13556

select pczs,hgs,bhgs,rbjss,jss,hgl=convert(decimal(28,2),convert(decimal(28,2),hgs)/pczs*100),rbjsl=convert(decimal(28,2),convert(decimal(28,2),rbjss)/pczs*100),jsl=convert(decimal(28,2),convert(decimal(28,2),jss)/pczs*100,jss/pczs*100) from #Data 
end


execute count_wghgl '2012-11-01','2012-11-30'

select FBillNo_SRC from QMReject a left join QMRejectEntry b on a.FID=b.FID where b.FDefectHandlingID=1077 group by FBillNo_SRC

select b.* from QMReject a left join QMRejectEntry b on a.FID=b.FID where a.fid in (1004,1005)




select * from QMRejectEntry
