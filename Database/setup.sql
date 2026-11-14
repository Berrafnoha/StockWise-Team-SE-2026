-- Table for Football
CREATE TABLE Football (
    P_ID SERIAL PRIMARY KEY,
    P_name VARCHAR(255),
    Size VARCHAR(50),
    Material VARCHAR(50),
    Colour VARCHAR(50),
    Description TEXT,
    Picture VARCHAR(255)
);

-- Table for Football manufacturer
CREATE TABLE Football_Maker (
    M_ID SERIAL PRIMARY KEY,
    M_name VARCHAR(255),
    Address TEXT,
    CNIC VARCHAR(15),
    Contact_no VARCHAR(15),
    Picture VARCHAR(255)
);

-- Table for order history (Football)
CREATE TABLE Football_Order_History (
    P_ID INT REFERENCES Football(P_ID),
    M_ID INT REFERENCES Football_Maker(M_ID),
    Total_Quantity INT,
    Quantity_Delivered INT,
    Quantity_Pending INT GENERATED ALWAYS AS (Total_Quantity - Quantity_Delivered) STORED,
    Price_Per_Item DECIMAL(10,2),
    Total_Price DECIMAL(10,2) GENERATED ALWAYS AS (Quantity_Delivered * Price_Per_Item) STORED
);


--------------------------------------------------------------------------------------------------------------

-- Tables for Gloves
CREATE TABLE Gloves (
    P_ID SERIAL PRIMARY KEY,
    P_name VARCHAR(255),
    Size VARCHAR(50),
    Material VARCHAR(50),
    Colour VARCHAR(50),
    Description TEXT,
    Picture VARCHAR(255)
);

-- Table for Gloves manufacturer
CREATE TABLE Gloves_Maker (
    M_ID SERIAL PRIMARY KEY,
    M_name VARCHAR(255),
    Address TEXT,
    CNIC VARCHAR(15),
    Contact_no VARCHAR(15),
    Picture VARCHAR(255)
);

-- Table for order history (Gloves)
CREATE TABLE Gloves_Order_History (
    P_ID INT REFERENCES Gloves(P_ID),
    M_ID INT REFERENCES Gloves_Maker(M_ID),
    Total_Quantity INT,
    Quantity_Delivered INT,
    Quantity_Pending INT GENERATED ALWAYS AS (Total_Quantity - Quantity_Delivered) STORED,
    Price_Per_Item DECIMAL(10,2),
    Total_Price DECIMAL(10,2) GENERATED ALWAYS AS (Quantity_Delivered * Price_Per_Item) STORED
);
--user table for authentication
CREATE TABLE users(u_name VARCHAR,u_password VARCHAR);

INSERT INTO users(u_name,u_password) VALUES ('user 1','12345'),('user 2','12345'),('user 3','12345');
CREATE OR REPLACE FUNCTION authenticate_user(u_nam VARCHAR(255), u_pin VARCHAR(255))
RETURNS BOOLEAN AS $$
DECLARE
    user_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM users WHERE u_name = authenticate_user.u_nam AND u_password = authenticate_user.u_pin
    ) INTO user_exists;

    RETURN user_exists;
END;
$$ LANGUAGE plpgsql;

SELECT authenticate_user('user 1', '12345');
select * from users;


--inserting some demo data--
INSERT INTO gloves(p_id,p_name,size,material,colour,description) Values (10001,'Working Gloves','L','Soft','Yellow','No Description');
INSERT INTO gloves_maker(m_id,m_name,address,cnic,contact_no) Values (30001,'Ahmed Naeem','House # 274','121323',03203002900);
INSERT INTO gloves_order_history(p_id,m_id,total_quantity,quantity_delivered,price_per_item) VALUES (10001,20001,100,50, 10);

SELECT * FROM gloves_order_history;
SELECT * FROM gloves_maker;
SELECT * FROM gloves;


DROP TABLE IF EXISTS football_order_history, football_maker, football;

CREATE TABLE jerseys (
  p_id SERIAL PRIMARY KEY, p_name VARCHAR(255), size VARCHAR(50),
  material VARCHAR(50), colour VARCHAR(50), description TEXT, picture VARCHAR(255)
);
CREATE TABLE jerseys_maker (
  m_id SERIAL PRIMARY KEY, m_name VARCHAR(255), address TEXT,
  cnic VARCHAR(15), contact_no VARCHAR(15), picture VARCHAR(255)
);
CREATE TABLE jerseys_order_history (
  p_id INTEGER REFERENCES jerseys(p_id),
  m_id INTEGER REFERENCES jerseys_maker(m_id),
  total_quantity INTEGER, quantity_delivered INTEGER,
  quantity_pending INTEGER GENERATED ALWAYS AS (total_quantity - quantity_delivered) STORED,
  price_per_item NUMERIC(10,2),
  total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity_delivered::numeric * price_per_item) STORED
);

CREATE TABLE balls (
  p_id SERIAL PRIMARY KEY, p_name VARCHAR(255), size VARCHAR(50),
  material VARCHAR(50), colour VARCHAR(50), description TEXT, picture VARCHAR(255)
);
CREATE TABLE balls_maker (
  m_id SERIAL PRIMARY KEY, m_name VARCHAR(255), address TEXT,
  cnic VARCHAR(15), contact_no VARCHAR(15), picture VARCHAR(255)
);
CREATE TABLE balls_order_history (
  p_id INTEGER REFERENCES balls(p_id),
  m_id INTEGER REFERENCES balls_maker(m_id),
  total_quantity INTEGER, quantity_delivered INTEGER,
  quantity_pending INTEGER GENERATED ALWAYS AS (total_quantity - quantity_delivered) STORED,
  price_per_item NUMERIC(10,2),
  total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity_delivered::numeric * price_per_item) STORED
);

INSERT INTO jerseys (p_name, size, material, colour, description) VALUES ('Home Jersey', 'M', 'Polyester', 'Red', 'Breathable match jersey');
INSERT INTO jerseys_maker (m_name, address, cnic, contact_no) VALUES ('Atlas Textile Works', 'Zone Industrielle, Oran', '12345-1111111-1', '0551112233');
INSERT INTO jerseys_order_history (p_id, m_id, total_quantity, quantity_delivered, price_per_item)
  SELECT p.p_id, m.m_id, 300, 150, 18.00 FROM jerseys p, jerseys_maker m LIMIT 1;

INSERT INTO balls (p_name, size, material, colour, description) VALUES ('Match Ball', '5', 'Synthetic leather', 'White', 'Official size 5 match ball');
INSERT INTO balls_maker (m_name, address, cnic, contact_no) VALUES ('Sidi Sports Factory', 'Rue de la Gare, Setif', '12345-2222222-2', '0662223344');
INSERT INTO balls_order_history (p_id, m_id, total_quantity, quantity_delivered, price_per_item)
  SELECT p.p_id, m.m_id, 200, 200, 9.50 FROM balls p, balls_maker m LIMIT 1;
