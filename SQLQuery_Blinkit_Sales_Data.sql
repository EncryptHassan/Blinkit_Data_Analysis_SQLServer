USE blinkit_db

SELECT * FROM Blinkit_Grocery_Data

SELECT COUNT(*) FROM Blinkit_Grocery_Data

UPDATE Blinkit_Grocery_Data
SET Item_Fat_Content = 
	CASE 
		WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
		WHEN Item_Fat_Content IN ('reg') THEN 'Regular'
		ELSE Item_Fat_Content
	END

SELECT DISTINCT(Item_Fat_Content) FROM Blinkit_Grocery_Data

--Total Sales
SELECT SUM(Total_Sales) AS Total_Sales 
FROM Blinkit_Grocery_Data 
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10, 2)), ' Millions') AS Total_Sales_Millions 
FROM Blinkit_Grocery_Data

--Average Sales
SELECT CONCAT(CAST(AVG(Total_Sales) AS DECIMAL(10, 1)), ' Millions') AS Average_Sales_Millions 
FROM Blinkit_Grocery_Data

--number of Items
SELECT COUNT(*) AS No_of_Items 
FROM Blinkit_Grocery_Data

--Average Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM Blinkit_Grocery_Data


SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10, 2))
FROM Blinkit_Grocery_Data
WHERE Item_Fat_Content = 'Low Fat'

SELECT COUNT(*) AS No_of_Items
FROM Blinkit_Grocery_Data
WHERE Outlet_Establishment_Year = 2022

SELECT CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating FROM Blinkit_Grocery_Data

--Toatal Sales by fat content
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL (10, 2)) AS Total_Sales
FROM Blinkit_Grocery_Data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC

SELECT Item_Fat_Content, 
	CAST(SUM(Total_Sales) AS DECIMAL (10, 2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM Blinkit_Grocery_Data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC

SELECT Item_Fat_Content, 
	CAST(SUM(Total_Sales) AS DECIMAL (10, 2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM Blinkit_Grocery_Data
WHERE Outlet_Establishment_Year = 2022
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC

--Total Sales by item type
SELECT TOP 5 Item_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10, 2)) AS Total_Sales_Item_Type, 
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales_Item_Type,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM Blinkit_Grocery_Data
GROUP BY Item_Type
ORDER BY Item_Type DESC

SELECT Item_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10, 2)) AS Total_Sales_Item_Type, 
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales_Item_Type,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM Blinkit_Grocery_Data
GROUP BY Item_Type
ORDER BY Item_Type DESC

SELECT TOP 5 Item_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10, 2)) AS Total_Sales_Item_Type, 
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales_Item_Type,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
FROM Blinkit_Grocery_Data
GROUP BY Item_Type
ORDER BY Item_Type

SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)), Outlet_Location_Type FROM Blinkit_Grocery_Data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Outlet_Location_Type



--Fat content by outlet for total sales
SELECT Outlet_Location_Type,
	ISNULL([Low Fat], 0) AS Low_Fat,
	ISNULL([Regular], 0) AS Regular
FROM
(
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales, Outlet_Location_Type 
	FROM Blinkit_Grocery_Data
	GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

--Total sales by outlet establishment
 SELECT Outlet_Establishment_Year,
	CAST(SUM(Total_Sales) AS DECIMAL(10, 2)) AS Total_Sales,
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
 FROM Blinkit_Grocery_Data
 GROUP BY Outlet_Establishment_Year
 ORDER BY Outlet_Establishment_Year ASC

-- Percentage of sales by outlet size
SELECT Outlet_Size,
	CAST(SUM(Total_Sales) AS DECIMAL(10, 2)) AS Total_Sales,
	CAST((SUM(Total_Sales)*100.0/SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage
FROM Blinkit_Grocery_Data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--Sales by outlet location
SELECT Outlet_Location_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10, 2)) AS Total_Sales,
	CAST((SUM(Total_Sales)*100.0/SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage,
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
 FROM Blinkit_Grocery_Data
 GROUP BY Outlet_Location_Type
 ORDER BY Total_Sales DESC

 --All metrics by outlet type
 SELECT Outlet_Type,
	CONCAT(CAST(SUM(Total_Sales) / 1000 AS DECIMAL(10, 2)), ' K') AS Total_Sales,
	CONCAT(CAST((SUM(Total_Sales)*100.0/SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10, 2)), '%')AS Sales_Percentage,
	CAST(AVG(Total_Sales) AS DECIMAL(10, 2)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
 FROM Blinkit_Grocery_Data
 GROUP BY Outlet_Type
 ORDER BY Total_Sales DESC