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
