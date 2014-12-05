--drop procedure list_wghgl drop procedure list_wghgl_count

create procedure list_wghgl
@begindate varchar(10),
@enddate varchar(10),
@status int
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,hgsl decimal(28,2) default(0)
,bhgsl decimal(28,2) default(0)
,wldw nvarchar(255) default('')
,style int default (0)
)

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,1
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and a.FResult=286
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,11
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and b.FDefectHandlingID = 1077          --让步接收
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,12
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and b.FDefectHandlingID = 1036          --拒收
and FResult <> 13556

if @status=0 
select * from #Data
else if @status=1
select * from #data where style=1
else if @status=2
select * from #data where style>10
else if @status=3                    --让步接收
select * from #data where style=11
else if @status=4                    --拒收
select * from #data where style=12
else
select * from #Data
end

--count-------
create procedure list_wghgl_count
@begindate varchar(10),
@enddate varchar(10),
@status int
as 
begin
SET NOCOUNT ON 
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,jldw nvarchar(255) default('')
,hgsl decimal(28,2) default(0)
,bhgsl decimal(28,2) default(0)
,wldw nvarchar(255) default('')
,style int default (0)
)

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,1
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and a.FResult=286
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,11
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and b.FDefectHandlingID = 1077          --让步接收
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,12
from ICQCBill a 
left join (select a.FBillNo_SRC,b.FDefectHandlingID from QMReject a left join QMRejectEntry b on a.FID=b.FID group by FBillNo_SRC,b.FDefectHandlingID) b on a.FBillNo=b.FBillNo_SRC
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=711 AND FCancellation=0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and b.FDefectHandlingID = 1036          --拒收
and FResult <> 13556

if @status=0 
select count(*) from #Data
else if @status=1
select count(*) from #data where style=1
else if @status=2
select count(*) from #data where style>10
else if @status=3                    --让步接收
select count(*) from #data where style=11
else if @status=4                    --拒收
select count(*) from #data where style=12
else
select count(*) from #Data
end

execute list_wghgl '2012-11-01','2012-11-30',3

execute list_wghgl_count '2012-11-01','2012-11-30',0



SELECT * FROM ICQCBill