# Pesa Pulse – API Data Analysis

## Project Overview

This project retrieves sample customer records from the JSONPlaceholder Users API. It explores nested JSON, extracts useful attributes, and analyses customer locations using Python and pandas.

## Approach

The notebook retrieves data using `requests`, explores nested dictionaries and lists, and extracts customer attributes. Sets identify unique cities, while dictionaries count customers by city and email domain. The records are converted into a pandas DataFrame, exported to CSV, and visualised using Matplotlib.

## Key Findings

- The API returned 10 sample customer records.
- The records represented 10 different cities, with one customer per city.
- All 10 customers had different email domains. Python and pandas produced matching city counts.

## Assumptions and Limitations

The records are sample data, not actual Pesa Pulse customers. Each record represents one customer, and the API city is used as their location. This small sample cannot support real marketing decisions.

## Project Outputs

The `output/` folder contains:

- `customers.csv`
- `city_counts.csv`
- `customer_distribution.png`
- `email_domain_distribution.png`
