

select FWorkTypeID,* from ICMO v1 

select b.FStatus,* 
from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on  a.FID=b.FID
Inner join ICMO o on a.FSourceBillNo=o.FBillNo
where 1=1
and o.FStatus = 3           --�᰸
and b.FStatus <> 4


update b set b.FStatus=4 
from ICShop_FlowCard a 
left join ICShop_FlowCardEntry b on  a.FID=b.FID
Inner join ICMO o on a.FSourceBillNo=o.FBillNo
where 1=1
and o.FStatus = 3           --�᰸
and b.FStatus <> 4

select * from ICShop_FlowCardEntry


select * from ICMO where FBillNo in ('work024507','work024508')



--5��ί��ת�� 6��ί����� 4���깤 0��δ�ɹ� 2���Ѵ�ӡ 1�����ɹ� 3������ 7����ͣ 8��ȡ��