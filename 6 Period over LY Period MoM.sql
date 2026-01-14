 SELECT
	sales_month,
	sales,
	--date_part('month', sales_month),
	lag(sales_month) over (PARTITION by date_part('month', sales_month) order by sales_month) as last_year_month,
	lag(sales) over (PARTITION by date_part('month', sales_month) order by sales_month) as last_year_month_sales,
	sales - lag(sales) over (PARTITION by date_part('month', sales_month) order by sales_month) as abs_diff,
	round((sales / lag(sales) over (PARTITION by date_part('month', sales_month) order by sales_month) -1), 3) *100 as MoLYM
FROM
	RETAIL_SALES
WHERE
	KIND_OF_BUSINESS = 'Book stores'

"sales_month"	"sales"	"last_year_month"	"last_year_month_sales"	"abs_diff"	"molym"
"1992-01-01"	790				
"1993-01-01"	998	    "1992-01-01"	    790	                    208	        26.300
"1994-01-01"	1053	  "1993-01-01"	998	55	5.500
"1995-01-01"	1308	  "1994-01-01"	1053	255	24.200
"1996-01-01"	1373	  "1995-01-01"	1308	65	5.000
