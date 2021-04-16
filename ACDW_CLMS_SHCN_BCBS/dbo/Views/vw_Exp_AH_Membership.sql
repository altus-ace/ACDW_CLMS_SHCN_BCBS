
CREATE VIEW [dbo].[vw_Exp_AH_Membership]
AS

    /* version history:
    04/26/2020 - Created temp view for AHS initial export - RA
    10/19/2020: GK = Added support to use the RwEff/RwExp date to get the latest state of the membership, export active 0 and 1.
    01/28/2021: GK : added to BCBS catelog 
    02/25/2021: GK: PV ask to use the where mbr.SubgrpName <> 'COMM_Market is unknown' -- bcbs filter (these members do not have a valid plan)
	   to suppress the members with invalid plans from being sent to ahs
    */

     SELECT DISTINCT 
            mbr.clientmemberkey AS Member_id,
            lc.CS_Export_LobName AS [CLIENT_ID], 
            'N/A' AS MEDICAID_ID, 
            Mbr.FirstName AS [MEMBER_FIRST_NAME], 
            Mbr.MiddleName AS [MEMBER_MI], 
            Mbr.LastName AS [MEMBER_LAST_NAME], 
            Mbr.DOB AS [DATE_OF_BIRTH], 
            Mbr.Gender AS [MEMBER_GENDER], 
            Mbr.Memberhomeaddress + ' ' + Mbr.Memberhomeaddress1 AS [HOME_ADDRESS], 
            Mbr.MemberhomeCity AS [HOME_CITY], 
            Mbr.MemberHomeState AS [HOME_STATE], 
            Mbr.MemberHomeZip AS [HOME_ZIPCODE],
            CONCAT(mbr.MembermailingAddress , ' ' , mbr.MembermailingAddress1)
                AS [MAILING_ADDRESS],
            mbr.MemberMailingCity
                AS [MAILING_CITY],
             mbr.MemberMailingState
                AS [MAILING_STATE],
           mbr.MemberHomeZip
                 AS [MAILING_ZIP], 
            mbr.MemberPhone AS [HOME_PHONE], 
            mbr.MemberHomePhone AS [ADDITIONAL_PHONE], 
            mbr.MemberCellPhone AS [CELL_PHONE], 
            '' AS [LANGUAGE], 
            '' AS [Ethnicity], 
            '' AS [Email], 
            '' AS [Race], 
            mbr.HICN AS [MEDICARE_ID], 
            '00/00/0000' AS [MEMBER_ORG_EFF_DATE], 
            '00/00/0000' AS [MEMBER_CONT_EFF_DATE], 
            '00/00/0000' AS [MEMBER_CUR_EFF_DATE], 
            '00/00/0000' AS [MEMBER_CUR_TERM_DATE], 
            '' AS [RESP_FIRST_NAME], 
            '' AS [RESP_LAST_NAME], 
            '' AS [RESP_RELATIONSHIP], 
            '' AS [RESP_ADDRESS], 
            '' AS [RESP_ADDRESS2], 
            '' AS [RESP_CITY], 
            '' AS [RESP_STATE], 
            '00000' AS [RESP_ZIP], 
            '000-000-0000' AS [RESP_PHONE], 
            '' AS [PRIMARY_RISK_FACTOR], 
            '' AS [COUNT_OPEN_CARE_OPPS], 
            '' AS [INP_ADMITS_LAST_12_MOS], 
            '' AS [LAST_INP_DISCHARGE], 
            '' AS [POST_DISCHARGE_FUP_VISIT], 
            '' AS [INP_FUP_WITHIN_7_DAYS], 
            '' AS [ER_VISITS_LAST_12_MOS], 
            '' AS [LAST_ER_VISIT], 
            '' AS [POST_ER_FUP_VISIT], 
            '' AS [ER_FUP_WITHIN_7_DAYS], 
            '' AS [LAST_PCP_VISIT], 
            '' AS [LAST_PCP_PRACTICE_SEEN], 
            '' AS [LAST_BH_VISIT], 
            '' AS [LAST_BH_PRACTICE_SEEN], 
            '' AS [TOTAL_COSTS_LAST_12_MOS], 
            '' AS [INP_COSTS_LAST_12_MOS], 
            '' AS [ER_COSTS_LAST_12_MOS], 
            '' AS [OUTP_COSTS_LAST_12_MOS], 
            '' AS [PHARMACY_COSTS_LAST_12_MOS], 
            '' AS [PRIMARY_CARE_COSTS_LAST_12_MOS], 
            '' AS [BEHAVIORAL_COSTS_LAST_12_MOS], 
            '' AS [OTHER_OFFICE_COSTS_LAST_12_MOS], 
            '' AS [NEXT_PREVENTATIVE_VISIT_DUE]
		  , CONVERT(VARCHAR(15), Mbr.Ace_ID)  AS ACE_ID
		  , '' as Carrier_member_id 
    FROM [adw].FctMembership mbr
         INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
	    INNER JOIN (SELECT MAX(mbr.RwEffectiveDate) mbrRwEff, Max(mbr.RwExpirationDate) MbrRwExp from Adw.FctMembership mbr) LatestRecords
		  ON mbr.RwEffectiveDate = LatestRecords.mbrRwEff
			 and mbr.RwExpirationDate = LatestRecords.MbrRwExp
    --      WHERE mbr.Active = 1	   don't include this, this export should contain all rows.
    --where mbr.ProviderPOD <> '' mssp filter
    where mbr.SubgrpName <> 'COMM_Market is unknown' -- bcbs filter (these members do not have a valid plan)

