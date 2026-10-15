SELECT 
    -- Primary Key الفريد لكل سطر
    CAST([Row_ID] AS INT) AS Row_ID,
    
    -- رقم الفاتورة (يمكن أن يتكرر لعدة منتجات)
    TRIM([Order_ID]) AS Order_ID,
    
    -- تحويل النص إلى تاريخ صحيح DD/MM/YYYY باستخدام Code 105
    CONVERT(DATE, [Order_Date], 105) AS Order_Date,
    CONVERT(DATE, [Ship_Date], 105) AS Ship_Date,
    
    -- حساب الفرق بين الأيام (Delivery Days)
    DATEDIFF(day, CONVERT(DATE, [Order_Date], 105), CONVERT(DATE, [Ship_Date], 105)) AS Delivery_Days,
    
    -- تنظيف النصوص من المسافات الزائدة في البداية والنهاية
    TRIM([Ship_Mode]) AS Ship_Mode,
    TRIM([Customer_ID]) AS Customer_ID,
    TRIM([Customer_Name]) AS Customer_Name,
    TRIM([Segment]) AS Segment,
    TRIM([Country]) AS Country,
    TRIM([City]) AS City,
    TRIM([State]) AS State,
    
    -- معالجة الـ Postal Code لضمان قراءته بشكل صحيح
    ISNULL(CAST([Postal_Code] AS VARCHAR(10)), 'N/A') AS Postal_Code,
    
    TRIM([Region]) AS Region,
    TRIM([Product_ID]) AS Product_ID,
    TRIM([Category]) AS Category,
    TRIM([Sub_Category]) AS Sub_Category,
    TRIM([Product_Name]) AS Product_Name,
    
    -- تحويل رقم المبيعات لدقة مالية دقيقة DECIMAL(18,2)
    CAST([Sales] AS DECIMAL(18,2)) AS Sales

INTO fact_sales_clean
FROM stg_Superstore
-- استبعاد أي سطور فارغة بالكامل أو تحتوي على مبيعات غير منطقية
WHERE [Order_ID] IS NOT NULL AND [Sales] > 0;
GO

SELECT 
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Total_Unique_Orders,
    SUM(Sales) AS Total_Sales,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Avg_Order_Value,
    ROUND(AVG(CAST(Delivery_Days AS FLOAT)), 2) AS Avg_Delivery_Days
FROM fact_sales_clean;
select*from dbo.fact_sales_clean;