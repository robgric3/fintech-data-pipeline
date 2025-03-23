import streamlit as st
import requests
import pandas as pd
import plotly.graph_objects as go
import os

# API connection
API_URL = os.getenv("API_URL", "http://api:8000")

# Set page config
st.set_page_config(
    page_title="Fintech Data Dashboard",
    page_icon="📈",
    layout="wide"
)

# Dashboard title
st.title("Financial Data Explorer")

# Sidebar for navigation
st.sidebar.title("Navigation")
page = st.sidebar.radio("Select a page", ["Stock Data", "Financial Statements", "Economic Indicators"])

# Placeholder for each page
if page == "Stock Data":
    st.header("Stock Price Analysis")
    st.write("This section will show stock price charts and technical indicators.")
    
elif page == "Financial Statements":
    st.header("Financial Statements Analysis")
    st.write("This section will show financial ratios and quarterly trends.")

elif page == "Economic Indicators":
    st.header("Economic Indicators")
    st.write("This section will show economic data trends.")