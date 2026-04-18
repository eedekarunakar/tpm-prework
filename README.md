TPM Prework Assignment
📌 Project Overview
This project was developed as part of the TPM technical prework assignment.
It contains three major parts:
REST API Development using Flask
Database Design & SQL using PostgreSQL (Supabase)
Data Analysis & Visualization using Python
---
🚀 Tech Stack
Python 3.x
Flask
Flask SQLAlchemy
JWT Authentication
Swagger UI
PostgreSQL (Supabase)
Pandas
Matplotlib
---
📁 Project Structure
```text
tpm-prework/
│── app.py
│── requirements.txt
│── .env
│── README.md
│
├── database/
│   └── schema.sql
│
├── data_analysis/
│   ├── dataset.csv
│   └── ecommerce_analysis.py
```
---
✅ Part 1: REST API
Features
Add Records
Retrieve Records
Filter by Category / Status
Update Records
Delete Records
JWT Authentication
Swagger API Documentation
---
▶ Run Application
```bash
pip install -r requirements.txt
python app.py
```
Application runs at:
```text
http://127.0.0.1:5000
```
Swagger UI:
```text
http://127.0.0.1:5000/apidocs
```
---
🔐 Login Credentials
```json
{
  "username": "admin",
  "password": "admin123"
}
```
---
📌 API Endpoints
Method	Endpoint	Description
POST	/login	Generate JWT Token
POST	/records	Add Record
GET	/records	Get All Records
GET	/records?status=Active	Filter Records
PUT	/records/{id}	Update Record
DELETE	/records/{id}	Delete Record
---
🗄 Part 2: Database Design
Tables Created
customers
products
orders
order_items
payments
SQL File
```text
database/schema.sql
```
Included Queries
Top 3 customers with highest orders
Orders placed in last 30 days
Total revenue by product
---
📊 Part 3: Data Analysis
Files
```text
data_analysis/dataset.csv
data_analysis/ecommerce_analysis.py
```
Analysis Performed
Missing value handling
Timestamp formatting
Popular categories
Conversion rate
Daily activity trends
Revenue by category
Run Analysis
```bash
cd data_analysis
python ecommerce_analysis.py
```
---
📈 Key Insights
Electronics generated highest revenue
Strong Fashion interaction traffic
Improve cart-to-purchase conversion
Retarget non-converted visitors
---
☁ Database Hosting
Supabase PostgreSQL used as cloud database.
---
👨‍💻 Developed By
Karunakar Eede
---
✅ Submission Ready
Includes:
Source Code
API
SQL Scripts
Analysis
Documentation
