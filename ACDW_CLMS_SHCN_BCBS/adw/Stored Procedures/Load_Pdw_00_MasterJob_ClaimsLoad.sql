

CREATE PROCEDURE [adw].[Load_Pdw_00_MasterJob_ClaimsLoad]    
    ( @LatestDataDate DATE = '12/31/2099')
AS 
    
    -- TO DO: Add calls to the log sp. all the code and tables exist. add before run again.
    
    -- 
    -- 1.truncate normalized model tables
    -- 2. updated stats adi.
    -- 3.do setup
    -- 4.execute each table move
    -- 5.validate
    --declare @LatestDataDate date = '01/01/2021'
    
        
    -- 1. TRUNCATE Normalized Tables: DO NOT MOVE TO PROC, 
	   -- unless you take the backup with it. 
	   -- Best practice is do not delete with out a backup.     This should be hard to run.
    BEGIN
	   TRUNCATE TABLE adw.Claims_Details;
	   TRUNCATE TABLE adw.Claims_Conditions;
	   TRUNCATE TABLE adw.Claims_Diags;
	   TRUNCATE TABLE adw.Claims_Procs;
	   TRUNCATE TABLE adw.Claims_Member;
	   TRUNCATE TABLE adw.Claims_Headers; 
    END;
	
    -- 2. update stats adi
    BEGIN
	   EXEC sP_updateStats;
    END;

    --3. Load the staging tables- Select which adi rows will be inserted
	 --Process set of SP when filtering by filedate as cummulative date is needed to be processed
    EXEC adw.Load_Pdw_00_LoadManagementTables @LatestDataDate;

    -- 4. Execute TABLE moves.
    BEGIN    
	   -- Inst
	   EXEC adw.Load_Pdw_11_ClmsHeadersPartA;
	   EXEC adw.Load_Pdw_12_ClmsDetailsPartA;
	   EXEC adw.Load_Pdw_13_ClmsProcsCclf3;
	   EXEC adw.Load_Pdw_14_ClmsDiagsCclf4;    
	   EXEC adw.Load_Pdw_15_ClmsMemsCCLF8 @LatestDataDate;--Check this for file date
	   -- prof
	   EXEC adw.Load_Pdw_21_ClmsHeadersPartBPhys;
	   EXEC adw.Load_Pdw_22_ClmsDetailsPartBPhys;
	   EXEC adw.Load_Pdw_24_ClmsDiagsPartBPhys;
	   -- rx
	   EXEC adw.Load_Pdw_31_ClmsHeadersPartdPharma;
	   EXEC adw.Load_Pdw_32_ClmsDetailsPartDPharma;
    END;

    -- 6. Data normalization
    EXEC adw.Transfrom_Pdw_00_Master;

    -- 7. UPdate statistics following dim load
    EXEC sP_updateStats;

