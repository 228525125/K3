select a.FItemID as '���ϱ���',a.FNumber as '���ϳ�����',a.FName as '����',a.FModel as '���',a.FHelpCode as 'ͼ��',
m.FName as '������λ',b.FSecInv as '��ȫ���',b.FHighLimit as '��߿��',b.FLowLimit as '��Ϳ��',c.FName as 'Ĭ�ϲֿ�',
d.FBatchAppendQty as '��������',d.FQtyMin as '��С������',d.FDailyConsume as '��������',d.FFixLeadTime as '�ɹ�����',e.FProChkMde as '��Ʒ���鷽ʽ',e.FSOChkMde as '�������鷽ʽ',
a.FQtyDecimal as '��������',m.FName as '������λ'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
--inner join rss.dbo.export_aqkc111010 f on a.FName=f.wlmc and a.FModel=f.gg and wldm is null 
where 1=1 
and a.FNumber in ('01.01.01.001')
--and b.FSecInv<>0
--and (a.FModel like '%F9340ZF%' or a.FHelpCode like '%F9340ZF%')
--and b.FUseState=341 
--and left(a.FNumber,2) ='09' 
--and b.FSecInv>10 
--and left(a.FNumber,6)='02.01.' 
--and a.FName like '%����%' and e.FProChkMde<>352 
/*and a.FNumber in (
'02.02.02.039'
,'02.02.02.163'
,'02.02.02.089'
,'02.02.05.003'
,'02.02.07.002'
,'02.02.02.124'
,'02.02.02.079'
,'02.02.02.030'
,'02.02.02.032'
,'02.02.04.050'
,'02.02.03.029'
,'02.01.0350'
,'02.02.03.003'
,'02.02.07.012'
,'02.02.03.089'
,'02.02.05.020'
,'02.02.07.013'
,'02.02.04.048'
,'02.02.04.050'
,'02.02.02.146'
,'02.02.02.039'
,'02.02.02.061'
,'02.02.02.123'
,'02.02.02.085'
,'02.02.02.159'
,'01.02.05.096'
,'04.05.148'
)*/
and a.FDeleted=0
--AND (left(a.FNumber,3)='05.' or left(a.FNumber,3)='06.' or left(a.FNumber,3)='07.' or left(a.FNumber,3)='09.')
and left(a.FNumber,5)='02.03'
order by a.FNumber


select FSOChkMde,* from t_ICItemQuality where FSOChkMde=353

update t_ICItemQuality set FSOChkMde=352 where FSOChkMde=353

select a.FNumber as '���ϳ�����',a.FName as '����',a.FModel as '���',a.FHelpCode as 'ͼ��',a.FInspectionLevel,e.*
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1
--and left(a.FNumber,3)='05.'
and a.FDeleted=0
and  a.FNumber in ('01.01.01.001')
order by a.FHelpCode

PA9002JE��M2801AH-1��

--FInspectionLevel=353     �ɹ����鷽ʽ ���

select FSecInv,FHighLimit,FQtyMin,* from t_ICItem where left(FNumber,5)='02.03'

update t_ICItem set FSecInv=2,FHighLimit=12,FQtyMin=10 where left(FNumber,5)='02.03'


select FErpClsID,* from t_ICItem where FNumber='05.08.4503'

update t_ICItem set FErpClsID=1 where FNumber='05.08.4503'

FInspectionProject

--update t_ICItem set FDeleted=1 where FNumber='05.05.1001'

--update b set b.FHighLimit=b.FSecInv+d.FQtyMin 
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 
and a.FNumber in (
'02.01.0019',
'02.01.0107',
'02.01.0125',
'02.01.0126',
'02.01.0133',
'02.01.0134',
'02.01.0162',
'02.01.0164',
'02.01.0313',
'02.01.0317',
'02.01.0463'
)


select * from t_ICItemBase

select * from t_ICItemPlan

select * from t_ICItemQuality where FProChkMde=352

select * from t_Stock

select * from ICBom

