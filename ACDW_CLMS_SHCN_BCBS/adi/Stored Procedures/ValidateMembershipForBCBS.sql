

	CREATE PROCEDURE adi.ValidateMembershipForBCBS(@MembershipDataDate DATE
												,@MembershipCrWlkDataDate DATE)

	AS

		--Membership
	SELECT				COUNT(*)RecCnt, DataDate
	FROM				adi.Steward_BCBS_Membership
	GROUP BY			DataDate
	ORDER BY			DataDate DESC
	
		--Membership Crosswalk
	SELECT				COUNT(*)RecCnt, DataDate
	FROM				adi.Steward_BCBS_MemberCrosswalk
	GROUP BY			DataDate
	ORDER BY			DataDate DESC

		
	--  DECLARE @MembershipDataDate DATE = '2021-02-18'	  DECLARE @MembershipCrWlkDataDate DATE = '2021-02-18'

	----Joining both membership to ascertain valid members
	SELECT				a.SubscriberID,e.SubscriberID,a.PatientID,e.PatientID,Indicator834
						,a.DataDate,e.DataDate,MemberAttributedStatus
	FROM				adi.Steward_BCBS_Membership a
	JOIN				(	SELECT		* 
							FROM		adi.Steward_BCBS_MemberCrosswalk
							WHERE		Indicator834 = 'Y'
							AND			DataDate = @MembershipCrWlkDataDate
						)e
	ON					a.PatientID = e.PatientID
	AND					a.SubscriberID = e.SubscriberID
	WHERE				a.DataDate = @MembershipDataDate

	SELECT		COUNT(*) AS RecCntFromCrossWalk 
	FROM		(
	SELECT		* 
	FROM		adi.Steward_BCBS_MemberCrosswalk
	WHERE		Indicator834 = 'Y'
	AND			DataDate = @MembershipCrWlkDataDate --'2021-02-18'
				) a

	SELECT		COUNT(*) AS RecCntMembership
	FROM		(
	SELECT		* 
	FROM		adi.Steward_BCBS_Membership
	WHERE		DataDate = @MembershipDataDate --'2021-02-18'
	AND			MemberAttributedStatus IN ('ADD','REINSTATE', 'CONTINUE' ) -- 'TERM-ATTR','TERM-ELIG'
				)a

	---Joining with lst PCP
			---Drop Table #Moi
		SELECT			DISTINCT PatientID,MemberAttributedStatus
		FROM			(
								SELECT				a.SubscriberID,a.PatientID,Indicator834
													,a.DataDate,MemberAttributedStatus,a.AttributedPrimaryCareProviderNPI
											--		INTO #Moi
								FROM				adi.Steward_BCBS_Membership a
								JOIN				(	SELECT		* 
														FROM		adi.Steward_BCBS_MemberCrosswalk
														WHERE		Indicator834 = 'Y'
														AND			DataDate = @MembershipCrWlkDataDate
													)e
								ON					a.PatientID = e.PatientID
								AND					a.SubscriberID = e.SubscriberID
								WHERE				a.DataDate = @MembershipDataDate
						)z
		JOIN			lst.List_PCP e
		ON				z.AttributedPrimaryCareProviderNPI = e.PCP_NPI
		
		
