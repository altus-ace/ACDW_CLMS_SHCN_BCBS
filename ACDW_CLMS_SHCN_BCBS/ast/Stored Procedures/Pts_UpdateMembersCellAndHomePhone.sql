
CREATE PROCEDURE [ast].[Pts_UpdateMembersCellAndHomePhone]

AS

BEGIN
		
		IF OBJECT_ID('tempdb..#Phones') IS NOT NULL DROP TABLE #Phones
		CREATE TABLE #Phones(ID INT IDENTITY (1,1),[SUBSCRIBER_ID] VARCHAR(50), [FirstName]VARCHAR(50)
							, [LastName] VARCHAR(50), [HomePhone]VARCHAR(50), [MobileNo]VARCHAR(50))

		--Step 1 -- Insert Records into a temp table
		INSERT INTO #Phones([SUBSCRIBER_ID], [FirstName], [LastName], [HomePhone], [MobileNo])
		
		SELECT PatientPolicyidNumber
		      ,[patientfirstname]
		      ,[patientlastname]
			  ,[patienthomephone]
			  ,[PatientMobilePhone]
		FROM [ACDW_CLMS_SHCN_BCBS].[adi].[BCBSPatientPhoneNumber]
		
		--To compare data before transformation
		/*
		SELECT		*
					,LEN(HomePhone) PhonesTransformed
					,LEN(MobileNo) MobileTransformed
					,[lst].[fnStripNonNumericChar](HomePhone) PhoneNoTransformed
					,[lst].[fnStripNonNumericChar](MobileNo) MobileNOTransformed
		FROM		#Phones*/

		-- Step 2 -- Tranforming phone nos
		UPDATE		#Phones
		SET			[HomePhone] = [lst].[fnStripNonNumericChar]([HomePhone])
					,[MobileNo] = [lst].[fnStripNonNumericChar]([MobileNo])

		/*
			--- ---2985
		SELECT			DISTINCT a.SubscriberID_SHCN_BCBS,b.SUBSCRIBER_ID
		FROM			ast.MbrStg2_MbrData a
		JOIN			#Phones b
		ON				a.SubscriberID_SHCN_BCBS = b.SUBSCRIBER_ID

		---1904 Members not in our Membership file, ie we have a total of 1904 Members not for ACE
		SELECT		DISTINCT SUBSCRIBER_ID,SubscriberID_SHCN_BCBS
		FROM		#Phones a
		LEFT JOIN	ast.MbrStg2_MbrData b
		ON			a.SUBSCRIBER_ID = b.SubscriberID_SHCN_BCBS
		WHERE		b.SubscriberID_SHCN_BCBS IS NULL
		*/

		---Step 3 -- Update Staging
		-- BEGIN TRAN  -- ROLLBACK COMMIT
		UPDATE		ast.MbrStg2_PhoneAddEmail
		SET			CellPhone = d.MobileNo
					,HomePhone = d.HomePhone
		-- SELECT		DISTINCT ClientMemberKey, ClientSubscriberId,SubscriberID_SHCN_BCBS,SUBSCRIBER_ID,d.MobileNo,d.HomePhone,c.CellPhone,c.HomePhone
		FROM		ast.MbrStg2_PhoneAddEmail c
		JOIN		(SELECT		DISTINCT a.ClientSubscriberId,b.SUBSCRIBER_ID,a.SubscriberID_SHCN_BCBS
								,b.HomePhone,b.MobileNo
					 FROM		ast.MbrStg2_MbrData a
					 JOIN		#Phones b
					 ON			a.SubscriberID_SHCN_BCBS = b.SUBSCRIBER_ID
					 )d
		ON			c.ClientMemberKey = d.ClientSubscriberId

END
		--Validation
		SELECT		DISTINCT ClientMemberKey,HomePhone,CellPhone,PhoneNumber 
		FROM		ast.MbrStg2_PhoneAddEmail 
		WHERE		(CellPhone <> '' OR HomePhone <> '')
		/*
		--- One time update on Phone DIM
		 -- BEGIN TRAN --- COMMIT
		UPDATE		adw.MbrPhone
		SET			CellPhone = b.CellPhone
					,HomePhone = b.HomePhone
		--- SELECT		DISTINCT a.ClientMemberKey,b.ClientMemberKey,a.CellPhone,b.CellPhone,a.HomePhone,b.HomePhone
		FROM		adw.MbrPhone a
		JOIN		ast.MbrStg2_PhoneAddEmail b
		ON			a.ClientMemberKey = b.ClientMemberKey

		--- One time update on FctMembership
		 -- BEGIN TRAN --- COMMIT
		UPDATE		adw.FctMembership
		SET			MemberCellPhone = b.CellPhone
					,MemberHomePhone = b.HomePhone
		--- SELECT		DISTINCT a.ClientMemberKey,b.ClientMemberKey,a.MemberCellPhone,b.CellPhone,a.MemberHomePhone,b.HomePhone
		FROM		adw.FctMembership a
		JOIN		ast.MbrStg2_PhoneAddEmail b
		ON			a.ClientMemberKey = b.ClientMemberKey

		*/



						
											
				