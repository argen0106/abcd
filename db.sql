DROP DATABASE demo;
CREATE DATABASE demo;
USE demo;

CREATE TABLE users (
    id_users INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    login VARCHAR(100),
    password VARCHAR(255),
	role ENUM('admin', 'manager', 'client')
);

INSERT INTO users (full_name, login, password, role) VALUES
('Никифорова Весения Николаевна', 'admin', 'admin', 'admin'),
('Степанов Михаил Артёмович', 'manager', 'manager', 'manager'),
('Старикова Елена Павловна', 'client', 'client', 'client');

CREATE TABLE suppliers (
    id_sup INT PRIMARY KEY AUTO_INCREMENT,
    name_sup VARCHAR(100)
);

INSERT INTO suppliers (name_sup) VALUES
('Kari'),
('Обувь для вас');

CREATE TABLE manufacturers (
    id_man INT PRIMARY KEY AUTO_INCREMENT,
    name_man VARCHAR(100)
);

INSERT INTO manufacturers (name_man) VALUES
('house'),
('Addidas'),
('Nike'),
('Puma'),
('Alessio Nesca'),
('CROSBY');

CREATE TABLE categories (
    id_cat INT PRIMARY KEY AUTO_INCREMENT,
    name_cat VARCHAR(100)
);

INSERT INTO categories (name_cat) VALUES
('Женская обувь'),
('Мужская обувь');

CREATE TABLE products (
    id_prod INT PRIMARY KEY AUTO_INCREMENT,
    art VARCHAR(250),
    name_prod VARCHAR(255),
    quantity VARCHAR(20) DEFAULT 'шт.',
    price DECIMAL(10,2),
    supplier_id INT,
    manufacturer_id INT,
    category_id INT,
    current_discount INT DEFAULT 0,
    description_prod varchar(255),
    photo VARCHAR(255),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id_sup),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id_man),
    FOREIGN KEY (category_id) REFERENCES categories(id_cat)
);

INSERT INTO products (art, name_prod, quantity, price, supplier_id, manufacturer_id, category_id, current_discount, description_prod, photo) VALUES
('А112Т4', 'Ботинки', '4 шт.', 4990, 1, 1, 1, 3, 'Женские Ботинки демисезонные kari', null),
('F635R4', 'Ботинки', '2 шт.', 3244, 2, 2, 1, 2, 'Ботинки Marco Tozzi женские демисезонные, размер 39, цвет бежевый', null),
('H782T5', 'Туфли', '2 шт.', 4499, 1, 1, 2, 4, 'Туфли kari мужские классика MYZ21AW-450A, размер 43, цвет: черный', null),
('G783F5', 'Ботинки', '3 шт.', 5900, 1, 3, 2, 2, 'Мужские ботинки Рос-Обувь кожаные с натуральным мехом', null),
('J384T6', 'Ботинки', '4 шт.', 3800, 2, 4, 2, 2, 'B3430/14 Полуботинки мужские Rieker', null),
('D572U8', 'Кроссовки', '4 шт.', 4100, 2, 3, 2, 3, '129615-4 Кроссовки мужские', null),
('F572H7', 'Туфли', '55 шт.', 2700, 1, 2, 1, 2, 'Туфли Marco Tozzi женские летние, размер 39, цвет черный', null);

CREATE TABLE place (
    id_place INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(255)
);

INSERT INTO place (address) VALUES
('420151, г. Балашиха, ул. Бояринова, 32'),
('125061, г. Москва, ул. Старокачаловская, 8'),
('630370, г. Балашиха, ул. Кучино, 24'),
('400562, г. Москва, ул. Зеленая, 32'),
('614510, г. Балашиха, ул. Маяковского, 47'),
('410542, г. Москва, ул. Светлая, 46'),
('620839, г. Балашиха, ул. Цветочная, 8');

CREATE TABLE orders (
    id_ord INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50),
    order_date DATE,
    delivery_date DATE,
    pickup_point_id INT,
    user_id INT,
    pickup_code VARCHAR(50),
    status_order VARCHAR(50) ,
    FOREIGN KEY (pickup_point_id) REFERENCES place(id_place),
    FOREIGN KEY (user_id) REFERENCES users(id_users)
);

INSERT INTO orders (order_number, order_date, delivery_date, pickup_point_id, user_id, pickup_code, status_order) VALUES
('ORD-001', '2026-06-01', '2026-06-05', 1, 1, 'A123', 'Новый'),
('ORD-002', '2026-06-02', '2026-06-06', 2, 2, 'B456', 'В обработке'),
('ORD-003', '2026-06-03', '2026-06-07', 3, 1, 'C789', 'Готов к выдаче'),
('ORD-004', '2026-06-04', '2026-06-08', 4, 2, 'D321', 'Доставлен'),
('ORD-005', '2026-06-05', '2026-06-09', 5, 1, 'E654', 'Отменен');

CREATE TABLE order_items (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id_ord) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id_prod)
);


SELECT
    c.name_cat, p.name_prod, p.description_prod, m.name_man, s.name_sup, p.price, p.quantity, p.current_discount, p.photo
FROM products p
JOIN categories c ON p.category_id = c.id_cat
JOIN manufacturers m ON p.manufacturer_id = m.id_man
JOIN suppliers s ON p.supplier_id = s.id_sup;

--все продукты
SELECT p.id_prod, p.art, c.name_cat, p.name_prod, p.description_prod, m.name_man, s.name_sup, p.price, p.quantity, p.current_discount, p.photo
FROM products p JOIN categories c ON p.category_id = c.id_cat
JOIN manufacturers m ON p.manufacturer_id = m.id_man JOIN suppliers s ON p.supplier_id = s.id_sup

--для заказов
select * from place as p join orders as o on p.id_place=o.pickup_point_id