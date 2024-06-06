
## Analyze motorcycle part sales 
- Derive insights about motorcycle part sales over time across multiple warehouse sites
- Understand revenue streams for a company selling motorcycle parts.
- Build a query to determine net revenue across product lines.

```

select product_line,
    case WHEN EXTRACT('month' from date) = 6 THEN 'June'
        WHEN EXTRACT('month' from date) = 7 THEN 'July'
        WHEN EXTRACT('month' from date) = 8 THEN 'August'
    END as month,
    warehouse,
	SUM(total) - SUM(payment_fee) AS net_revenue
from sales
where client_type = 'Wholesale'
GROUP BY product_line, warehouse, month
ORDER BY product_line, month, net_revenue desc
```
