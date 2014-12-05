

create procedure getMsg 
@msg nvarchar(255)
as 
begin
exec(@msg)
end


exec getMsg 'ø‚¥Ê”‡∂Ó'