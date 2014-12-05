--drop procedure check_cgsq drop procedure uncheck_cgsq

create procedure check_cgsq
@FInterID int              --µ¥¾ÝÄÚÂë
,@FName nvarchar(255)                   --ÉóºËÈË
as 
begin
SET NOCOUNT ON 
DECLARE @FCurCheckLevel int
DECLARE @FUserID int

select @FCurCheckLevel=FCurCheckLevel from PORequest where FInterID=@FInterID
select @FUserID=FUserID from t_user where FName=@FName

if (@FCurCheckLevel is null or @FCurCheckLevel=0)
begin
	UPDATE PORequest SET FPlanConfirmed=1 WHERE FInterID=@FInterID
	Update POrequest Set FMultiCheckLevel1 = @FUserID, FMultiCheckDate1 = convert(char(10),getDate(),120), FCurCheckLevel = 1  Where FInterID = @FInterID And FTranType =70
end
else if @FCurCheckLevel = 1 
begin
	UPDATE PORequest SET FPlanConfirmed=1 WHERE FInterID=@FInterID
	Update POrequest Set FMultiCheckLevel2 = @FUserID, FMultiCheckDate2 = convert(char(10),getDate(),120), FCurCheckLevel = 2  Where FInterID = @FInterID And FTranType =70
end
else if @FCurCheckLevel = 2 
begin
	UPDATE PORequest SET FPlanConfirmed=1 WHERE FInterID=@FInterID
	Update POrequest Set FMultiCheckLevel3 = @FUserID, FMultiCheckDate3 = convert(char(10),getDate(),120), FCurCheckLevel = 3  Where FInterID = @FInterID And FTranType =70
end
else if @FCurCheckLevel = 3 
begin
	UPDATE PORequest SET FPlanConfirmed=1 WHERE FInterID=@FInterID
	Update POrequest Set FMultiCheckLevel4 = @FUserID, FMultiCheckDate4 = convert(char(10),getDate(),120), FCurCheckLevel = 4  Where FInterID = @FInterID And FTranType =70
	Update PORequest Set FCheckerID=@FUserID,FStatus=1,FCheckTime=convert(char(10),getDate(),120),FPlanConfirmed=1 WHERE FInterID=@FInterID
end
end

--·´ÉóºË--
create procedure uncheck_cgsq
@FInterID int              --µ¥¾ÝÄÚÂë
,@FName nvarchar(255)                   --ÉóºËÈË
as 
begin
SET NOCOUNT ON 
DECLARE @FCurCheckLevel int
DECLARE @FClosed int
DECLARE @FStatus int 
DECLARE @FChildren int
DECLARE @FUserID int

select @FCurCheckLevel=FCurCheckLevel,@FClosed=FClosed,@FStatus=FStatus,@FChildren=FChildren from PORequest where FInterID=@FInterID
select @FUserID=FUserID from t_user where FName=@FName

if (@FCurCheckLevel = 4 and @FClosed=0 and @FStatus<>3 and @FChildren=0)
begin
	Update POrequest Set FMultiCheckLevel4 = Null , FMultiCheckDate4 = Null , FCurCheckLevel = 3  Where FInterID = @FInterID And FTranType =70
	Update PORequest Set FCheckerID=Null,FStatus=0,FCheckTime=Null WHERE FInterID=@FInterID
	select 'ÉóºË³É¹¦£¡' as result
end
else if @FCurCheckLevel = 3 
begin
	Update POrequest Set FMultiCheckLevel3 = Null , FMultiCheckDate3 = Null , FCurCheckLevel = 2  Where FInterID = @FInterID And FTranType =70	
	select 'ÉóºË³É¹¦£¡' as result
end
else if @FCurCheckLevel = 2 
begin
	Update POrequest Set FMultiCheckLevel2 = Null , FMultiCheckDate2 = Null , FCurCheckLevel = 1  Where FInterID = @FInterID And FTranType =70
	select 'ÉóºË³É¹¦£¡' as result
end
else if @FCurCheckLevel = 1 
begin
	Update POrequest Set FMultiCheckLevel1 = Null , FMultiCheckDate1 = Null , FCurCheckLevel = 0  Where FInterID = @FInterID And FTranType =70
	select 'ÉóºË³É¹¦£¡' as result
end
else
select '·´ÉóºËÊ§°Ü£¬Çë¼ì²é£¡' as result
end




execute check_cgsq 77,'chenxian'

execute uncheck_cgsq 2236,'0002'

select * from PORequest a left join PORequestEntry b on a.FInterID=b.FInterID where FBillNo in ('POREQ000062')

select FClosed,FStatus,FChildren,* from POrequest where FBillNo in('POREQ000016','POREQ000017','POREQ000060')

