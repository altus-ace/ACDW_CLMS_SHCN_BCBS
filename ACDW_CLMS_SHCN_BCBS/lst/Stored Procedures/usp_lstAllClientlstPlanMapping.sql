
CREATE PROCEDURE [lst].[usp_lstAllClientlstPlanMapping]

AS

		--To be developed in the lst Model

	TRUNCATE TABLE ACECAREDW.[lst].[lstPlanMapping]


	SET IDENTITY_INSERT ACECAREDW.[lst].[lstPlanMapping] ON
	INSERT INTO	ACECAREDW.[lst].[lstPlanMapping](
							[lstPlanMappingKey]
							, [EffectiveDate]
							, [ExpirationDate]
							, [ClientKey]
							, [TargetSystem]
							, [SourceValue]
							, [TargetValue]
							, [CreatedDate]
							, [CreatedBy]
							, [LastUpdatedDate]
							, [LastUpdatedBy]
							, [Active]
							, [SrcFileName])

	SELECT					 [lstPlanMappingKey]
							,[EffectiveDate]
							,[ExpirationDate]
							,[ClientKey]
							,[TargetSystem]
							,[SourceValue]
							,[TargetValue]
							,[CreatedDate]
							,[CreatedBy]
							,[LastUpdatedDate]
							,[LastUpdatedBy]
							,[Active]
							,[SrcFileName]
	FROM					[lst].[lstPlanMapping]

	SET IDENTITY_INSERT ACECAREDW.[lst].[lstPlanMapping] OFF
