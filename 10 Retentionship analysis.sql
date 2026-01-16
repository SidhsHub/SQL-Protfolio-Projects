-- Calculating retention after entity has reached certain threshold

SELECT
	*,
	FIRST_value(COHORT_RETAINED) over (partition by TERM_TYPE order by PERIOD) as cohort_size,
	COHORT_RETAINED * 1.00/ FIRST_value(COHORT_RETAINED) over (partition by TERM_TYPE order by PERIOD) as pct_retained
FROM
	(
		SELECT
			--A.*,
			--B.TERM_START,
			--B.TERM_END,
			--C.DATE,
			A.TERM_TYPE,
			DATE_PART('year', AGE (C.DATE, A.FIRST_TERM)) AS PERIOD,
			COUNT(DISTINCT A.ID_BIOGUIDE) AS COHORT_RETAINED
		FROM
			(
				SELECT DISTINCT
					ID_BIOGUIDE,
					TERM_TYPE,
					DATE ('2000-01-01') AS FIRST_TERM,
					MIN(TERM_START) AS MIN_START
				FROM
					LEGISLATORS_TERMS
				WHERE
					TERM_START <= '2000-12-31'
					AND TERM_END >= '2000-01-01'
					--AND ID_BIOGUIDE = 'C000714'
				GROUP BY
					1,
					2,
					3
			) A
			JOIN LEGISLATORS_TERMS B ON A.ID_BIOGUIDE = B.ID_BIOGUIDE
			AND B.TERM_START >= A.MIN_START
			LEFT JOIN DATE_DIM C ON C.DATE BETWEEN B.TERM_START AND B.TERM_END
			AND C.MONTH_NAME = 'December'
			AND C.DAY_OF_MONTH = 31
			AND C."year" >= 2000
		GROUP BY
			1,
			2

	) AA

/*
"term_type"	"period"	"cohort_retained"	"cohort_size"	"pct_retained"
"rep"	0	439	439	1.00000000000000000000
"rep"	1	392	439	0.89293849658314350797
"rep"	2	389	439	0.88610478359908883827
"rep"	3	340	439	0.77448747152619589977
"rep"	4	338	439	0.76993166287015945330
*/
