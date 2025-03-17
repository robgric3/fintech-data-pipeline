# Fintech Data Pipeline

A comprehensive ETL (Extract, Transform, Load) pipeline for financial data, focused on FTSE 100 companies, quarterly financial statements, and economic indicators.

![Project Status](https://img.shields.io/badge/status-in%20development-yellow)
![License](https://img.shields.io/badge/license-MIT-blue)

## Overview

This project aims to demonstrate a production-ready data pipeline for financial analytics, combining multiple data sources to enable insightful analysis and visualization. The pipeline processes three main types of financial data:

1. **Daily Stock Prices** - OHLCV data for FTSE 100 companies
2. **Quarterly Financial Statements** - Key metrics and ratios
3. **Economic Indicators** - UK/EU macroeconomic data

## Features

- **Complete ETL Pipeline**: Automated extraction, transformation, and loading of financial data
- **Data Integration**: Relationships between stock performance, financial fundamentals, and economic trends
- **Advanced Analytics**: Technical indicators, financial ratios, and cross-dataset correlations
- **Interactive Visualizations**: Dashboards for exploring financial data relationships
- **Robust Architecture**: Scalable design with proper error handling and data validation

## Architecture

The system uses a modern tech stack designed for financial data processing:

- **Python 3.10+**: Core language for data processing
- **PostgreSQL/TimescaleDB**: Optimized storage for time-series financial data
- **Apache Airflow**: Workflow orchestration and scheduling
- **FastAPI**: RESTful API for data access
- **Streamlit/Dash**: Interactive visualizations
- **Docker**: Containerization for consistent deployment

## Project Structure

```
financial-etl-pipeline/
├── docker-compose.yml
├── api/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app/
├── airflow/
│   ├── Dockerfile
│   └── requirements.txt
├── dashboard/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app.py
├── dags/
│   ├── stock_prices_dag.py
│   ├── financial_statements_dag.py
│   └── economic_indicators_dag.py
├── init-scripts/
│   └── create_tables.sql
└── docs/
    ├── images/
    └── data_dictionary.md
```

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git
- API keys for data sources (Yahoo Finance, etc.)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/fintech-data-pipeline.git
   cd fintech-data-pipeline
   ```

2. Create a `.env` file with required API keys and configuration:
   ```
   ALPHA_VANTAGE_API_KEY=your_key_here
   POSTGRES_PASSWORD=your_secure_password
   ```

3. Build and start the containers:
   ```
   docker-compose up -d
   ```

4. Access the components:
   - Dashboard: http://localhost:8501
   - API Documentation: http://localhost:8000/docs
   - Airflow UI: http://localhost:8080

## Usage

### Data Pipeline

The data pipeline runs automatically according to the scheduled intervals:
- Stock prices: Daily update after market close
- Financial statements: Quarterly updates aligned with reporting seasons
- Economic indicators: Monthly updates based on release schedules

### API Access

The API provides endpoints for accessing and filtering all data types:

```python
import requests

# Get historical price data for a specific company
response = requests.get('http://localhost:8000/api/stock-prices?symbol=HSBA.L&start_date=2023-01-01')
data = response.json()
```

### Dashboard

The dashboard provides interactive visualizations for exploring the data:
- Stock price technical analysis
- Financial statement trends
- Economic indicator tracking
- Cross-dataset correlation analysis

## Future Enhancements

- Real-time data streaming for intraday prices
- Machine learning models for predictive analytics
- Enhanced security features and access controls
- Cloud deployment optimizations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Data provided by various financial APIs and public sources
- Inspired by real-world financial data engineering systems
