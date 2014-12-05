--drop procedure check_wwjs

create procedure check_wwjs
@FInterID nvarchar(255)
,@FName nvarchar(255)
,@
as 
begin
IF EXISTS(select 1 from ICShop_SubcIn where FInterID=@FInterID and FStatus=0)          --单据状态必须是未审核
BEGIN
DECLARE @userID nvarchar(255)
DECLARE @FBillNo nvarchar(255)

select @userID=FUserID from t_user where FName=@FName
select @FBillNo=FBillNo from ICShop_SubcIn where FInterID=@FInterID

Update ICShop_SubcIn
SET FCheckDate=Convert(datetime,convert(varchar(30),GetDate(),111))
    ,FStatus=1,FCheckerID=@userID
Where FInterID in (@FInterID)

Insert Into ICClassCheckRecords1002523(FPage,FBillID,FBillEntryID,FBillNo, FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,FCheckMan, 
FCheckIdea,FCheckDate,FDescriptions)  Values (1,@FInterID,0,@FBillNo,0,1,2,0,@userID,'',GetDate(),'审核（外部）')
Update ICClassCheckStatus1002523 Set  FBillNo = @FBillNo, FCurrentLevel = FCurrentLevel + 1, FCheckMan1 = @userID, FCheckDate1 = GetDate(), FCheckIdea1 = '' 
Where FBillID = @FInterID And FPage = 1 And FBillEntryID = 0
END
end


exec check_wwjs 3826,'0076'
--

select * from ICClassCheckRecords1002523 where FBillID=3824


select * from ICClassCheckStatus1002523 where FBillID=3824


select b.* from ICShop_SubcIn a left join ICShop_SubcInEntry b on a.FInterID=b.FInterID where FBillNo='wwjs002827'

update ICShop_SubcInEntry set FUnitPrice= ,FBaseUnitPrice= where FEntryID=

SELECT * FROM t_user


select * from FUser