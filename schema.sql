CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_type VARCHAR(50),
    region VARCHAR(50),
    signup_date DATE
);

CREATE TABLE energy_usage (
    usage_id INT PRIMARY KEY,
    customer_id INT,
    usage_date DATE,
    kwh_consumed DECIMAL(10,2),
    meter_type VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
