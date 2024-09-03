--select the database
use super_market_sale;

-- This database contains only one table named supermarket_sales which have the following columns
-- invoiceID,Branch,City,customer_type[Normal,Member],Gender[male,female],product_line,unit_price,quantity,tax, total,date,payment,
-- cogs(cost per good sold), gross margin percentage,gross income,ratings 
--Inspect the data by selecting all the records
select * from supermarket_sales;

-- since invoice_id is the parimary key of this dataset we we try to make sure that the invoice
-- is not duplicated.If then we delete those records
select invoice_id,count(invoice_id) as total_invoices from supermarket_sales group by invoice_id
order by total_invoices desc; -- not duplicate is found

-- by inspecting the data we consider that there is not need of time column so we drop that column
-- Beacuse we already have date column
alter table supermarket_sales drop column time; 

-- by inspecting the data we find that the column name tax_5 incorrest this is actually tex so we change 
-- the name of the column from tax_5 to tax
EXEC sp_rename 'supermarket_sales.tax_5',  'Tax', 'COLUMN';

--inspect the data for null values
select * from supermarket_sales where invoice_id is null;

--show the cross income of gender level
select Gender,round(sum(gross_income),0) as total_gender_income
from supermarket_sales group by Gender;

--show the cross income of each category
select product_line,round(sum(gross_income),0) as total_category_income
from supermarket_sales group by product_line;

---show the sales on the branch level
select branch,round(sum(gross_income),0) as total_branch_income
from supermarket_sales group by branch;

--show the sales on the city level
select city,round(sum(gross_income),0) as total_city_income
from supermarket_sales group by city;


--show the sales on daily basis level
select date,round(sum(gross_income),0) as daily_total
from supermarket_sales group by date order by date;

--show the sales on the monthly level
select month(date) as [Month],round(sum(total),0) as total_monthly_sale
from supermarket_sales group by MONTH(date) order by Month(date); 

-- show the invoice which have income more than average income 
select Invoice_ID, product_line,gross_income 
from supermarket_sales where gross_income > (select avg(gross_income) from supermarket_sales)

--- show product quantity of each category sold on the daily level
select date,product_line,round(sum(Quantity),0) as total_quantities_sold
from supermarket_sales group by date,product_line order by date;

--- show the most prefer method used by people 
select payment,count(payment) as total_count from supermarket_sales group by payment
order by total_count desc;

---net profit of each category
select product_line,(total - tax) as net_profilt from supermarket_sales;


--now we split our supermarket_sales into sub_tables the city into another table
select distinct city from supermarket_sales;

DROP TABLE IF EXISTS city;
create table city(
city varchar(100),
primary key(city)
)

INSERT INTO city 
select distinct city from supermarket_sales

