select a.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,a.FBatchNo,u.FName,Convert(char(10),a.FDate,120) as FDate,v.FICMOBillNo
from ICQCBill a 
left join t_ICItem i on a.FItemID=i.FItemID 
left join t_User u on a.FCheckerID=u.FUserID 
left join (select FBillNo,FICMOBillNo from View_ProductInspectionSlip713 group by FBillNo, FICMOBillNo) v on v.FBillNo = a.FBillNo 
where a.FBillNo='FQC010546'


select * from ICQCBill where FBillNo='FQC010529'

select * from QMICMOCKRequest

select * from QMICMOCKRequestEntry

select * from ICQCScheme

select * from View_ProductInspectionRequest701

select * from View_ProductInspectionSlip713 where FBillNo='FQC010546'


select FBillNo from View_ProductInspectionSlip713 where FICMOBillNo like '%%' group by FBillNo

select a.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,a.FBatchNo,u.FName as FUser,Convert(char(10),a.FDate,120) as FDate,v.FICMOBillNo from ICQCBill a left join t_ICItem i on a.FItemID=i.FItemID left join t_User u on a.FCheckerID=u.FUserID left join (select FBillNo,FICMOBillNo from View_ProductInspectionSlip713 group by FBillNo, FICMOBillNo) v on v.FBillNo = a.FBillNo where a.FBillNo like '%050531' 






select * from t_user



select a.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,a.FBatchNo,u.UName,Convert(char(10),a.FDate,120) as FDate from ICQCBill a left join t_ICItem i on a.FItemID=i.FItemID left join t_User u on a.FCheckerID=u.FUserID where FBillNo='FQC010542' 



ALTER TABLE coc1 ADD wlth nvarchar(255)

select * from coc1 where Convert(char(10),djrq,120)>='2015-04-01' order by djrq desc


