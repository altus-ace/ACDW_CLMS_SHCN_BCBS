


CREATE  FUNCTION [adw].[tvf_BCBS_SubscriberID_To_PatientID_Conversion](@LoadDate DATE )
RETURNS TABLE
AS RETURN 
(
		 SELECT	 *
		 FROM	(
		 			SELECT  DISTINCT  RTRIM(LTRIM(REPLACE(a.SubscriberID,'''',' ')))MemberID
							,b.SubscriberID 
							,b.PatientID AS ClientMemberKey
		 			FROM	 [adi].Steward_BCBS_Membership a
		 			JOIN	 [adi].Steward_BCBS_MemberCrosswalk b
		 			ON		 RTRIM(LTRIM(REPLACE(a.SubscriberID,'''',' '))) =b.SubscriberID
		 		)z   
)


