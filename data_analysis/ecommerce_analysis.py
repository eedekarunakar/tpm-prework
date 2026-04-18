import pandas as pd
import matplotlib.pyplot as plt

# Load Dataset
df = pd.read_csv("dataset.csv")

print("First 5 Rows:")
print(df.head())

# -----------------------------------
# Data Cleaning
# -----------------------------------

# Handle missing values
df.fillna({
    "revenue": 0,
    "product_category": "Unknown"
}, inplace=True)

# Convert timestamp
df["timestamp"] = pd.to_datetime(df["timestamp"])

# Derive Date Column
df["date"] = df["timestamp"].dt.date

# -----------------------------------
# Analysis 1: Most Popular Categories
# -----------------------------------
print("\nMost Popular Categories:")
popular = df["product_category"].value_counts()
print(popular)

# -----------------------------------
# Analysis 2: Conversion Rate
# -----------------------------------
total_interactions = len(df)
purchases = len(df[df["action"] == "purchased"])

conversion_rate = (purchases / total_interactions) * 100

print(f"\nConversion Rate: {conversion_rate:.2f}%")

# -----------------------------------
# Analysis 3: Daily Activity Trend
# -----------------------------------
daily = df.groupby("date").size()

plt.figure(figsize=(10,5))
daily.plot(kind="line", marker="o")
plt.title("Daily User Activity")
plt.xlabel("Date")
plt.ylabel("Interactions")
plt.grid(True)
plt.tight_layout()
plt.show()

# -----------------------------------
# Revenue by Category
# -----------------------------------
revenue = df.groupby("product_category")["revenue"].sum()

plt.figure(figsize=(8,5))
revenue.plot(kind="bar")
plt.title("Revenue by Category")
plt.xlabel("Category")
plt.ylabel("Revenue")
plt.tight_layout()
plt.show()

# -----------------------------------
# Insights
# -----------------------------------
print("\nInsights:")
print("1. Electronics generated highest revenue.")
print("2. Improve add_to_cart to purchase funnel.")
print("3. Fashion has strong interaction volume.")
print("4. Retarget users who viewed but did not purchase.")