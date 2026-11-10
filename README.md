# E-commerce Sales Analysis

**Business question:** Where does the revenue of an online furniture store come from, and what drives it?

**Tools:** BigQuery SQL · Python (pandas, seaborn, SciPy) · Tableau Public

**Links:** [Tableau dashboard](https://public.tableau.com/app/profile/mykhailo.myroshnychenko/viz/E-commerceSalesTrafficDashboard/SalesOverview) · [Colab notebook](https://colab.research.google.com/drive/1OGtSHQL8DobMrh3RQmw6C7YP1ntJdMT1?usp=sharing)

---

## Data

349,545 web sessions from Nov 1, 2020 to Jan 31, 2021, built from 6 BigQuery tables
(`session`, `session_params`, `account_session`, `account`, `order`, `product`).
The query in [`sql/sales_dataset.sql`](sql/sales_dataset.sql) joins them with `LEFT JOIN` into one row per session,
so sessions without an account or an order are kept.

## Key findings

- **Geography:** the Americas bring 17.7M USD, 55% of revenue; the US alone brings 44%. That is a concentration risk.
- **Products:** sofas, chairs and beds generate 61% of revenue. Bookcases are the most frequently ordered category, but their average order is about 480 USD vs 1,950 USD for sofas.
- **Time:** December is the strongest month (12.4M USD). Tuesday and Wednesday bring about 36% more revenue than weekend days.
- **Traffic:** daily sessions and sales correlate strongly (Spearman 0.87, p < 0.001), while conversion stays stable at about 9.6%. Growth comes from traffic volume, not from basket size.
- **Devices:** desktop brings about 59% of sales in every major region; the device mix does not depend on geography or traffic channel.
- **Users:** unregistered users bring 11x more revenue per day (Mann-Whitney U, p < 0.001), but only because the group is bigger: per session, registered users buy just as much.
- **Channels:** daily sessions differ significantly between all traffic channels (Kruskal-Wallis H = 248.6, p < 0.001); organic search leads with a median of 1,332 sessions per day.
- **Regions:** organic search brings the same share of traffic in Europe and the Americas, 35.6% (z-test, p = 0.98).

## Methods

- Data cleaning: checked types, missing values (explained by `LEFT JOIN`, not errors) and an incomplete period (no sales on Jan 28–31).
- EDA: sales by continent, country, category, device and traffic channel; pivot tables; daily and weekly dynamics.
- Statistics: Shapiro-Wilk normality tests; Spearman or Pearson correlation depending on the distribution; Mann-Whitney U, Kruskal-Wallis with Bonferroni-corrected pairwise tests, and a z-test for two proportions.
- Incomplete days (Jan 28–31) excluded from all per-day tests so they do not distort the results.

## Dashboard

[![Dashboard](images/dashboard.png)](https://public.tableau.com/app/profile/mykhailo.myroshnychenko/viz/E-commerceSalesTrafficDashboard/SalesOverview)

## How to run

The data lives in a private BigQuery course project (`data-analytics-mate`), so the notebook needs access to it.
Without access, the notebook can still be read on GitHub with all outputs and charts saved.
