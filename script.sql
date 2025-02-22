--1.
USE mydb;
SELECT 
    order_details.*,
    (SELECT orders.customer_id 
     FROM orders 
     WHERE orders.id = order_details.order_id) AS customer_id
FROM order_details;

--2.
SELECT *
FROM order_details
WHERE order_id IN (
    SELECT id 
    FROM orders 
    WHERE shipper_id = 3
);

--3.
SELECT 
    filtered_orders.order_id,
    AVG(filtered_orders.quantity) AS avg_quantity
FROM (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
) AS filtered_orders
GROUP BY filtered_orders.order_id;

--4.
WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT 
    temp.order_id,
    AVG(temp.quantity) AS avg_quantity
FROM temp
GROUP BY temp.order_id;

--5.
DROP FUNCTION IF EXISTS divide_values;
DELIMITER $$
CREATE FUNCTION divide_values(a FLOAT, b FLOAT) 
RETURNS FLOAT 
DETERMINISTIC
BEGIN
    IF b = 0 THEN
        RETURN NULL;
    ELSE
        RETURN a / b;
    END IF;
END $$
DELIMITER ;

SELECT order_id, quantity, divide_values(quantity, 6) AS divided_quantity
FROM order_details;
