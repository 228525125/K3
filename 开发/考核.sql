
------��������ʱ��------
Select top 20000 case when v1.FStatus=0 then '�ƻ�' when v1.FStatus=5 then 'ȷ��' when v1.FStatus=1 then '�´�' when v1.FStatus=3 then '�᰸' else '' end as FStatus,v1.FBillNo as FBillNo,
i.FNumber as 'cpdm',i.FName as 'cpmc',i.FModel as 'cpgg',i.FHelpCode as 'cpth',v1.FGMPBatchNo as 'cpph',mu.FName as 'jldw',v1.FQty as 'jhsl',
Convert(char(10),v1.FPlanCommitDate,111) as 'jhkgsj',Convert(char(10),v1.FPlanFinishDate,111) as 'jhwgsj',q.FDate,q.FQty,w.FDate,w.FPassQty,o.FDate
from ICMO v1 
LEFT OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
LEFT JOIN (
select a.FICMOInterID,MIN(a.FDate) as FDate,b.FItemID,sum(b.FQty) as FQty from QMICMOCKRequest a left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID group by a.FICMOInterID,b.FItemID
) q on q.FICMOInterID=v1.FInterID and v1.FItemID=q.FItemID                              --�ͼ�����
LEFT JOIN (
select MIN(FDate) as FDate,FICMOInterID,FItemID,sum(FPassQty) as FPassQty from ICQCBill where FBillNo like 'SIPQC%' group by FICMOInterID,FItemID
) w on v1.FInterID=w.FICMOInterID and v1.FItemID=w.FItemID
LEFT JOIN (
select FInterID,FItemID,MAX(FDate) as FDate,sum(FQty) as FQty from SEOrderEntry group by FInterID,FItemID
) o on v1.FOrderInterID=o.FInterID and o.FItemID=v1.FItemID        --��������
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
AND v1.FCheckDate>='2011-09-01' AND  v1.FCheckDate<='2011-09-30'
AND v1.FStatus in (1,3)                     --״̬�������´��᰸
AND v1.FPlanFinishDate <= getDate()         --���ڴ����˵�ǰʱ��Ĳ�ͳ��
AND w.FDate is null                         -- ��ȥ��Э

--AND v1.FOrderInterID <> 0       --�Ǽƻ�����
--AND q.FDate <= o.FDate        --��ɶ�������
--AND v1.FOrderInterID = 0      --���Ǽƻ�����

--AND (q.FDate is null or q.FDate > v1.FPlanFinishDate)      --δ���
AND (q.FDate is not null and q.FDate <= v1.FPlanFinishDate) --���

AND left(i.FNumber,2)='05'
order by v1.FBillNo





select v1.* from ICMO v1
LEFT OUTER JOIN t_Department t8 ON   v1.FWorkShop = t8.FItemID  AND t8.FItemID<>0 
LEFT JOIN t_ICItem i on v1.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=v1.FUnitID 
where 1=1 
AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FCancellation = 0))
--AND v1.FCheckDate>='2011-09-01' AND  v1.FCheckDate<='2011-09-30'
AND v1.FStatus in (1,3)
AND left(i.FNumber,2)='05' 
AND v1.FBillNo = 'WORK000088'

select b.FDate,b.FItemID,i.FNumber,i.FName,b.* from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID
left join t_ICItem i on b.FItemID=i.FItemID
where FBillNo = 'SEORD002223'

select a.FICMOInterID,a.FDate,b.FItemID,b.FQty from QMICMOCKRequest a left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID where FICMOInterID='9215'

select * from ICQCBill where FBillNo like 'SIPQC%'


-------�ɹ���ʱ��-------
--�⹺--
select a.FBillNo as '���ݱ��',a.FDate as '��������',b.FDate as '�ɹ�����',d.FBillNo,d.FDate as '��������',i.FNumber as '��Ʒ����',i.FName as '��������',i.FModel as '���',mu.FName as '��λ',b.FQty as '����'
from POOrder a 
left join POOrderEntry b on a.FInterID=b.FInterID 
left join POInStockEntry c on c.FOrderInterID=b.FInterID and c.FOrderBillNo=a.FBillNo and c.FOrderEntryID=b.FEntryID
left join POInStock d on c.FInterID=d.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1
AND a.FCancellation = 0
AND b.FDate >= '2011-10-08' and b.FDate <= '2011-10-31'
AND a.FStatus > 0     --0��δ���  1�����δ�ر�  2�������й�  3���ر� 
AND b.FDate <= getDate()

--AND d.FDate <= b.FDate                          --��ʱ����
AND (d.FDate is null or d.FDate > b.FDate)        --δ��ʱ����


--��Э--
select * from POInStockEntry

select * from POOrder a 
left join POOrderEntry b on a.FInterID=b.FInterID 
where 1=1 
AND a.FDate >= '2011-09-01' and a.FDate <= '2011-09-30'

