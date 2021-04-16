

CREATE FUNCTION [dbo].[x_udf_GenerateRowsFromDate]
	(@StartDate	DATE, @EndDate DATE, @Part VARCHAR(10), @Incr INT)
RETURNS TABLE
RETURN
(
    WITH		cte0(M)   As (Select 1+Case @Part When 'YY' then DateDiff(YY,@StartDate,@EndDate)/@Incr When 'QQ' then DateDiff(QQ,@StartDate,@EndDate)/@Incr When 'MM' then DateDiff(MM,@StartDate,@EndDate)/@Incr When 'WK' then DateDiff(WK,@StartDate,@EndDate)/@Incr When 'DD' then DateDiff(DD,@StartDate,@EndDate)/@Incr When 'HH' then DateDiff(HH,@StartDate,@EndDate)/@Incr When 'MI' then DateDiff(MI,@StartDate,@EndDate)/@Incr When 'SS' then DateDiff(SS,@StartDate,@EndDate)/@Incr End),
				cte1(N)   As (Select 1 From (Values(1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) N(N)),
				cte2(N)   As (Select Top (Select M from cte0) Row_Number() over (Order By (Select NULL)) From cte1 a, cte1 b, cte1 c, cte1 d, cte1 e, cte1 f, cte1 g, cte1 h ),
				cte3(N,D) As (Select 0,@StartDate Union All Select N,Case @Part When 'YY' then DateAdd(YY, N*@Incr, @StartDate) When 'QQ' then DateAdd(QQ, N*@Incr, @StartDate) When 'MM' then DateAdd(MM, N*@Incr, @StartDate) When 'WK' then DateAdd(WK, N*@Incr, @StartDate) When 'DD' then DateAdd(DD, N*@Incr, @StartDate) When 'HH' then DateAdd(HH, N*@Incr, @StartDate) When 'MI' then DateAdd(MI, N*@Incr, @StartDate) When 'SS' then DateAdd(SS, N*@Incr, @StartDate) End From cte2 )
    SELECT	RetSeq = N+1
				,RetVal = D 
    FROM		cte3,cte0     WHERE	D<=@EndDate
)
/***
Usage:
Select * from [dbo].x_udf_GenerateRowsFromDate('2016-10-01','2020-10-01','YY',1) 
Select * from [dbo].x_udf_GenerateRowsFromDate('2016-01-01','2017-01-01','MM',1) 
***/
