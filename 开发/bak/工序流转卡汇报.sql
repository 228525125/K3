select * from SHProcRptMain

select * from SHProcRpt


select 
a.FBillNo as '���ݱ��'
,convert(char(10),a.FDate,120) as '��������'
,b.FFlowCardNO as '��ת�����' 
,b.FOperSN as '�����'
,c.FName as '����'
,case when b.FStatus=1 then '���ɹ�' when b.FStatus=2 then '�Ѵ�ӡ' when b.FStatus=3 then '����' when b.FStatus=4 then '�깤' when b.FStatus=5 then 'ί��ת��' when b.FStatus=6 then 'ί�����' when b.FStatus=7 then '��ͣ' when b.FStatus=8 then 'ȡ��' end as '״̬'
--,b.FIsOut as '�Ƿ���Э'
--,b.FTeamTimeID as '���'
,d.FName as '����'
,emp.FName as '������'
,res1.FNumber as '�豸���1'
,res1.FName as '�豸����1'
,res2.FNumber as '�豸���2'
,res2.FName as '�豸����2'
,b.FStartWorkDate as 'ʵ�ʿ���ʱ��'
,b.FEndWorkDate as 'ʵ���깤ʱ��'
,cast(cast(DATEDIFF(n,b.FStartWorkDate,b.FEndWorkDate) as decimal(28,2))/60 as decimal(28,2)) as '��ҵʱ��'
,mu.FName as '��λ'
,b.FAuxQtyfinish as 'ʵ������'
--,b.FAuxQtyPass as '�ϸ�����'
,b.FAuxQtyScrap as '�򹤱�������'
,b.FAuxQtyForItem as '���ϱ�������'
--,b.FAuxReprocessedQty as '��������'
,b.FTimeUnit as 'ʱ�䵥λ'
,i.FNumber as '��Ʒ����'
,i.FName as '��Ʒ����'
,i.FModel as '��Ʒ���'
,i.FHelpCode as '��Ʒͼ��'
,b.FICMOBillNo as '�������񵥺�'
from SHProcRptMain a
left join SHProcRpt b on a.FInterID=b.FInterID
left join (select FInterID,FName from t_SubMessage where FTypeID=61) c on c.FInterID=b.FOperID
left join (select FInterID,FName from t_SubMessage where FTypeID=62) d on d.FInterID=b.FTeamID
left join t_emp emp on b.FWorkerID=emp.FItemID
left join t_resource res1 on res1.FInterID=b.FShebei
left join t_resource res2 on res2.FInterID=b.FShebei2
left join t_ICItem i on b.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID
where 1=1
and a.FDate>='2012-10-01' and a.FDate<='2012-10-31'
and b.FICMOBillNo ='WORK017537'


select b.FICMOBillNo as '�������񵥺�'
,b.FOperSN as '�����'
,c.FName as '����'
,case when b.FStatus=1 then '���ɹ�' when b.FStatus=2 then '�Ѵ�ӡ' when b.FStatus=3 then '����' when b.FStatus=4 then '�깤' when b.FStatus=5 then 'ί��ת��' when b.FStatus=6 then 'ί�����' when b.FStatus=7 then '��ͣ' when b.FStatus=8 then 'ȡ��' end as '״̬'
,res1.FNumber as '�豸���'
,res1.FName as '�豸����'
,i.FNumber as '��Ʒ����',i.FName as '��Ʒ����',i.FModel as '��Ʒ���',i.FHelpCode as 'ͼ��',mu.FName as '��λ',sum(b.FAuxQtyfinish) as 'ʵ������',sum(b.FAuxQtyScrap) as '����',sum(b.FAuxQtyForItem) as '�Ϸ�','Сʱ' as 'ʱ�䵥λ',sum(cast(cast(DATEDIFF(n,b.FStartWorkDate,b.FEndWorkDate) as decimal(28,2))/60 as decimal(28,2))) as '��ҵʱ��'
from SHProcRptMain a
left join SHProcRpt b on a.FInterID=b.FInterID
left join (select FInterID,FName from t_SubMessage where FTypeID=61) c on c.FInterID=b.FOperID
left join (select FInterID,FName from t_SubMessage where FTypeID=62) d on d.FInterID=b.FTeamID
left join t_emp emp on b.FWorkerID=emp.FItemID
left join t_resource res1 on res1.FInterID=b.FShebei
left join t_resource res2 on res2.FInterID=b.FShebei2
left join t_ICItem i on b.FItemID=i.FItemID
LEFT JOIN t_MeasureUnit mu on mu.FItemID=i.FUnitID
LEFT JOIN ICMO icmo on b.FICMOBillNo=icmo.FBillNo
where 1=1
and a.FDate>='2012-10-01' and a.FDate<='2012-10-31'
and icmo.FStatus=1         --����״̬���´�
group by b.FICMOBillNo,b.FOperSN,c.FName,b.FStatus,res1.FNumber,res1.FName,i.FNumber,i.FName,i.FModel,i.FHelpCode,mu.FName
order by b.FICMOBillNo,b.FOperSN







select * from t_emp

select * from t_resource




--�豸��ţ��豸���ƣ����ϴ��룬�������ƣ���λ��ʵ���������豸����ʱ�䣬�˹�����ʱ�䣬��������


select * from t_SubMesType 

select * from t_SubMessage where FTypeID=61