---------���鼰ʱ��--------
--��Ʒ--
select a.FBillNo as '���ݱ��',a.FDate as '����ʱ��',c.FDate as '����ʱ��',i.FNumber as '��Ʒ����',i.FName as '��������',i.FModel as '���',mu.FName as '��λ',b.FQty as '����'
from QMICMOCKRequest a 
left join QMICMOCKRequestEntry b on a.FInterID=b.FInterID and b.FInterID<>0
inner join (select DISTINCT FInStockInterID,MIN(FDate) as FDate from ICQCBill group by FInStockInterID) c on c.FInStockInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
where 1=1 
AND (a.FTranType=701 AND (a.FCancellation = 0))
AND a.FStatus > 0
AND a.FDate>='2011-10-08' AND a.FDate<='2011-10-31'

--AND datediff(day,a.FDate,c.FDate)<=1   --���
AND ((datediff(day,a.FDate,c.FDate)>1 
and a.FDate<>'2011-10-18' 
and a.FDate<>'2011-10-15' 
and a.FDate<>'2011-10-22'
and a.FDate<>'2011-10-29'
and a.FDate<>'2011-11-05'
and a.FDate<>'2011-11-12'
and a.FDate<>'2011-11-19'
and a.FDate<>'2011-11-26'
and a.FDate<>'2011-12-03'
and a.FDate<>'2011-12-10'
and a.FDate<>'2011-12-17'
and a.FDate<>'2011-12-24'
and a.FDate<>'2011-12-31'
and a.FDate<>'2012-01-07'
and a.FDate<>'2012-01-14'
and a.FDate<>'2012-01-21'
and a.FDate<>'2012-01-28'
and a.FDate<>'2012-02-04'
and a.FDate<>'2012-02-11'
and a.FDate<>'2012-02-18'
and a.FDate<>'2012-02-25'
and a.FDate<>'2012-03-03'
and a.FDate<>'2012-03-10'
and a.FDate<>'2012-03-17'
and a.FDate<>'2012-03-24'
and a.FDate<>'2012-03-31'
) or (a.FDate in (
'2011-10-18', 
'2011-10-15',
'2011-10-22',
'2011-10-29',
'2011-11-05',
'2011-11-12',
'2011-11-19',
'2011-11-26',
'2011-12-03',
'2011-12-10',
'2011-12-17',
'2011-12-24',
'2011-12-31',
'2012-01-07',
'2012-01-14',
'2012-01-21',
'2012-01-28',
'2012-02-04',
'2012-02-11',
'2012-02-18',
'2012-02-25',
'2012-03-03',
'2012-03-10',
'2012-03-17',
'2012-03-24',
'2012-03-31'
) and datediff(day,a.FDate,c.FDate)>2))   --δ���
order by a.FBillNo

--�⹺--
select a.FBillNo as '���ݱ��',a.FDate as '����ʱ��',c.FDate as '����ʱ��',i.FNumber as '��Ʒ����',i.FName as '��������',i.FModel as '���',mu.FName as '��λ',b.FQty as '����'
from POInstock a 
INNER JOIN POInstockEntry b ON  a.FInterID = b.FInterID  AND b.FInterID<>0 
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
left join (select DISTINCT FInStockInterID,MIN(FDate) as FDate from ICQCBill where 1=1 AND (FTranType=711 AND (FCancellation = 0)) group by FInStockInterID) c on c.FInStockInterID=b.FInterID
where 1=1
AND (a.FTranType=702 AND (A.FCancellation = 0))
AND a.FDate>='2011-10-01' AND a.FDate<='2011-10-31'
AND a.FStatus > 0

--AND datediff(day,a.FDate,c.FDate)=0   --���
--AND (c.FDate is null or datediff(day,a.FDate,c.FDate)>0)   --δ���
order by a.FBillNo


--------��Э��ʱ��--------
select a.FBillNo as '���ݱ��',a.FCheckDate as '��������',b.FFetchDate as '��������',c.FDate as '����ʱ��',i.FNumber as '��Ʒ����',i.FName as '��������',i.FModel as '���',mu.FName as '��λ',b.FOperTranOutQty as '����' 
from ICShop_SubcOut a 
left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID
LEFT JOIN t_ICItem i on b.FItemID = i.FItemID 
LEFT JOIN t_MeasureUnit mu on mu.FItemID=b.FUnitID 
LEFT JOIN (
select FSHSubcOutInterID,FSHSubcOutEntryID,MIN(FDate) as FDate from ICQCBill where 1=1 AND (FTranType=715 AND (FCancellation = 0)) group by FSHSubcOutInterID,FSHSubcOutEntryID
) c on b.FInterID=c.FSHSubcOutInterID and b.FEntryID=c.FSHSubcOutEntryID
where 1=1
AND FClassTypeID=1002521
AND a.FStatus > 0
AND a.FCheckDate>='2011-09-01' and a.FCheckDate<='2011-09-30'
AND b.FFetchDate <= getDate()

AND c.FDate <= b.FFetchDate                    --���
--AND (c.FDate is null or c.FDate>b.FFetchDate)  --δ���

select * from ICQCBill where 1=1 AND (FTranType=715 AND (FCancellation = 0)) and FBillNo='SIPQC001163'

SELECT * FROM ICShop_SubcOut a left join ICShop_SubcOutEntry b on a.FInterID=b.FInterID WHERE a.FCheckDate>='2011-09-01' and a.FCheckDate<='2011-09-30'
 and FBillNo = 'WWZC000948'
