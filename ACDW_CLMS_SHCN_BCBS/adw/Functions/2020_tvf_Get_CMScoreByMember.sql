-- =============================================
-- Author:		Si Nguyen
-- Create date: 10/16/19
-- Description:	Get Activities by Member from Altruista
-- =============================================
CREATE FUNCTION [adw].[2020_tvf_Get_CMScoreByMember]
	(	
		@ClientKey			INT,
		@PastActivityMonth	INT
	)
RETURNS TABLE 
AS
RETURN 
(
	WITH CTE AS (
	SELECT  DISTINCT
		b.[ClientMemberKey]					as MemberID
		,convert(DATE, b.ActivityCreatedDate)	as ActDate
		,CareActivityTypeName				as Activity
		,ActivityOutcome						as ActivityOutcome
		,CASE ActivityOutcome	WHEN 'Left a Message'					THEN	.5
										WHEN 'Barrier Physician Workflow'	THEN	1
										WHEN 'Educational Materials Sent'	THEN	2
										WHEN 'Fax Sent'							THEN	2
										WHEN 'Letter Sent'						THEN	2
										WHEN 'Appointment Scheduled'			THEN	3
										WHEN 'Cancellation'						THEN	3
										WHEN 'Acknowledged'						THEN	2
										WHEN 'Appointment no show'				THEN	4
										WHEN 'Attended'							THEN	4
										WHEN 'Rescheduled'						THEN	4
										WHEN 'Appointment Attendance Confirmed'	THEN	5
										WHEN 'Appointment Completed'			THEN	5
										WHEN 'Refused'								THEN	-2
										WHEN 'Disconnected Number'				THEN	-2
			ELSE 0 END As UnitScore	
		,1 as Qty
	FROM [adw].[mbrActivities] b
	WHERE DATEDIFF(mm,b.ActivityCreatedDate,GETDATE()) <= @PastActivityMonth
	AND ActivityOutcome NOT IN (
			'Data Found'
			,'MDB'
			,'Member Termed'
			,'MSSP Refusal Letter'
			,'NA'
			,'No Contact Information Available'
			,'No Data Available'
			,'Other'
			,'Unable to Reach' 
			,'Update Member Demographics'
			,'WN'
			,'Completed'
			,'Acknowledged'
	)
)
SELECT MemberID, SUM(UnitScore * Qty) as TotScore
	--select *
	FROM CTE t2
	--where memberID = '1EP3AC0KV16'
	GROUP BY t2.MemberID
)

/***
Usage:
SELECT * FROM [adw].[2020_tvf_Get_CMScoreByMember] (16,12)
***/
