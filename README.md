# StockWise 📦💻

**Inventory management system for a glove factory.**

Software Engineering project, 2026 — ENSTA

## Description ℹ️

StockWise is a Flask web application with a PostgreSQL database. It lets users log in and manage glove products, view manufacturers, and check order history.

Features:
- User login
- View, add and delete products
- View manufacturers
- View order history


## Team 👥

- **Berraf Noha**
- **Bakiri Soundous**

Supervised by **Mme Lakhdari**.



## How to Run ▶️

1. Clone the repository:
   ```
   git clone https://github.com/Berrafnoha/StockWise-Team-SE-2026.git
   cd StockWise-Team-SE-2026
   ```
2. Install dependencies:
   ```
   pip install flask psycopg2-binary
   ```
3. Create a PostgreSQL database and run the SQL file in the `Database` folder.
4. Put your database settings in `database.ini`.
5. Start the app:
   ```
   python app.py
   ```
6. Open `http://localhost:5000` in your browser.


## Credits 🙏

This project builds on [Inventory-Management-System](https://github.com/B3TA-BLOCKER/Inventory-Management-System) (itself a fork of [DBMS-PROJECT](https://github.com/Sheikh-Ahmed-Naeem/DBMS-PROJECT)), originally created by Hassaan Ali Bukhari, Ammaid, and Ahmad Naeem.

## License 📄

MIT License. See the [LICENSE](LICENSE) file for details.
