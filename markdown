# README.md

# Stock Tracker

This Ruby application allows users to track stock prices and receive notifications based on defined price thresholds. It utilizes the IEX Cloud API (free tier) to fetch real-time stock data and leverages a simple notification system for alerts.

## Features

*   **Real-time Stock Quotes:** Fetches the latest stock prices from IEX Cloud.
*   **Price Threshold Alerts:**  Allows users to set upper and lower price thresholds for specific stocks.
*   **Configurable Alerting:**  Provides options for different types of notifications (e.g., printing to the console, logging to a file).  Future versions could integrate email or SMS alerts.
*   **Simple Configuration:**  Easily add and manage stocks to track through a configuration file.
*   **Data Persistence (Optional):** Saves the current stock prices and alert settings to a file for persistence between sessions.

## Prerequisites

*   Ruby (version 2.7 or higher)
*   Bundler (for managing dependencies)
*   An IEX Cloud API Key (free tier available)

## Installation

1.  **Clone the repository:**

    ```bash
    git clone <repository_url>
    cd stock-tracker
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Configure the application:**

    *   Rename the `.env.example` file to `.env`.
    *   Edit the `.env` file and replace `YOUR_IEX_CLOUD_API_KEY` with your actual IEX Cloud API key.
    *   Modify the `config/stocks.yml` file to specify the stocks you want to track and their associated alert thresholds.

## Configuration

### .env File

The `.env` file should contain the following: