"sales_month"	"naics_code"	"kind_of_business"			"reason_for_null"	"sales"
"1992-01-01"	"44811"			"Men's clothing stores"							701
"1992-01-01"	"44812"			"Women's clothing stores"						1873
"1992-02-01"	"44811"			"Men's clothing stores"							658
"1992-02-01"	"44812"			"Women's clothing stores"						1991
"1992-03-01"	"44811"			"Men's clothing stores"							731


SELECT
	*,
	FIRST_VALUE(YEARLY_SALES) OVER (
		PARTITION BY
			KIND_OF_BUSINESS
		ORDER BY
			SALES_YEAR
	) AS INDEX_VAL,
	(YEARLY_SALES / FIRST_VALUE(YEARLY_SALES) OVER (
		PARTITION BY
			KIND_OF_BUSINESS
		ORDER BY
			SALES_YEAR
	) - 1) * 100 AS PCT_chng_FROM_INDEX
FROM
	(
		SELECT
			DATE_PART('year', SALES_MONTH) AS SALES_YEAR,
			KIND_OF_BUSINESS,
			SUM(SALES) AS YEARLY_SALES
			--FIRST_VALUE(sum(sales)) OVER (PARTITION by KIND_OF_BUSINESS order by sales_month)
		FROM
			RETAIL_SALES
		WHERE
			KIND_OF_BUSINESS IN (
				'Women''s clothing stores',
				'Men''s clothing stores'
			)
		GROUP BY
			1,
			2

	)

--OR

SELECT
	date_part('year', aa.sales_month) as sales_year,
	bb.index_sales,
	sum(AA.sales) as yearly_sales,
	round(((sum(AA.sales) / bb.index_sales) - 1) *100, 2) as pct_chg_from_index
FROM
	RETAIL_SALES AA
	JOIN (
		SELECT
			B.INDEX_YEAR,
			SUM(A.SALES) as index_sales
		FROM
			RETAIL_SALES A
			JOIN (
				SELECT
					--MIN(SALES_MONTH) AS INDEX_MONTH
					DATE_PART('year', MIN(SALES_MONTH)) AS INDEX_YEAR
				FROM
					RETAIL_SALES
				WHERE
					KIND_OF_BUSINESS IN ('Women''s clothing stores')
			) B ON
			--DATE_PART('year', A.SALES_MONTH) = DATE_PART('year', B.INDEX_MONTH)
			DATE_PART('year', A.SALES_MONTH) = B.INDEX_YEAR
			AND A.KIND_OF_BUSINESS = 'Women''s clothing stores'
		GROUP BY
			1
	) bb ON 1 = 1
	AND AA.KIND_OF_BUSINESS = 'Women''s clothing stores' group by 1,2 order by 1

"sales_year"	"index_sales"	"yearly_sales"	"pct_chg_from_index"
1992	31815	31815	0.00
1993	31815	32350	1.68
1994	31815	30585	-3.87
1995	31815	28696	-9.80
1996	31815	28238	-11.24
