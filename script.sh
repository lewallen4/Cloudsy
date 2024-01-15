#!/bin/bash

# ASCII art for the word "weather"
echo "  _        _       _       _        _       _       _ "
echo " / \      / \     / \     / \      / \     / \     / \ "
echo "( w )====( e )===( a )===( t )====( h )===( e )===( r ) "
echo " \_/      \_/     \_/     \_/      \_/     \_/     \_/ "

# Prompt user for zip code
read -p "Enter your zip code: " zip_code

# Display entered zip code
echo "You entered zip code: $zip_code"

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "

api_key="66cc9deb148033ca283b96ed93faff1c"

while true; do


curl -s "http://api.openweathermap.org/data/2.5/weather?zip=${zip_code}&units=imperial&appid=${api_key}" | sed 's/,/,\'$'\n/g' > weather.json






# Example: Parsing the temperature from the JSON response
# Extract temperature using grep and awk

clear

echo "Current Temp:"
$currenttemp cat "weather.json" | grep '"temp"' | tr -d '[:alpha:]' | awk '{gsub(/[^0-9.]/, ""); print}' && echo "°F"



    sleep 10
done

