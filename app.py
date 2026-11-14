from flask import Flask, render_template, request, redirect, url_for, abort
import psycopg2
from config import config

app = Flask(__name__)

# Product lines: URL name -> display name.
# Each line needs 3 tables: <line>, <line>_maker, <line>_order_history
LINES = {
    "gloves": "Gloves",
    "jerseys": "Jerseys",
    "balls": "Balls",
}


def check_line(line):
    if line not in LINES:
        abort(404)


def run(sql, params=(), fetch=False):
    """Run one SQL statement. Commits on success, rolls back on error."""
    conn = psycopg2.connect(**config())
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute(sql, params)
                return cur.fetchall() if fetch else None
    finally:
        conn.close()


def check_credentials(username, password):
    try:
        rows = run("SELECT 1 FROM users WHERE u_name = %s AND u_password = %s",
                   (username, password), fetch=True)
        return len(rows) > 0
    except Exception as e:
        print("Login error:", e)
        return False


# ---------- Login and home ----------
@app.route("/")
def application():
    return render_template("login.html")


@app.route("/Home_Page", methods=["POST"])
def button_click():
    if check_credentials(request.form["u"], request.form["p"]):
        return render_template("index.html", lines=LINES)
    return "Invalid credentials.", 400


@app.route("/home")
def home():
    return render_template("index.html", lines=LINES)


# ---------- Products ----------
@app.route("/<line>/products")
def products(line):
    check_line(line)
    rows = run(f"SELECT p_id, p_name, size, material, colour, description "
               f"FROM {line} ORDER BY p_id", fetch=True)
    return render_template("products.html", line=line, label=LINES[line], products=rows)


@app.route("/<line>/products/add", methods=["GET", "POST"])
def add_product(line):
    check_line(line)
    if request.method == "POST":
        f = request.form
        run(f"INSERT INTO {line} (p_name, size, material, colour, description) "
            f"VALUES (%s, %s, %s, %s, %s)",
            (f["product_name"], f["size"], f["material"], f["colour"], f["description"]))
        return redirect(url_for("products", line=line))
    return render_template("add_product.html", line=line, label=LINES[line])


@app.route("/<line>/products/delete", methods=["GET", "POST"])
def delete_product(line):
    check_line(line)
    error = None
    if request.method == "POST":
        try:
            run(f"DELETE FROM {line} WHERE p_id = %s", (request.form["delete_item"],))
            return redirect(url_for("products", line=line))
        except psycopg2.Error:
            error = "Cannot delete this product: it is used in the order history."
    rows = run(f"SELECT p_id, p_name, size FROM {line} ORDER BY p_id", fetch=True)
    return render_template("delete_product.html", line=line, label=LINES[line],
                           products=rows, error=error)


# ---------- Makers ----------
@app.route("/<line>/makers")
def makers(line):
    check_line(line)
    rows = run(f"SELECT m_id, m_name, address, contact_no FROM {line}_maker ORDER BY m_id",
               fetch=True)
    return render_template("makers.html", line=line, label=LINES[line], makers=rows)


# ---------- Order history ----------
@app.route("/<line>/order_history")
def order_history(line):
    check_line(line)
    rows = run(
        f"SELECT p.p_name, m.m_name, o.total_quantity, o.quantity_delivered, "
        f"o.quantity_pending, o.price_per_item, o.total_price "
        f"FROM {line}_order_history o "
        f"LEFT JOIN {line} p ON p.p_id = o.p_id "
        f"LEFT JOIN {line}_maker m ON m.m_id = o.m_id", fetch=True)
    return render_template("order_history.html", line=line, label=LINES[line], orders=rows)




# ---------- Add maker ----------
@app.route("/<line>/makers/add", methods=["GET", "POST"])
def add_maker(line):
    check_line(line)
    if request.method == "POST":
        f = request.form
        run(f"INSERT INTO {line}_maker (m_name, address, cnic, contact_no) "
            f"VALUES (%s, %s, %s, %s)",
            (f["m_name"], f["address"], f["cnic"], f["contact_no"]))
        return redirect(url_for("makers", line=line))
    return render_template("add_maker.html", line=line, label=LINES[line])


# ---------- New order ----------
@app.route("/<line>/order_history/add", methods=["GET", "POST"])
def add_order(line):
    check_line(line)
    error = None
    if request.method == "POST":
        f = request.form
        try:
            qty = int(f["total_quantity"])
            delivered = int(f["quantity_delivered"])
            price = float(f["price_per_item"])
            if qty < 0 or delivered < 0 or price < 0:
                error = "Values cannot be negative."
            elif delivered > qty:
                error = "Delivered quantity cannot be greater than the total quantity."
            else:
                run(f"INSERT INTO {line}_order_history "
                    f"(p_id, m_id, total_quantity, quantity_delivered, price_per_item) "
                    f"VALUES (%s, %s, %s, %s, %s)",
                    (f["p_id"], f["m_id"], qty, delivered, price))
                return redirect(url_for("order_history", line=line))
        except ValueError:
            error = "Quantity and price must be numbers."
    products = run(f"SELECT p_id, p_name FROM {line} ORDER BY p_name", fetch=True)
    makers = run(f"SELECT m_id, m_name FROM {line}_maker ORDER BY m_name", fetch=True)
    return render_template("add_order.html", line=line, label=LINES[line],
                           products=products, makers=makers, error=error)


if __name__ == "__main__":
    app.run(debug=True)
