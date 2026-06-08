import pymysql
from pymysql.cursors import DictCursor

class Sql:
    def __init__(self):
        self.conn = pymysql.connect(
            host='127.0.0.1',
            port=3306,
            database='demo',
            user='root',
            password='',
            cursorclass=DictCursor,
            autocommit=True
        )
        self.cur = self.conn.cursor()

    def autho(self, login, password):
        self.cur.execute('select * from users where login=%s and password=%s', (login, password))
        return self.cur.fetchone()

    def all_products(self):
        self.cur.execute('SELECT p.id_prod, p.art, c.name_cat, p.name_prod, p.description_prod, m.name_man, s.name_sup, p.price, p.quantity, p.current_discount, p.photo FROM products p JOIN categories c ON p.category_id = c.id_cat JOIN manufacturers m ON p.manufacturer_id = m.id_man JOIN suppliers s ON p.supplier_id = s.id_sup')
        return self.cur.fetchall()

    def all_orders(self):
        self.cur.execute('select * from place as p join orders as o on p.id_place=o.pickup_point_id')
        return self.cur.fetchall()

    def search(self, text='',filter='',sort=''):
        query = ('SELECT p.id_prod, p.art, c.name_cat, p.name_prod, p.description_prod, m.name_man, s.name_sup, p.price, p.quantity, p.current_discount, p.photo FROM products p JOIN categories c ON p.category_id = c.id_cat JOIN manufacturers m ON p.manufacturer_id = m.id_man JOIN suppliers s ON p.supplier_id = s.id_sup where 1=1')
        params = []

        if text:
            query += (' and (name_prod LIKE %s)')
            params.append(f'%{text}%')

        if filter == 'Женская обувь':
            query += (" and name_cat = 'Женская обувь'")
        elif filter == 'Мужская обувь':
            query += (" and name_cat = 'Мужская обувь'")

        if sort == 'по цене вверх':
            query += (' order by price asc')
        elif sort == 'по цене вниз':
            query += (' order by price desc')

        self.cur.execute(query, params)
        return self.cur.fetchall()

    def delete(self, id_prod):
        self.cur.execute("delete from products where id_prod=%s", (id_prod))

    def update(self, art, name_prod, quantity, price, supplier_id, manufacturer_id, category_id, current_discount, description_prod, photo, id):
        self.cur.execute('update products set art=%s, name_prod=%s, quantity=%s, price=%s, supplier_id=%s, manufacturer_id=%s, category_id=%s, current_discount=%s, description_prod=%s, photo=%s where id_prod=%s', (art, name_prod, quantity, price, supplier_id, manufacturer_id, category_id, current_discount, description_prod, photo, id))
        return self.cur.fetchall()

    def add(self, art, name_prod, quantity, price, supplier_id, manufacturer_id, category_id, current_discount, description_prod, photo):
        self.cur.execute('INSERT INTO products (art, name_prod, quantity, price, supplier_id, manufacturer_id, category_id, current_discount, description_prod, photo) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (art, name_prod, quantity, price, supplier_id, manufacturer_id, category_id, current_discount, description_prod, photo))
        return self.cur.fetchall()