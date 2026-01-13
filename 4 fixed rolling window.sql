"sales_month"	"naics_code"	"kind_of_business"			"reason_for_null"	"sales"
"1992-01-01"	"44811"			"Men's clothing stores"							701
"1992-01-01"	"44812"			"Women's clothing stores"						1873
"1992-02-01"	"44811"			"Men's clothing stores"							658
"1992-02-01"	"44812"			"Women's clothing stores"						1991
"1992-03-01"	"44811"			"Men's clothing stores"							731


SELECT
	SALES_MONTH,
	sales,
	count(SALES) OVER (
		ORDER BY
			SALES_MONTH ROWS BETWEEN 11 PRECEDING
			AND CURRENT ROW
	) as count_months_in_ltm,
	round(AVG(SALES) OVER (
		ORDER BY
			SALES_MONTH ROWS BETWEEN 11 PRECEDING
			AND CURRENT ROW
	), 2) as avg_of_ltm,
	MAX(SALES) OVER (
		ORDER BY
			SALES_MONTH ROWS BETWEEN 11 PRECEDING
			AND CURRENT ROW
	) as max_of_ltm
FROM
	RETAIL_SALES
WHERE

	KIND_OF_BUSINESS = 'Women''s clothing stores'

-- OR

SELECT
	A.sales_month,
	A.sales,
	count(B.sales) as count_months_in_ltm,
	round(avg(B.sales), 2) as avg_ltm,
	max(B.sales) as max_ltm
FROM
	RETAIL_SALES A
	JOIN RETAIL_SALES B ON B.SALES_MONTH between A.SALES_MONTH - INTERVAL '11 months' and A.SALES_MONTH
	AND B.KIND_OF_BUSINESS = 'Women''s clothing stores'
WHERE
	A.KIND_OF_BUSINESS = 'Women''s clothing stores' group by 1, 2 order by 1

"sales_month"	"sales"	"count_months_in_ltm"	"avg_of_ltm"	"max_of_ltm"
"1992-01-01"	1873	1						1873.00			1873
"1992-02-01"	1991	2						1932.00			1991
"1992-03-01"	2403	3						2089.00			2403
"1992-04-01"	2665	4						2233.00			2665
"1992-05-01"	2752	5						2336.80			2752
