--drop procedure list_cphgl drop procedure list_cphgl_count

create procedure list_cphgl
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
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=713 AND FCancellation = 0 AND a.FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and a.FResult=286
and FSpecialUse<>1077 and FSpecialUse<>1037          --让步接收 和 特采 检验结果为合格
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,11
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=713 AND FCancellation = 0 AND a.FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and (FSpecialUse=1077 or FSpecialUse=1037)          --让步接收 + 特采
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,12
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=713 AND FCancellation = 0 AND a.FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and a.FResult<>286          --拒收
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

--count--
create procedure list_cphgl_count
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
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=713 AND FCancellation = 0 AND a.FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and a.FResult=286
and FSpecialUse<>1077 and FSpecialUse<>1037          --让步接收 和 特采 检验结果为合格
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,11
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=713 AND FCancellation = 0 AND a.FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and (FSpecialUse=1077 or FSpecialUse=1037)          --让步接收 + 特采
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,12
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=713 AND FCancellation = 0 AND a.FStatus>0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and a.FResult<>286          --拒收
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


execute list_cphgl '2012-11-01','2012-11-30',2