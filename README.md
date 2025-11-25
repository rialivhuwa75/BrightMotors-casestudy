# 🚗 Bright Motors — Sales Analytics & Insights

A data analytics project exploring used vehicle sales, pricing patterns, and market performance for Bright Motors.  
The goal is to uncover insights that support better inventory, pricing, and business decisions.

---

## 📦 Dataset Overview
- **Rows:** 559,000+
- **Columns:** 17
- **Source:** Historical vehicle sales data

Key fields include:
- Make, Model, Trim, Body Type  
- Odometer, Condition  
- Selling Price, MMR (Market Value)  
- State, Seller  
- Sale Rating (Above / At / Below Market)

---

## 🧭 Project Planning (Miro & Gantt)

### Miro Planning  
A Miro-style planning board was created to outline:

- **Data flow / architecture**
  - Source: CSV car sales file  
  - Storage & cleaning: Snowflake / Excel  
  - Analysis: Excel charts & pivot tables  
  - Presentation: Canva PDF for GitHub

- **Key questions to answer**
  - Which makes/models perform best?
  - How do mileage and condition affect price?
  - How competitive are prices vs MMR?
  - Which states drive the most sales?

This planning helped structure the analysis and dashboard layout before building visuals.

### Gantt Chart (To Be Done)
A simple Gantt chart will still be created to show:

- Data understanding & cleaning  
- Modeling & calculated fields  
- Excel analysis & chart creation  
- Presentation design (Canva)  
- Future Power BI dashboard work  

⚠️ Gantt chart is **planned but not yet implemented** – to be added as the next improvement.

---

## 🛠️ Tools & Techniques Used

- **Excel** — data exploration, pivot tables, charts  
- **Snowflake** — data cleaning & transformation  
- **Canva** — project presentation (PDF)

> 🔹 **Note:** Power BI dashboard is **on pause** and will be added later.  
> 🔹 **No Python was used** in this project.

---

## 🧹 Data Cleaning & Preparation

Cleaning was done in **Snowflake and Excel**:

- Removed duplicates and obvious errors  
- Standardised text and numeric formats  
- Cleaned mileage and condition values  
- Created new derived fields:
  - `price_vs_mmr` — SellingPrice – MMR  
  - `mileage_category` — grouped mileage ranges  
  - `sale_rating` — Above / At / Below Market

This produced a clean dataset ready for Excel analysis and visualisation.

---

## 📊 Analysis & Visualisations (Excel)

Excel pivot tables and charts were used to explore:

- **Cars Sold by Make** (bar chart)  
- **Average Selling Price by Make** (column chart)  
- **Vehicle Condition Distribution** (bar chart)  
- **Odometer vs Selling Price** (scatter plot)

These charts are used in the Canva presentation included in the repo.

---

## 🔍 Key Insights

- **Top Makes:** Toyota, Honda & Ford drive the highest sales volumes.  
- **Pricing:** Luxury brands achieve higher average selling prices.  
- **Mileage Effect:** Higher mileage clearly reduces selling price.  
- **Market Position:** Many vehicles sell **at or slightly above MMR**, showing fair but competitive pricing.  
- **Inventory Profile:** Medium-mileage cars form the bulk of stock.

---

## 💡 Business Recommendations

1. **Increase pricing** for low-mileage vehicles where demand is strong.  
2. **Prioritise** high-performing makes/models in purchasing decisions.  
3. **Review underpriced** “Below Market” vehicles for possible repricing.  
4. **Adopt region-aware pricing** to reflect state-level differences.  
5. Offer **warranty/finance options** for high-mileage vehicles to support sales.

---

## 📁 Repository Structure

```text
/data                 → Raw & cleaned datasets (e.g. car_sales_updated.csv)
/sql                  → Snowflake cleaning / transformation queries
/charts               → PNG exports of Excel charts
/presentation         → Canva-based PDF summary for GitHub
/planning             → Miro-style planning export (image/PDF), future Gantt chart
README.md             → Project description and documentation
