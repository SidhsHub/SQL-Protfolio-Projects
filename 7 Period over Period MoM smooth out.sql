SELECT
	date_part('month', sales_month) as month_no,
	to_char(sales_month, 'month') as month,
	sum(case when date_part('year', sales_month) = 1992 then sales end) as year_1992,
	sum(case when date_part('year', sales_month) = 1993 then sales end) as year_1993,
	sum(case when date_part('year', sales_month) = 1994 then sales end) as year_1994
FROM
	RETAIL_SALES
WHERE
	KIND_OF_BUSINESS = 'Book stores'
	group by 1,2 order by 1

"month_no"	"month"	"    year_1992"	"year_1993"	"year_1994"
1	          "january  "	  790	        998	        1053
2	          "february "	539	568	635
3	          "march    "	535	602	634
4	"april    "	523	583	610
5	"may      "	552	612	684
