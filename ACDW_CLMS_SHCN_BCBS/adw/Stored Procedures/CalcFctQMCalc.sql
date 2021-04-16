
/*
2020-11-19 SN. Modify to incorporate Addressed
*/





CREATE PROCEDURE [adw].[CalcFctQMCalc]
	(
	@ClientKeyID	VARCHAR(2),
	@RunDate			DATE,
	@QMDate			DATE,
	@KPIStartDate	DATE,
	@KPIEndDate		DATE
	)
AS    
BEGIN
    SET NOCOUNT ON;

	INSERT INTO [adw].[FctQMCalc]
         ([SrcFileName]
		   ,[AdiKey]
         ,[LoadDate]
         ,[DataDate]
         ,[ClientKey]
         ,[ClientMemberKey]
         ,[EffectiveAsOfDate]
			,[PrimSvcYr]
		   ,[PrimSvcMth]
         ,[Seq_ClaimID]
         ,[PrimaryServiceDate]
         ,[ValueCodeSystem]
         ,[ValueCode]
         ,[QmMsrID]
         ,[QmDate]
         ,[AttribNPI]
         ,[AttribTIN]
			,[AddressedFlg]
			,[AddressedSrc]
			,[AddressedDate])
	SELECT  DISTINCT CONCAT('[adw].[FctQMCalc]',@KPIStartDate,'-',@KPIEndDate)
			,b.QMValueCodeKey
			,GETDATE()
			,@RunDate
			,a.ClientKey
			,a.ClientMemberKey
			,@RunDate								AS [EffectiveAsOfDate]
			,YEAR(b.ValueCodePrimarySvcDate)
			,MONTH(b.ValueCodePrimarySvcDate)
			,''
			,b.ValueCodePrimarySvcDate
			,b.ValueCodeSystem
			,b.ValueCode
			,b.QmMsrID
			,b.QmDate
			,a.NPI
			,a.PcpPracticeTIN	
			,0
			,''
			,b.QmDate
		FROM [adw].[2020_tvf_Get_ActiveMembersFull]	(@RunDate) a
		--JOIN (
		--		SELECT QmMsrId, ClientMemberKey, QMDate
		--			,1 as CntMbr
		--			,case when QmCntCat = 'DEN' then 1 else 0 end as Den
		--			,case when QmCntCat = 'NUM' then 1 else 0 end as Num
		--			,case when QmCntCat = 'COP' then 1 else 0 end as Cop
		--			,case when QmCntCat = 'COP' AND Addressed = 1 then 1 else 0 end as Add2Num
		--			,case when QmCntCat = 'COP' AND Addressed = 1 then 1 else 0 end as SubCop
		--		FROM adw.QM_ResultByMember_History
		--		WHERE QMDate = @QMDate
		--		) q
		--	ON a.ClientMemberKey = q.ClientMemberKey
		--	AND 
		JOIN [adw].[QM_ResultByValueCodeDetails_History] b
			ON a.ClientMemberKey = b.ClientMemberKey
			AND a.ClientKey		= b.ClientKey
		WHERE b.QmCntCat = 'NUM'
		AND b.QmDate = @QMDate
		AND b.ValueCodePrimarySvcDate BETWEEN @KPIStartDate AND Getdate()

END;												

/***
EXEC [adw].[CalcFctQMCalc] 16,'2021-03-15','2021-03-15','2020-01-01','2021-03-30'

SELECT  *
FROM adw.FctQMCalc order by EffectiveAsOfDAte Desc
***/

