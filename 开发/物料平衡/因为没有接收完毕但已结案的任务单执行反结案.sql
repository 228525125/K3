--因为没有接收而不应结案的任务单
--drop procedure unclose_scrw

create procedure unclose_scrw
as
begin
update v1 set v1.FStatus=1 from ICMO v1 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) c on v1.FBillNo=c.FICMOBillNo
LEFT JOIN (select b.FICMOBillNo,sum(b.FReceiveQty) as FReceiveQty from ICShop_SubcIn a inner join ICShop_SubcInEntry b on a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) d on v1.FBillNo=d.FICMOBillNo
where 1=1
and v1.FCheckDate>='2012-09-01' and v1.FCheckDate<='2015-09-30'
and v1.FStatus = 3         --1：下达；3：结案
and ((c.FTranOutQty is not null and d.FReceiveQty is null) or (c.FTranOutQty is not null and c.FTranOutQty<>d.FReceiveQty))
and v1.FBillNo <> 'WORK020059'     --送检差56
and v1.FBillNo <> 'WORK022050'     --送检差2
and v1.FBillNo <> 'WORK022447'     --送检差4
and v1.FBillNo <> 'WORK022923'     --报废4
and v1.FBillNo <> 'WORK022925'     --报废4
end

--drop procedure list_scrw_tqja drop procedure list_scrw_tqja_count 
create procedure list_scrw_tqja
as
begin
SET NOCOUNT ON
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,zcsl decimal(28,0) default(0)
,jssl decimal(28,0) default(0)
)


Insert Into #Data(djbh,djrq,cpdm,cpmc,cpgg,zcsl,jssl
)
select v1.FBillNo,v1.FCheckDate,i.FNumber,i.FName,i.FModel,c.FTranOutQty,d.FReceiveQty
from ICMO v1 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) c on v1.FBillNo=c.FICMOBillNo
LEFT JOIN (select b.FICMOBillNo,sum(b.FReceiveQty) as FReceiveQty from ICShop_SubcIn a inner join ICShop_SubcInEntry b on a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) d on v1.FBillNo=d.FICMOBillNo
where 1=1
and v1.FCheckDate>='2012-09-01' and v1.FCheckDate<='2015-09-30'
and v1.FStatus = 3         --1：下达；3：结案
and ((c.FTranOutQty is not null and d.FReceiveQty is null) or (c.FTranOutQty is not null and c.FTranOutQty<>d.FReceiveQty))
and v1.FBillNo <> 'WORK020059'     --送检差56
and v1.FBillNo <> 'WORK022050'     --送检差2
and v1.FBillNo <> 'WORK022447'     --送检差4
and v1.FBillNo <> 'WORK022923'     --报废4
and v1.FBillNo <> 'WORK022925'     --报废4
					
select * from #Data
end

--count--
create procedure list_scrw_tqja_count
as
begin
SET NOCOUNT ON
create table #Data(
djbh nvarchar(255) default('')
,djrq nvarchar(255) default('')
,cpdm nvarchar(255) default('')
,cpmc nvarchar(255) default('')
,cpgg nvarchar(255) default('')
,zcsl decimal(28,0) default(0)
,jssl decimal(28,0) default(0)
)


Insert Into #Data(djbh,djrq,cpdm,cpmc,cpgg,zcsl,jssl
)
select v1.FBillNo,v1.FCheckDate,i.FNumber,i.FName,i.FModel,c.FTranOutQty,d.FReceiveQty
from ICMO v1 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) c on v1.FBillNo=c.FICMOBillNo
LEFT JOIN (select b.FICMOBillNo,sum(b.FReceiveQty) as FReceiveQty from ICShop_SubcIn a inner join ICShop_SubcInEntry b on a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) d on v1.FBillNo=d.FICMOBillNo
where 1=1
and v1.FCheckDate>='2012-09-01' and v1.FCheckDate<='2015-09-30'
and v1.FStatus = 3         --1：下达；3：结案
and ((c.FTranOutQty is not null and d.FReceiveQty is null) or (c.FTranOutQty is not null and c.FTranOutQty<>d.FReceiveQty))
and v1.FBillNo <> 'WORK020059'     --送检差56
and v1.FBillNo <> 'WORK022050'     --送检差2
and v1.FBillNo <> 'WORK022447'     --送检差4
and v1.FBillNo <> 'WORK022923'     --报废4
and v1.FBillNo <> 'WORK022925'     --报废4
					
select count(*) from #Data
end


exec list_scrw_tqja
exec list_scrw_tqja_count



exec close_scrw
exec unclose_scrw

