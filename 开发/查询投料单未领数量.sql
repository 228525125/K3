--查询还未领料的投料数量
--DROP PROCEDURE query_ppbom_wlsl

CREATE PROCEDURE query_ppbom_wlsl
@FNumber nvarchar(255),
@FBatchNo nvarchar(255)
AS
BEGIN
SET NOCOUNT ON 

DECLARE @WLSL decimal(28,2)          

CREATE TABLE #data(
wldm nvarchar(255) default('')
,wlmc nvarchar(255) default('')
,wlgg nvarchar(255) default('')
,wlth nvarchar(255) default('')
,jldw nvarchar(255) default('')
,jhsl decimal(28,2) default(0) 
,llsl decimal(28,2) default(0)
,ph nvarchar(255) default('')
)

--FAuxQtyMust:计划投料数量 ;FAuxStockQty:已领数量

Insert Into #data(wldm,wlmc,wlgg,wlth,jldw,jhsl,llsl,ph
)
SELECT d.FNumber,d.FName,d.FModel,d.FHelpCode,e.FName,sum(isnull(b.FAuxQtyMust,0)),sum(isnull(b.FAuxStockQty,0)),c.FGMPBatchNo 
FROM PPBOM a 
INNER JOIN PPBOMEntry b on b.FInterID=a.FInterID 
INNER JOIN ICMO c on a.FICMOInterID=c.FInterID
LEFT JOIN t_ICItem d on b.FItemID=d.FItemID
LEFT JOIN t_MeasureUnit e on e.FItemID=d.FUnitID 
WHERE c.FStatus in (1,2)  --下达状态
AND a.FStatus=1
GROUP BY d.FNumber,d.FName,d.FModel,d.FHelpCode,e.FName,c.FGMPBatchNo

SELECT @WLSL=jhsl-llsl FROM #data WHERE jhsl>llsl AND wldm in (@FNumber) AND ph=@FBatchNo     --目前只涉及这些材料'01.01.06.048','01.01.06.050','01.01.06.049'

RETURN ISNULL(@WLSL,0)

END


DECLARE @WLSL decimal(28,2)  

EXEC @WLSL=query_ppbom_wlsl '01.01.06.050','13H15'

SELECT @WLSL



select * from PPBOM