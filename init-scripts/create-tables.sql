-- Create schema for stock data
CREATE SCHEMA IF NOT EXISTS stock_data;

-- Create hypertable for time-series stock prices
CREATE TABLE IF NOT EXISTS stock_data.daily_prices (
    symbol TEXT NOT NULL,
    date TIMESTAMP NOT NULL,
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC,
    volume BIGINT,
    adjusted_close NUMERIC,
    PRIMARY KEY (symbol, date)
);

-- Create extension if not exists
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

-- Convert to hypertable
SELECT create_hypertable('stock_data.daily_prices', 'date', if_not_exists => TRUE);

-- Create tables for other data types (financial statements, economic indicators)
-- Financial statements table
CREATE SCHEMA IF NOT EXISTS financial_data;

CREATE TABLE IF NOT EXISTS financial_data.quarterly_statements (
    symbol TEXT NOT NULL,
    fiscal_date_ending DATE NOT NULL,
    report_type TEXT NOT NULL,
    revenue NUMERIC,
    gross_profit NUMERIC,
    net_income NUMERIC,
    eps NUMERIC,
    ebitda NUMERIC,
    total_assets NUMERIC,
    total_liabilities NUMERIC,
    total_equity NUMERIC,
    operating_cash_flow NUMERIC,
    capital_expenditure NUMERIC,
    date_reported TIMESTAMP,
    PRIMARY KEY (symbol, fiscal_date_ending, report_type)
);

-- Economic indicators table
CREATE SCHEMA IF NOT EXISTS economic_data;

CREATE TABLE IF NOT EXISTS economic_data.monthly_indicators (
    indicator_id TEXT NOT NULL,
    date DATE NOT NULL,
    value NUMERIC,
    unit TEXT,
    source TEXT,
    last_updated TIMESTAMP,
    PRIMARY KEY (indicator_id, date)
);

-- Create database for Airflow
CREATE DATABASE airflow;
GRANT ALL PRIVILEGES ON DATABASE airflow TO fintech;