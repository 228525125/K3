--drop procedure list_wxhgl drop procedure list_wxhgl_count

create procedure list_wxhgl
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
where FTranType=715 AND FCancellation = 0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and a.FResult=286
and FSpecialUse<>1077 and FSpecialUse<>1037          --�ò����� �� �ز� ������Ϊ�ϸ�
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,11
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=715 AND FCancellation = 0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and (FSpecialUse=1077 or FSpecialUse=1037)          --�ò����� + �ز�
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,12
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=715 AND FCancellation = 0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and a.FResult<>286          --����
and FResult <> 13556

if @status=0 
select * from #Data
else if @status=1
select * from #data where style=1
else if @status=2
select * from #data where style>10
else if @status=3                    --�ò�����
select * from #data where style=11
else if @status=4                    --����
select * from #data where style=12
else
select * from #Data
end

--count-------
create procedure list_wxhgl_count
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
where FTranType=715 AND FCancellation = 0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and a.FResult=286
and FSpecialUse<>1077 and FSpecialUse<>1037          --�ò����� �� �ز� ������Ϊ�ϸ�
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,11
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=715 AND FCancellation = 0
and FCheckDate>=@begindate and FCheckDate<=@enddate
--and FCheckDate>='2012-11-01' and FCheckDate<='2012-11-30'
and (FSpecialUse=1077 or FSpecialUse=1037)          --�ò����� + �ز�
and FResult <> 13556

Insert Into #Data(djbh,djrq,wldm,wlmc,wlgg,jldw,hgsl,bhgsl,wldw,style
)
select a.FBillNo as 'djbh',convert(char(10),a.FDate,120) as 'djrq',
i.FNumber as 'wldm',i.FName as 'wlmc',i.FModel as 'wlgg',mu.FName as 'jldw',FPassQty as 'hgsl',FNotPassQty as 'bhgsl',s.FName,12
from ICQCBill a 
LEFT JOIN t_ICItem i on a.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=a.FUnitID 
LEFT JOIN t_Supplier s on a.FSupplyID=s.FItemID
where FTranType=715 AND FCancellation = 0
and FCheckDate>=@begindate and FCheckDate<=@enddate
and a.FResult<>286          --����
and FResult <> 13556

if @status=0   --ȫ��
select count(*) from #Data
else if @status=1     --�ϸ�            
select count(*) from #data where style=1
else if @status=2            --���ϸ�
select count(*) from #data where style>10
else if @status=3                    --�ò�����
select count(*) from #data where style=11
else if @status=4                    --����
select count(*) from #data where style=12
else
select * from #Data
end

execute list_wxhgl '2012-11-01','2012-11-30',3

execute list_wxhgl_count '2012-11-01','2012-11-30',0



