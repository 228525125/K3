--¥Ú”°ŒÔ¡œø®
--drop procedure print_bom


create procedure print_bom 
@query nvarchar(255)
as 
begin
SET NOCOUNT ON 
create table #temp(
FBillNo nvarchar(255) default('')
,FName nvarchar(255) default('')
,FHelpCode nvarchar(255) default('')
,FModel nvarchar(255) default('')
,FNumber nvarchar(255) default('')
,FBatchNo nvarchar(255) default('')
,FDate nvarchar(255) default('')           
,FICMOBillNo nvarchar(255) default('')
)


Insert Into #temp(FBillNo,FName,FHelpCode,FModel,FNumber,FBatchNo,FDate,FICMOBillNo
)
select a.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,a.FBatchNo,Convert(char(10),a.FDate,120) as FDate,v.FICMOBillNo
from ICQCBill a 
left join t_ICItem i on a.FItemID=i.FItemID 
left join (select FBillNo,FICMOBillNo from View_ProductInspectionSlip713 group by FBillNo,FICMOBillNo) v on v.FBillNo = a.FBillNo
left join ICMO o on v.FICMOBillNo=o.FBillNo
left join (select a.FInterID,b.FEntryID,MIN(b.FEntrySelfS0161) as FNote from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID group by a.FInterID,b.FEntryID) s on s.FInterID=o.FOrderInterID and s.FEntryID=o.FSourceEntryID
where a.FBillNo like '%'+@query+'%'

select top 1 * from #temp
end


execute print_bom '36642'



