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


select v1.FBillNo,v1.FCheckDate,c.FTranOutQty,d.FReceiveQty
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
					




exec close_scrw
exec unclose_scrw



select v1.FBillNo,v1.FCheckDate,c.FTranOutQty,d.FReceiveQty
from ICMO v1 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID
LEFT JOIN (select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) c on v1.FBillNo=c.FICMOBillNo
LEFT JOIN (select b.FICMOBillNo,sum(b.FReceiveQty) as FReceiveQty from ICShop_SubcIn a inner join ICShop_SubcInEntry b on a.FInterID=b.FInterID where a.FStatus=1 group by FICMOBillNo) d on v1.FBillNo=d.FICMOBillNo
where 1=1
and v1.FCheckDate>='2012-09-01' and v1.FCheckDate<='2015-09-30'
and v1.FStatus = 3         --1：下达；3：结案
and v1.FBillNo in ('WORK030884')


select b.FICMOBillNo,sum(b.FTranOutQty) as FTranOutQty from ICShop_SubcOut a inner join ICShop_SubcOutEntry b ON a.FInterID=b.FInterID 
where a.FStatus=1 

group by FICMOBillNo


select * from ICMO where FBillNo in ('work027277','work027278','work027466','work027566')

update ICMO set FStatus=1,FMrpClosed=0,FHandworkClose=0 where FBillNo in ('WORK030886','WORK030885','WORK030884','WORK030883','WORK030882','WORK030881')