update b set 
--b.FSecInv=f.aqkc                   --��ȫ���
b.FHighLimit=0               --��߿��
--,b.FLowLimit                       --��Ϳ��
--d.FQtyMin=f.zxdhl                  --��С������
--,d.FDailyConsume                   --��������
--,d.FFixLeadTime=isnull(f.cgzq,0)   --�ɹ�����
--a.FNote=f.bz                       --��ע
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID
left join t_ICItemQuality e on a.FItemID=e.FItemID
--inner join rss.dbo.export_aqkc111010 f on a.FName=f.wlmc and a.FModel=f.gg and wldm is null 
where 1=1 
--and b.FUseState=341 
and b.FSecInv<>0 
--and left(a.FNumber,3)='05.' 
/*and a.FNumber in ('02.01.0119','02.01.0106','01.02.05.013','01.02.05.014','01.02.05.016','02.01.0002','01.02.05.002','01.02.05.005'
,'01.02.04.007')*/
/*and a.FNumber in (
'01.02.01.026',
'01.02.01.027',
'01.02.04.007',
'01.02.05.013',
'01.02.05.014',
'01.02.05.016',
'02.01.0002',
'01.02.05.002',
'01.02.05.005',
'02.01.0119',
'02.01.0106',
'08.03.0015',
'08.03.0017',
'08.03.0021',
'08.03.0022'
)*/


select * from t_ICItem a 
inner join rss.dbo.export_aqkc b on a.FNumber=b.wldm


select wlmc from rss.dbo.export_aqkc111010 where wldm is null group by wlmc,gg

--�޸����ι�������
select a.FBatchManager,b.FProChkMde,b.* from t_ICItem a left join t_ICItemQuality b on a.FItemID=b.FItemID where FNumber in ('01.01.20.097','01.01.20.103','01.01.20.104')

update t_ICItem set FBatchManager=1 where FNumber in ('01.01.20.097','01.01.20.103','01.01.20.104')

select FBatchManager,* from t_ICItem where FNumber='08.03.0005'

update t_ICItem set FBatchManager=0 where FNumber='08.03.0005'

--��Щ���ϴ��벻ͬ����Ʒ���͹����ͬ
select a.FName,a.FModel,a.FNumber from t_ICItem a where left(FNumber,3)='05.' and exists(select * from t_ICItem b where a.FModel = b.FModel and a.FName=b.FName and a.FNumber<>b.FNumber) order by FName,FModel

--���벻ͬ��Ʒ����ͬ
select a.FName,a.FModel,a.FNumber from t_ICItem a where left(FNumber,3)='05.' and exists(select * from t_ICItem b where a.FName=b.FName and a.FNumber<>b.FNumber) order by FName



select * from t_ICItem a
left join t_ICItemBase b on a.FItemID=b.FItemID
where left(a.FNumber,5)='02.02' and b.FSecInv>0

select FPlanTrategy from t_ICItemPlan


select FName,FModel,FNumber from t_icitem where  FModel='S8329KCS-RJ'


select FName,FModel,FNumber from t_icitem where FName='DN25Զ����ѹ������DN25 ANSI1500��'


select * from wwzc_wwjysqd where FDate='2012-07-07' and FQty=60


  

select FErpClsID,* from t_ICItem where left(FNumber,3)='05.'

/* �޸���߿��Ϊ������
select a.FItemID as '���ϱ���',a.FNumber as '���ϳ�����',a.FName as '����',a.FModel as '���',a.FHelpCode as 'ͼ��',
m.FName as '������λ',b.FSecInv as '��ȫ���',b.FHighLimit as '��߿��',b.FLowLimit as '��Ϳ��',c.FName as 'Ĭ�ϲֿ�',
d.FBatchAppendQty as '��������',d.FQtyMin as '��С������',d.FDailyConsume as '��������',d.FFixLeadTime as '�ɹ�����',e.FInspectionProject as '�ʼ췽��'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 
and b.FSecInv>0 and b.FHighLimit=0 and d.FQtyMin>0

update b set b.FHighLimit = b.FSecInv+d.FQtyMin from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 
and b.FSecInv>0 and b.FHighLimit=0 and d.FQtyMin>0
*/


