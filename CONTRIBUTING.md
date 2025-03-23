# Contributing Guidelines

This document outlines the coding standards and best practices for the Financial Data ETL Pipeline project. Following these guidelines ensures code consistency, readability, and maintainability.

## Table of Contents

- [Python Standards](#python-standards)
- [SQL Standards](#sql-standards)
- [Docker Standards](#docker-standards)
- [Git Workflow](#git-workflow)
- [Testing Requirements](#testing-requirements)
- [Documentation Guidelines](#documentation-guidelines)

## Python Standards

### Naming Conventions

- **Variables and Functions**: Use `snake_case` (e.g., `daily_return`, `calculate_volatility`)
- **Classes**: Use `PascalCase` (e.g., `StockDataProcessor`, `FinancialStatementParser`)
- **Constants**: Use `UPPER_SNAKE_CASE` (e.g., `MAX_API_RETRIES`, `DEFAULT_RISK_FREE_RATE`)
- **Private Methods/Variables**: Use leading underscore (e.g., `_calculate_internal_metric`)
- **Modules**: Use `snake_case` for file names (e.g., `stock_processor.py`)

### Formatting

- Use **4 spaces** for indentation (no tabs)
- Maximum line length: **88 characters** (Black formatter standard)
- Use parentheses for line continuation
- Always use explicit line continuation inside parentheses rather than backslashes
- Add two blank lines before class definitions and one blank line before method definitions
- Use single quotes for simple strings, double quotes for strings with apostrophes or when string contains single quotes

### Documentation

- All functions must have docstrings following Google style format
- All classes must have docstrings explaining their purpose
- Complex financial calculations must include formula explanations
- Include units (e.g., "returns percentage as decimal, not %")
- Document any assumptions made in financial calculations

### Imports

- Order imports as follows:
  1. Standard library imports
  2. Related third-party imports
  3. Local application/library-specific imports
- Separate import groups with a blank line
- Use absolute imports for clarity

```python
# Standard library
import datetime
import json
from typing import Dict, List, Optional

# Third-party libraries
import numpy as np
import pandas as pd
import requests
from fastapi import APIRouter, Depends, HTTPException

# Local modules
from app.core.database import get_db
from app.models.stock_data import StockPrice
```

### Error Handling

- Use specific exceptions rather than bare `except:`
- Log exceptions with context about what happened
- Financial calculation errors should provide clear diagnostics
- Always use `try`/`except` when dealing with external APIs or data sources

### Type Hints

- Use type hints for function parameters and return values
- Use `Optional` for parameters that might be None
- Use `Union` for parameters that might be of multiple types

### Example Function

```python
def calculate_sharpe_ratio(
    returns: pd.Series, 
    risk_free_rate: float = 0.0,
    trading_days_per_year: int = 252
) -> float:
    """
    Calculate Sharpe ratio for a series of returns.
    
    Args:
        returns: Daily returns as decimals (not percentages)
        risk_free_rate: Annual risk-free rate as decimal
        trading_days_per_year: Number of trading days in a year
        
    Returns:
        Annualized Sharpe ratio
        
    Formula:
        Sharpe = (Mean_Return - Risk_Free_Rate) / StdDev_Return
        Annualized by multiplying by sqrt(trading_days_per_year)
        
    Raises:
        ValueError: If returns series is empty or contains invalid values
    """
    if len(returns) == 0:
        raise ValueError("Empty returns series provided")
        
    try:
        # Convert annual risk-free rate to daily
        daily_risk_free = risk_free_rate / trading_days_per_year
        
        excess_return = returns.mean() - daily_risk_free
        return_volatility = returns.std()
        
        if return_volatility == 0:
            return 0  # Avoid division by zero
            
        sharpe = excess_return / return_volatility
        annualized_sharpe = sharpe * np.sqrt(trading_days_per_year)
        
        return annualized_sharpe
    except Exception as e:
        logger.error(f"Error calculating Sharpe ratio: {e}")
        raise
```

## SQL Standards

### Naming Conventions

- **Tables**: Use `snake_case`, plural (e.g., `daily_prices`, `economic_indicators`)
- **Columns**: Use `snake_case` (e.g., `adjusted_close`, `fiscal_date_ending`)
- **Primary Keys**: Use `id` or `table_name_id`
- **Foreign Keys**: Use `referenced_table_singular_name_id` (e.g., `company_id`)
- **Indexes**: Use `idx_table_name_column_name` format

### Formatting

- Keywords in UPPERCASE (e.g., `SELECT`, `FROM`, `JOIN`)
- Commas at the end of lines, not the beginning
- Indentation for clauses (4 spaces)
- Aliases for table names (especially in complex queries)
- Each major clause (SELECT, FROM, WHERE, etc.) should start on a new line

### Documentation

- Comment blocks at the beginning of complex queries
- Comments explaining non-obvious joins or conditions
- Document performance considerations for complex queries

### Example Query

```sql
-- Calculate monthly average prices by stock
-- Includes adjustment for trading volume
-- Note: Volume-weighted avg gives higher importance to high-volume days
SELECT 
    dp.symbol,
    DATE_TRUNC('month', dp.date) AS month,
    SUM(dp.close * dp.volume) / NULLIF(SUM(dp.volume), 0) AS volume_weighted_avg_price,
    AVG(dp.close) AS simple_avg_price,
    COUNT(*) AS trading_days
FROM 
    stock_data.daily_prices dp
WHERE 
    dp.date >= '2020-01-01'
    AND dp.volume > 0  -- Exclude zero-volume days
GROUP BY 
    dp.symbol,
    DATE_TRUNC('month', dp.date)
ORDER BY 
    dp.symbol,
    month;
```

## Docker Standards

### Image Building

- Use specific versions for base images, not `latest`
- Use multi-stage builds where appropriate to reduce image size
- Include only necessary files in the Docker context

### Docker Compose

- Use descriptive service names
- Group environment variables logically
- Use environment files for sensitive information
- Include comments for non-obvious configuration options

### Example Docker Compose Service

```yaml
# API service for financial data
api:
  build:
    context: ./api
    dockerfile: Dockerfile
  container_name: fintech_api
  depends_on:
    - timescaledb
  ports:
    - "8000:8000"
  volumes:
    - ./api:/app
  environment:
    # Database connection
    - DATABASE_URL=postgresql://fintech:fintech_password@timescaledb:5432/fintech_data
    # API configuration
    - LOG_LEVEL=info
    - ENABLE_CORS=true
    - MAX_WORKERS=4
  restart: unless-stopped
```

## Git Workflow

### Branches

- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/feature-name`: New features or enhancements
- `fix/bug-description`: Bug fixes
- `refactor/description`: Code refactoring without changing functionality

### Commit Messages

Follow the conventional commits specification:

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

Example:
```
feat(stock-api): add endpoint for retrieving technical indicators

- Added RSI, MACD, and Bollinger Bands calculations
- Created new route /stocks/{symbol}/indicators
- Added unit tests for indicator calculations
```

## Testing Requirements

### Unit Tests

- Write tests for all financial calculations
- Test edge cases (empty datasets, extreme values, etc.)
- Aim for at least 80% code coverage

### Integration Tests

- Test data flows from extraction to loading
- Verify API endpoints return expected data
- Test database interactions

### Example Test

```python
def test_calculate_sharpe_ratio():
    """Test the Sharpe ratio calculation with known values."""
    # Arrange
    returns = pd.Series([0.001, 0.002, -0.001, 0.003, 0.002])
    risk_free_rate = 0.01  # 1% annual
    
    # Act
    result = calculate_sharpe_ratio(returns, risk_free_rate)
    
    # Assert
    expected = 1.27  # Pre-calculated expected result
    np.testing.assert_almost_equal(result, expected, decimal=2)
```

## Documentation Guidelines

### README.md

- Project overview and purpose
- Installation instructions
- Quick start guide
- Features list
- Configuration options
- Architecture diagram

### Code Comments

- Comment complex algorithms
- Explain why, not what (the code shows what, comments explain why)
- Document known limitations or edge cases

### API Documentation

- Document all endpoints
- Include example requests and responses
- List all query parameters and their purpose

## Development Environment Setup

To enforce these standards, the project includes the following tools:

1. **Black**: Code formatter
   - Configuration in `pyproject.toml`
   - Run with `black .`

2. **isort**: Import sorter
   - Configuration in `pyproject.toml`
   - Run with `isort .`

3. **flake8**: Linter
   - Configuration in `setup.cfg`
   - Run with `flake8 .`

4. **mypy**: Type checker
   - Configuration in `mypy.ini`
   - Run with `mypy .`

5. **Pre-commit**: Git hooks
   - Configuration in `.pre-commit-config.yaml`
   - Install with `pre-commit install`

## Configuration Files

### pyproject.toml

```toml
[tool.black]
line-length = 88
target-version = ['py310']
include = '\.pyi?$'

[tool.isort]
profile = "black"
line_length = 88
multi_line_output = 3
include_trailing_comma = true
```

### setup.cfg

```ini
[flake8]
max-line-length = 88
extend-ignore = E203
exclude = .git,__pycache__,build,dist
```

### .pre-commit-config.yaml

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files

-   repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
    -   id: isort

-   repo: https://github.com/psf/black
    rev: 23.7.0
    hooks:
    -   id: black

-   repo: https://github.com/pycqa/flake8
    rev: 6.1.0
    hooks:
    -   id: flake8
```
