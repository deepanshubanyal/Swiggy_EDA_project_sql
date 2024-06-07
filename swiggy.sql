SELECT * FROM swiggy.swiggy;
USE SWIGGY;
SHOW TABLES;
select distinct price from swiggy;
/* 1. HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5? */
SELECT count(distinct RESTAURANT_NO) AS no_of_restaurants FROM swiggy WHERE RATING>4.5 ;

/* 2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS? */
SELECT CITY, COUNT( DISTINCT RESTAURANT_NO) AS higest_no_of_restaurants FROM SWIGGY group by CITY ORDER BY COUNT( DISTINCT RESTAURANT_NO) DESC LIMIT 1 ;

/* 3. HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME? */
SELECT COUNT(DISTINCT RESTAURANT_NAME) AS no_of_restaurants FROM SWIGGY WHERE RESTAURANT_NAME LIKE "%PIZZA%";

/* 4. WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET? */
select cuisine, count(Cuisine) from swiggy group by cuisine order by count(Cuisine) desc limit 1;

/* 5. WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY? */
select city, avg(rating) from swiggy group by city;

/* 6. WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU
CATEGORY FOR EACH RESTAURANT? */
select distinct restaurant_name,
menu_category,max(price) as highestprice
from swiggy where menu_category='Recommended'
group by restaurant_name,menu_category;
SET SQL_SAFE_UPDATES = 0;
update  swiggy set price=substring(price,2,3) where price like"%₹%" ;
update swiggy set price=cast(price as signed);

/* 7. FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN
INDIAN CUISINE. */
select distinct restaurant_name ,cost_per_person from swiggy where cuisine<>"%indian%" order by cost_per_person desc limit 5;

/* 8.  FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE
TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER. */ 
select distinct restaurant_name, cost_per_person from swiggy where cost_per_person>(select avg(cost_per_person ) from  swiggy)  ;

/* 9 *RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE
LOCATED IN DIFFERENT CITIES.*/
select distinct s1.restaurant_name, s1.city from swiggy s1 join swiggy s2 on s1.restaurant_name=s2.restaurant_name and s1.city<>s2.city order by restaurant_name;

/* 10. WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE'
CATEGORY? */
select restaurant_name, menu_category,count(*) as NO_of_items from swiggy where menu_category like "Main Course" group by restaurant_name, menu_category order by count(*) desc limit 1;

/* 11. LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME. */
select distinct restaurant_name from swiggy where restaurant_name not in (select distinct restaurant_name from swiggy where veg_or_nonveg="Non-veg") order by restaurant_name;


/* 12. WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?*/
select restaurant_name, avg(price) from swiggy group by restaurant_name order by avg(price) limit 1;



/* 13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES? */
select restaurant_name , count(distinct menu_category) NO_OF_categories from swiggy group by restaurant_name order by count(distinct menu_category) desc limit 5 ;

/* 14  WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD? */
with cte as(
select restaurant_name, sum(case when veg_or_nonveg like "veg" then 1 else 0 end) as no_of_veg_items , sum(case when veg_or_nonveg="non-veg" then 1 else 0 end) as no_of_non_veg_items,count(*) as total_NO_of_items from swiggy group by restaurant_name
)
select * , no_of_non_veg_items*100/total_no_of_items as non_veg_percentage from cte order by non_veg_percentage desc limit 1;

