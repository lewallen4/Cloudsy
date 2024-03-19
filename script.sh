#!/bin/bash

# ASCII art for the word "weather"
echo " ______     __         ______     __  __     _____     ______     __  __    "
echo "/\  ___\   /\ \       /\  __ \   /\ \/\ \   /\  __.  /\  ___\   /\ \_\ \   "
echo "\ \ \____  \ \ \____  \ \ \/\ \  \ \ \_\ \  \ \ \/\ \ \ \___  \  \ \____ \  "
echo " \ \_____\  \ \_____\  \ \_____\  \ \_____\  \ \____-  \/\_____\  \/\_____\ "
echo "  \/_____/   \/_____/   \/_____/   \/_____/   \/____/   \/_____/   \/_____/ "
echo " "
echo " "

# Prompt user for zip code
read -p "	Enter your zip code: " zip_code

# Display entered zip code
echo "	You entered zip code: $zip_code"
echo " "
echo " "



# only using govt resources



rawcurrentlat=$(cat zipcodes/uszips.csv | grep -w "\"$zip_code\"" | awk -F',' '{gsub(/"/, "", $2); print $2}')
rawcurrentlon=$(cat zipcodes/uszips.csv | grep -w "\"$zip_code\"" | awk -F',' '{gsub(/"/, "", $3); print $3}')

adjustedlat=$(printf "%.4f" $rawcurrentlat)


adjustedlon=$(printf "%.4f" $rawcurrentlon)





# make an edit here and modify content so that if it ends in a 0, remove the 0 AFTER the decimal

# Check if the variable ends with ".0" or ".00" or any number of zeroes
# Remove trailing zeroes after the decimal point
if [[ $adjustedlat =~ \.[0-9]*0$ ]]; then
    currentlat="${adjustedlat%0}"
else currentlat="${adjustedlat}"
fi



if [[ $adjustedlon =~ \.[0-9]*0$ ]]; then
    currentlon="${adjustedlon%0}"
	else currentlon="${adjustedlon}"
fi




# Loop indefinitely
while true; do

    # Info pulling
	echo "		Generating..."
	echo "			Please wait"
	echo " "
	echo " "

    curl -s "https://api.weather.gov/points/${currentlat},${currentlon}" > db/stationlookup.json
    currentstation=$(cat "db/stationlookup.json" | grep '"radarStation"' | awk -F'"' '{print $4}')

    curl -s "https://radar.weather.gov/ridge/standard/${currentstation}_loop.gif" > db/radar.gif
	sevenday=$(cat "db/stationlookup.json" | grep '"forecast"' | awk -F'"' '{print $4}')
	curl -s "$sevenday" > db/7day.json

    
	
	

	#	You now have 3 assets
	# stationlookup
	# 7day.json
	# radar.gif
	
	currentcity=$(cat db/stationlookup.json | grep city | awk 'NR==2' | awk -F'"' '{print $4}')
    currentcondition=$(cat "db/7day.json" | grep -m 1 -A 27 '"number": 1,' | grep '"shortForecast"' | sed 's/.*: "\(.*\)".*/\1/')
	currenttemp=$(cat "db/7day.json" | grep -m 1 -A 27 '"number": 1,' | grep '"temperature"' | sed 's/.*: "\(.*\)".*/\1/' | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
	
	
	
	
	
	if grep -q "today" db/7day.json; then
    grep "today" db/7day.json
else
    grep "tonight" db/7day.json
fi

	
	
	
    
	
	hourlyURL=$(cat "db/stationlookup.json" | grep '"forecastHourly"' | awk -F'"' '{print $4}')
	
	curl -s "$hourlyURL" > db/TOD.json
	
	
	
	
	
	
	#brief description below radar
	
	
	currentcond=$(cat "db/7day.json" | grep -m 1 -A 27 '"number": 1,' | grep '"detailedForecast"' | sed 's/^.*"\([^"]*\)"[^"]*$/\1/' | awk '{for(i=1;i<=NF;i++) {printf "%s ",$i;if (i%8==0) printf "<p></p> "};print ""}'
)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

    # Write HTML content to a file
    cat <<EOF >db/frontEnd.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOAA Information</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: 'Franklin Gothic Medium', 'Arial', sans-serif;
            background-color: lightgray;
        }
        .container {
            text-align: center;
            background-color: white;
            border: 5px solid white;
            padding: 20px;
            border-radius: 10px;
        }
        img {
            max-width: 100%;
            height: auto;
        }
    </style>
</head>
<body>
    <div class="container">
		
<p><img src="logo.gif" alt="Your Logo" /></p>

        <h3>NOAA Information</h3>
        <p><strong>City Name:</strong> $currentcity</p>
        <p><strong>Condition:</strong> $currentcondition</p>
        <p><strong>Current Temp:</strong> $currenttemp°F</p>
        <p><strong>Radar Station:</strong> $currentstation</p>
        <img src="radar.gif" alt="Radar">
		<p>$currentcond</p>
    </div>
</body>
</html>
EOF


powershell -Command "Start-Process 'db/frontEnd.html' -WindowStyle Maximized"

    # Wait for 600 seconds (10 minutes) before fetching data again
	echo "  will refresh in 10 minutes..."
    sleep 600
done
