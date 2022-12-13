use apps_and_crunchbase;
-- 1. Retrieve the name of the app that has the highest number of ratings (i.e., rating_count) and the number of ratings it received.  
SELECT 
    a.name as App_Name, b.rating_count as Number_of_Ratings
FROM
    apps a,
    app_reviews b
WHERE
    a.id = b.id
        AND b.rating_count IN (SELECT 
            MAX(rating_count)
        FROM
            app_reviews b1);

-- 2. Retrieve the name and primary category for the apps that are game-center enabled and whose primary category is not "Games" (use apps table). 
SELECT 
    distinct name as App_Name, category_primary as Primary_Category, game_center as Game_Center
FROM
    apps
WHERE
    category_primary NOT LIKE 'Games%'
        AND game_center >= 1;
        
-- 3. In which primary category, the apps have the highest mean average_rating? 
SELECT 
    AVG(a.average_rating) Average, b.category_primary as Primary_Category
FROM
    app_reviews a,
    apps b
WHERE
    b.id = a.id
GROUP BY b.category_primary
ORDER BY AVG(a.average_rating) DESC
LIMIT 1;

-- 4. List the total number of ratings (rating_count) received for each primary category? Please list them in descending order of the total number of ratings. 
SELECT 
    category_primary AS Primary_Category,
    SUM(rating_count) AS Sum_Rating
FROM
    apps a,
    app_reviews b
WHERE
    a.id = b.id
GROUP BY Primary_Category
ORDER BY SUM(rating_count) DESC;

-- 5. List the primary category, number of ratings and average ratings for the app “Google Earth”. 
SELECT 
    name AS App_Name,
    category_primary AS Primary_Category,
    AVG(rating_count) AS Average_Number,
    (Average_Rating)
FROM
    apps a,
    app_reviews b
WHERE
    b.id = a.id AND name = 'Google Earth';

-- 6. (3 pts) Show the top list and list the total number of apps in each top list from the table top300 table. Anything you can say about the findings? 
SELECT 
    list as Top_List, COUNT(*) AS Apps_Number 
FROM
    top300
GROUP BY list; 
      
-- 7. (3 pts) In the "Top Free" list, which two primary categories appear most often?
SELECT 
    apps.category_primary AS Primary_Category,
    COUNT(*) AS Count_Number
FROM
    top300
        JOIN
    apps ON top300.id = apps.id
WHERE
    list = 'Top Free'
GROUP BY apps.category_primary
ORDER BY Count_Number DESC
LIMIT 2;

-- 8. (4 pts) What is the shortest time in number of days between an app’s release date and the date an app makes to the top list? What do you think about this information? 
SELECT 
    DATEDIFF(DATE(insert_time), release_date) AS Number_Days
FROM
    apps a,
    top300 b
WHERE
    a.id = b.id
ORDER BY Number_Days ASC
LIMIT 1; 

-- 9. (3 pts) On Aug 31, do we miss any data for any of the top lists? Please provide evidence to support your answer. 
SELECT DISTINCT
    list as List, insert_time as Date_Time
FROM
    top300
WHERE
    list NOT IN (SELECT DISTINCT
            list
        FROM
            top300
        WHERE
            DATE(insert_time) = '2013-08-31')
LIMIT 1;

-- 10. (3 pts) Is the apps table complete? That is, do we have data on all apps that appear in the top 300 list?  Please provide evidence supporting your answer.    
SELECT 
    COUNT(*) as CT
FROM
    top300
WHERE
    id NOT IN (SELECT 
            t.id
        FROM
            apps a
                JOIN
            top300 t ON a.id = t.id);

-- 11. You have learned that data redundancy is generally bad in a database setting, and you notice that there is redundant information on developer information that exists in both the apps table and the app_categories table, and you decide to check if the information matches. If the information does not match, it indicates inconsistency and potential problem down the road. Please write a query to check if there is any inconsistency. If your answer points out inconsistency, please report the error rate in terms of the percentage of data not matched on this particular piece of information (developer).  
SELECT 
    ((SELECT 
            COUNT(*)
        FROM
            app_categories a,
            apps b
        WHERE
            a.id = b.id
                AND b.developer != a.developer) / (SELECT 
            COUNT(*)
        FROM
            app_categories a,
            apps b
        WHERE
            a.id = b.id) * 100) AS Percentage_Error;


 

 





























