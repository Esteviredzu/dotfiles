#!/bin/bash

# URL Configuration: Replace YOUR_LOCATION_CODE with your actual location code.
WEATHER_URL="https://weather.com/weather/today/l/9244e7d57d39d2179abe548afef9c085cb7cd41d56004a473ebdb946f916d44b"

# Use wget to retrieve weather data silently. The -q flag suppresses wget progress output.
weather_data=$(wget -qO- "$WEATHER_URL")

# Use grep with a Perl regex flag to extract the temperature.
# This regex looks for an optional minus sign followed by one or more digits immediately followed by a <span tag.
temperature=$(echo "$weather_data" | grep -Po '(-?\d+(?=<span))')

# Check if temperature data was successfully extracted.
if [ -z "$temperature" ]; then
    echo "Error: Unable to fetch temperature data. Please check the URL or your network connection."
    exit 1
fi

# Display the temperature data.
echo "Current Temperature: $temperature°C"
  