--------�޸��˻����鷽ʽ-------
select e.* 
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 and left(a.FNumber,3)='05.'
--and e.FWthDrwChkMde = 351
and e.FWthDrwChkMde <> 351

update e set e.FWthDrwChkMde =351
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 and left(a.FNumber,3)='05.'
and e.FWthDrwChkMde <> 351

--�޸ļ�����λ
select FUnitID,FUnitGroupID,* from t_ICItem where FNumber in ('08.02.0025')

update t_ICItem set FUnitID=187,FUnitGroupID=186 where FNumber in ('08.02.0025')

select * from t_MeasureUnit 

----------������---------

select * from t_ObjectType where FName like '%������%'

select FNumber,FName,FModel,FRemark from t_barcode a left join t_ICItem b on a.FItemID=b.FItemID where left(FBarCode,10)='2012-11-12'


FErpClsID

select FErpClsID from t_ICItem where FNumber in ('05.08.4502','05.08.4503')

update t_ICItem set FErpClsID=1 where FNumber in ('05.08.4502','05.08.4503')

------------���Ͻ���-----------
select FDeleted,* from t_ICItem where FNumber in ('05.03.2002')

update t_ICItem set FDeleted=1 where FNumber in ('05.03.2002')

-----------��������ͼ�Ų�һ�µ�����---------
select FHelpCode,FChartNumber,* from t_ICItem where FHelpCode<>FChartNumber

select FNumber,FName,FModel from t_ICItem where left(FNumber,5)='01.01' and FDeleted=0 order by FName,FModel desc


-----------�޸��������ԣ����ơ��⹺��-----------
select FErpClsID,* from t_ICItem where FNumber in ('07.02.1063')

update t_ICItem set FErpClsID=1 where FNumber in ('07.02.1063')

----------�޸ĵ��۾���-----------
select FPriceDecimal,* from t_ICItem where FPriceDecimal=0

update t_ICItem set FPriceDecimal=4 where FPriceDecimal=0

-------�޸Ĳ�Ʒ���鷽ʽ FProChkMde 353����죻352 ���   ||   �������鷽ʽ FSOChkMde 
select FProChkMde,* from t_ICItem where 1=1 
and FDeleted=0
--AND (left(FNumber,3)='09.' )
and FSOChkMde=353

update t_ICItem set FSOChkMde=352 where 1=1 
and FDeleted=0
--AND (left(FNumber,3)='09.' )
and FSOChkMde=353




select FNumber,FName,FModel,FHelpCode from t_ICItem a where  1=1
and a.FDeleted=0
AND (left(a.FNumber,3)='05.')
order by a.FNumber

update a set a.FBatchManager=1
from t_ICItem a where  1=1
and a.FDeleted=0
AND (left(a.FNumber,3)='05.' or left(a.FNumber,3)='06.' or left(a.FNumber,3)='07.' or left(a.FNumber,3)='09.')
and a.FName like '%���ϺϽ�%'
and a.FBatchManager=0



select b.* from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID 
left join t_Stock c on b.FDefaultLoc=c.FItemID 
left join t_ICItemPlan d on a.FItemID=d.FItemID 
left join t_ICItemQuality e on a.FItemID=e.FItemID 
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 


select a.FItemID as '���ϱ���',a.FNumber as '���ϳ�����',a.FName as '����',a.FModel as '���',a.FHelpCode as 'ͼ��',
m.FName as '������λ',b.FQtyDecimal as '��������'
from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 
and m.FName = 'kg'
and left(a.FNumber,3)='01.'
and a.FQtyDecimal >0

update b set b.FQtyDecimal=4 from t_ICItem a 
left join t_ICItemBase b on a.FItemID=b.FItemID
LEFT JOIN t_MeasureUnit m on m.FItemID=a.FUnitID 
where 1=1 
and m.FName = 'kg'
and left(a.FNumber,3)='01.'
and a.FQtyDecimal >0


