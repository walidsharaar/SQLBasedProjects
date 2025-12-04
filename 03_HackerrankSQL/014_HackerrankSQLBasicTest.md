---- Student Analysis
```
SELECT  
      a.roll_number,a.name
FROM    
       student_information as a
INNER JOIN  
        examination_marks as b
ON      
         a.roll_number = b.roll_number
GROUP BY  
          b.roll_number
HAVING  
        SUM(b.subject_one + b.subject_two + b.subject_three) < 100;
```

---Merit Rewards

```
SELECT  
     ei.employee_ID, ei.name
FROM    
     employee_information ei
JOIN    
     last_quarter_bonus b ON b.employee_ID = ei.employee_ID
WHERE   
      ei.division LIKE 'HR'
AND     
      b.bonus >= 5000;
```

----Profitable Stocks

```
SELECT  
      a.stock_code
FROM    
      price_today as a
INNER jOIN  
      price_tomorrow as b
ON      
      a.stock_code = b.stock_code
WHERE   
      b.price > a.price
ORDER BY  
      stock_code asc;
```


---- Student Advisor


```
SELECT 
      roll_number,name
FROM   
      student_infromation as a
INNER JOIN  
       faculty_information as b
ON      
       a.advisor=b.employee_id
WHERE  
       (b.gender='M' and b.salary>15000) or (b.gender='F' and b.salary=>20000);
```

---country codes

```
SELECT 
      a.customer_id,a.name,concat("+",b.country_code,a.phone_number)
FROM  
      customers as a
LEFT  
      join country_codes as b 
ON    
      a.country=b.country
ORDER BY  
      a.customer_id;
```
