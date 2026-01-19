SELECT
	FIRST_CENTURY,
	terms,
	count(distinct a.ID_BIOGUIDE) as cohort_size,
	count(distinct case when a.TOTAL_TERM >= b.terms then a.ID_BIOGUIDE end) as cohort_survived,
	round(count(distinct case when a.TOTAL_TERM >= b.terms then a.ID_BIOGUIDE end) *1.00/ count(distinct a.ID_BIOGUIDE),4) as pct_survived
FROM
	(
		SELECT
			ID_BIOGUIDE,
			DATE_PART('century', MIN(TERM_START)) AS FIRST_CENTURY,
			COUNT(TERM_START) AS TOTAL_TERM
		FROM
			LEGISLATORS_TERMS
		GROUP BY
			1
	) A
	JOIN (
		SELECT
			GENERATE_SERIes AS TERMS
		FROM
			generate_series(1, 20, 1)
	) b on 1=1 group by 1,2

	--order by 1

/*
"first_century"	"terms"	"cohort_size"	"cohort_survived"	"pct_survived"
18					1		368				368					1.0000
18					2		368				249					0.6766
18	3	368	153	0.4158
18	4	368	96	0.2609
18	5	368	63	0.1712
*/
