--drop procedure print_coc  drop procedure print_coc_scrw 

create procedure print_coc 
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
,FUser nvarchar(30) default('')          
,FDate nvarchar(255) default('')           
,FICMOBillNo nvarchar(255) default('')       
,FNote nvarchar(255) default('')      --订单备注
,LH nvarchar(255) default('')
,EX nvarchar(255) default('')
,caizhi nvarchar(255) default('')
,beizhu nvarchar(255) default('')     --任务单备注
)


Insert Into #temp(FBillNo,FName,FHelpCode,FModel,FNumber,FBatchNo,FUser,FDate,FICMOBillNo,FNote,LH,EX,caizhi,beizhu
)
select a.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,a.FBatchNo,u.FFullNumber as FUser,Convert(char(10),a.FDate,120) as FDate,v.FICMOBillNo,isnull(s.FNote,''),'',i.FApproveNo,i.FAlias,o.FNote
from ICQCBill a 
left join t_ICItem i on a.FItemID=i.FItemID 
left join t_Item u on a.FFManagerID=u.FItemID 
left join (select FBillNo,FICMOBillNo from View_ProductInspectionSlip713 group by FBillNo,FICMOBillNo) v on v.FBillNo = a.FBillNo
left join ICMO o on v.FICMOBillNo=o.FBillNo
left join (select a.FInterID,b.FEntryID,MIN(b.FEntrySelfS0161) as FNote from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID group by a.FInterID,b.FEntryID) s on s.FInterID=o.FOrderInterID and s.FEntryID=o.FSourceEntryID
where a.FBillNo like '%'+@query+'%'

DECLARE @LH nvarchar(255)  
DECLARE @PH nvarchar(255)  
select top 1 @PH=FBatchNo from #temp

EXEC query_lh @PH,@LH output

update #temp set lh=@LH

update #temp set EX=' ' where EX is null

select top 1 * from #temp
end


--select b.FEntrySelfS0161 from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID where a.FBillNo='SEORD007638'--a.FHeadSelfS0150 is not null

--收任务单号-- drop procedure print_coc_scrw

create procedure print_coc_scrw 
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
,FUser nvarchar(30) default('')          
,FDate nvarchar(255) default('')           
,FICMOBillNo nvarchar(255) default('')       
,FNote nvarchar(255) default('')
,LH nvarchar(255) default('')
,EX nvarchar(255) default('')
,caizhi nvarchar(255) default('')
,beizhu nvarchar(255) default('')     --任务单备注
)


Insert Into #temp(FBillNo,FName,FHelpCode,FModel,FNumber,FBatchNo,FUser,FDate,FICMOBillNo,FNote,LH,EX,caizhi,beizhu
)
select o.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,o.FGMPBatchNo,'0225' as FUser,Convert(char(10),getDate(),120) as FDate,o.FBillNo as FICMOBillNo,isnull(s.FNote,''),o.FHeadSelfJ0184,i.FApproveNo,i.FAlias,o.FNote
from ICMO o 
left join (select a.FInterID,b.FEntryID,MIN(b.FEntrySelfS0161) as FNote from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID group by a.FInterID,b.FEntryID) s on s.FInterID=o.FOrderInterID and s.FEntryID=o.FSourceEntryID
left join t_ICItem i on o.FItemID=i.FItemID 
where o.FBillNo like '%'+@query+'%'

DECLARE @LH nvarchar(255)  
DECLARE @PH nvarchar(255)  
select top 1 @PH=FBatchNo from #temp

EXEC query_lh @PH,@LH output

update #temp set lh=@LH

update #temp set EX=' ' where EX is null

select top 1 * from #temp
end

--接收流转卡号 drop procedure print_coc_lzk

create procedure print_coc_lzk 
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
,FUser nvarchar(30) default('')          
,FDate nvarchar(255) default('')           
,FICMOBillNo nvarchar(255) default('')       
,FNote nvarchar(255) default('')
,LH nvarchar(255) default('')
,EX nvarchar(255) default('')
,caizhi nvarchar(255) default('')
,beizhu nvarchar(255) default('')     --任务单备注
)


Insert Into #temp(FBillNo,FName,FHelpCode,FModel,FNumber,FBatchNo,FUser,FDate,FICMOBillNo,FNote,LH,EX,caizhi,beizhu
)
select o.FBillNo,i.FName,i.FHelpCode,i.FModel,i.FNumber,o.FGMPBatchNo,'0225' as FUser,Convert(char(10),getDate(),120) as FDate,o.FBillNo as FICMOBillNo,isnull(s.FNote,''),o.FHeadSelfJ0184,i.FApproveNo,i.FAlias,o.FNote
from ICMO o 
left join (select a.FInterID,b.FEntryID,MIN(b.FEntrySelfS0161) as FNote from SEOrder a left join SEOrderEntry b on a.FInterID=b.FInterID group by a.FInterID,b.FEntryID) s on s.FInterID=o.FOrderInterID and s.FEntryID=o.FSourceEntryID
left join t_ICItem i on o.FItemID=i.FItemID 
left join ICShop_FlowCard f on f.FSourceBillNo = o.FBillNo
where f.FFlowCardNo like '%'+@query+'%'

DECLARE @LH nvarchar(255)  
DECLARE @PH nvarchar(255)  
select top 1 @PH=FBatchNo from #temp

EXEC query_lh @PH,@LH output

update #temp set lh=@LH

update #temp set EX=' ' where EX is null

select top 1 * from #temp
end

execute print_coc '45065'

execute print_coc_scrw '36934'

execute print_coc_lzk '13984'

select * from ICMO where FBillNo='WORK012412'

select * from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 


select FFManagerID,* from ICQCBill 

select * from t_User where 


select * from t_Item where FItemID=167


select * from coc1

update coc1 set caizhi=''