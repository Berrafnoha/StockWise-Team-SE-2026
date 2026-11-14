import psycopg2
from werkzeug.security import generate_password_hash
from config import config

conn = psycopg2.connect(**config())
cur = conn.cursor()
cur.execute("SELECT u_name, u_password FROM users")
for name, pw in cur.fetchall():
    if pw and not pw.startswith(("scrypt:", "pbkdf2:")):
        cur.execute("UPDATE users SET u_password = %s WHERE u_name = %s",
                    (generate_password_hash(pw), name))
        print("hashed password for", name)
conn.commit()
conn.close()
