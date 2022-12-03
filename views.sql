CREATE VIEW analysis.orderitems AS
        SELECT *
        FROM production.orderitems; 
        
       
CREATE VIEW analysis.orders AS
        SELECT *
        FROM production.orders
        WHERE cast(DATE_TRUNC('DAY', order_ts) as date) >= '2022-01-01';
        
       
CREATE VIEW analysis.orderstatuses AS
        SELECT *
        FROM production.orderstatuses;  
       
       
CREATE VIEW analysis.orderstatuslog AS
        SELECT *
        FROM production.orderstatuslog; 
        
CREATE VIEW analysis.users AS
        SELECT *
        FROM production.users; 