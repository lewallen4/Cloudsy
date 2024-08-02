#!/bin/bash

# ASCII art for the word "weather"
echo " ______     __         ______     __  __     ____    ______     __  __    "
echo "/\  ___\   /\ \       /\  __ \   /\ \/\ \   | |  \  /\  ___\   /\ \_\ \   "
echo "\ \ \____  \ \ \____  \ \ \/\ \  \ \ \_\ \  | | . \ \ \___  \  \ \____ \  "
echo " \ \_____\  \ \_____\  \ \_____\  \ \_____\ | |___/  \/\_____\  \/\_____\ "
echo "  \/_____/   \/_____/   \/_____/   \/_____/ |/___/    \/_____/   \/_____/ "
echo " "
echo " "

# prompt user for zip code
read -p "	Enter your zip code: " zip_code

# sanitize and extract only the first 5 digits from the zip code
zip_code=${zip_code//[^0-9]/}   # Remove all non-digit characters
zip_code=${zip_code:0:5}         # Extract the first 5 digits

# display entered zip code
echo "	You entered zip code: $zip_code"
echo " "
echo " "

# extract latitude and longitude from zip_code
rawcurrentlat=$(cat zipcodes/uszips.csv | grep -w "\"$zip_code\"" | awk -F',' '{gsub(/"/, "", $2); print $2}')
rawcurrentlon=$(cat zipcodes/uszips.csv | grep -w "\"$zip_code\"" | awk -F',' '{gsub(/"/, "", $3); print $3}')
adjustedlat=$(printf "%.4f" $rawcurrentlat)
adjustedlon=$(printf "%.4f" $rawcurrentlon)

# check if the variable ends with ".0" or ".00" or any number of zeroes
# remove trailing zeroes after the decimal point
if [[ $adjustedlat =~ \.[0-9]*0$ ]]; then
    currentlat="${adjustedlat%0}"
	else currentlat="${adjustedlat}"
fi

if [[ $adjustedlon =~ \.[0-9]*0$ ]]; then
    currentlon="${adjustedlon%0}"
	else currentlon="${adjustedlon}"
fi

# check if the system is running Linux or windows
if [ "$(uname)" == "Linux" ]; then
    osVer="linux"
	elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
		osVer="windows"
	elif [ "$(expr substr $(uname -s) 1 9)" == "CYGWIN_NT" ]; then
		osVer="windows"
	else
		osVer="windows"
fi

mkdir -p "db/weekly"

# the error zone : fun stuff
Error_time() {
    random_number=$((RANDOM % 2))  # Generate a random number between 0 and 1
    case $random_number in
        0)
            echo " error pulling data from NOAA
 █     █░ ██░ ██  ▒█████   ▒█████   ██▓███    ██████                            
▓█░ █ ░█░▓██░ ██▒▒██▒  ██▒▒██▒  ██▒▓██░  ██▒▒██    ▒                            
▒█░ █ ░█ ▒██▀▀██░▒██░  ██▒▒██░  ██▒▓██░ ██▓▒░ ▓██▄                              
░█░ █ ░█ ░▓█ ░██ ▒██   ██░▒██   ██░▒██▄█▓▒ ▒  ▒   ██▒                           
░░██▒██▓ ░▓█▒░██▓░ ████▓▒░░ ████▓▒░▒██▒ ░  ░▒██████▒▒ ██▓                       
░ ▓░▒ ▒   ▒ ░░▒░▒░ ▒░▒░▒░ ░ ▒░▒░▒░ ▒█▓▒ ░  ░▒ ▒▓▒ ▒ ░ ▒▓▒                       
  ▒ ░ ░   ▒ ░▒░ ░  ░ ▒ ▒░   ░ ▒ ▒░ ▒▓▒░ ░   ░ ░▒  ░ ░ ░▒                        
  ░   ░   ░  ░░ ░░ ░ ░ ▒  ░ ░ ░ ▒  ░▒ ░     ░  ░  ░   ░                         
    ░     ░  ░  ░    ░ ░      ░ ░  ░░             ░    ░                        
 ███▄    █  ▒█████      █     █░▓█████ ▄▄▄     ▄▄▄█████▓ ██░ ██ ▓█████  ██▀███  
 ██ ▀█   █ ▒██▒  ██▒   ▓█░ █ ░█░▓█   ▀▒████▄   ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀ ▓██ ▒ ██▒
▓██  ▀█ ██▒▒██░  ██▒   ▒█░ █ ░█ ▒███  ▒██  ▀█▄ ▒ ▓██░ ▒░▒██▀▀██░▒███   ▓██ ░▄█ ▒
▓██▒  ▐▌██▒▒██   ██░   ░█░ █ ░█ ▒▓█  ▄░██▄▄▄▄██░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄ ▒██▀▀█▄  
▒██░   ▓██░░ ████▓▒░   ░░██▒██▓ ░▒████▒▓█   ▓██▒ ▒██▒ ░ ░▓█▒░██▓░▒████▒░██▓ ▒██▒
░ ▒░   ▒ ▒ ░ ▒░▒░▒░    ░ ▓░▒ ▒  ░░ ▒░ ░▒▒   ▓▒█░ ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░░ ▒▓ ░▒▓░
░ ░░   ░ ▒░  ░ ▒ ▒░      ▒ ░ ░   ░ ░  ░ ▒   ▒▒ ░   ░     ▒ ░▒░ ░ ░ ░  ░  ░▒ ░ ▒░
   ░   ░ ░ ░ ░ ░ ▒       ░   ░     ░    ░   ▒    ░       ░  ░░ ░   ░     ░░   ░ 
       ░   an  ░ ░  error  ░   has ░  ░     ░  ░ occurred░  ░  ░   ░  ░   ░     " && echo "error pulling data from NOAA" > 'db/frontEnd.html'
	
            ;;
        1)
            echo " error pulling data from NOAA
 _____                                            _____ 
( ___ )                                          ( ___ )
 |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   | 
 |   |                                            |   | 
 |   |   w e l l     t h a t s     b a d          |   | 
 |   |                                            |   | 
 |   |         the   weather   broke              |   | 
 |   |                                            |   | 
 |   |                 either   theres            |   | 
 |   |                                            |   | 
 |   |   C O N N E C T I O N   P R O B L E M S    |   | 
 |   |                                            |   | 
 |   |                    or                      |   | 
 |   |                                            |   | 
 |   |     s o m e o n e   d e s t r o y e d      |   | 
 |   |                                            |   | 
 |   |   T H E   W E A T H E R   S E R V I C E    |   | 
 |   |                                            |   | 
 |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___| 
(_____)      error fetching data                 (_____)" && echo "error pulling data from NOAA" > 'db/frontEnd.html'
            ;;
        *)
            echo "Unknown error" && echo "error pulling data from NOAA" > 'db/frontEnd.html'
            ;;
    esac
}

# the loading screen
cat <<EOF >db/frontEnd.html
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>Loading...</title>
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
				overflow: auto;
			}
			img {
				max-width: 100%;
				max-height: 100%;
				margin-bottom: 20px;
			}
			.left-content {
				display: inline-block;
				text-align: left;
				vertical-align: top; /* Align content at the top */
				width: 45%; /* Adjust the width as needed */
				margin-right: 5%; /* Add some margin between the left and right content */
			}
			.table-container {
				display: inline-block;
				text-align: center;
				width: 45%; /* Adjust the width as needed */
			}
			table {
				width: 100%;
				border-collapse: collapse;
				overflow: hidden;
				box-shadow: 0 0 20px rgba(0,0,0,0.1);
				margin: 0 auto;
				background: linear-gradient(45deg, #e4b5d9, #abd4f2);
			}
			th,
			td {
				padding: 10px;
				background-color: rgba(255,255,255,0.2);
				color: #000;
			}
			th {
				text-align: left;
				background-color: rgba(255,255,255,0.6);
				background: linear-gradient(45deg, #e4b5d9, #abd4f2);
			}
			thead th {
				background-color: #55608f;
			}
			tbody tr:hover {
				background-color: rgba(255,255,255,0.3);
			}
			td {
				position: relative;
			}
			td:hover:before {
				content: "";
				position: absolute;
				left: 0;
				right: 0;
				top: -9999px;
				bottom: -9999px;
				background-color: rgba(255,255,255,0.2);
				z-index: -1;
			}
		</style>
	</head>
	<body>
		<div class="container">
			<p><img src="loading.gif" alt="Loading, please wait"></p>
		</div>
		<!-- JavaScript to refresh the page every 10 minutes -->
		<script>
			setTimeout(function(){
				location.reload();
			}, 6000); // Refresh every 10 minutes (600,000 milliseconds)
		</script>
	</body>
</html>


EOF

# open the loading screen on different OS
html_file="db/frontEnd.html"
	if [ $osVer == "linux" ]; then
		xdg-open "$html_file"
	fi
	
	if [ $osVer == "windows" ]; then
		powershell -Command "Start-Process -FilePath 'db/frontEnd.html' -WindowStyle Normal"
	fi

# main loop indefinitely
while true; do

    # info pulling
	echo "		Generating..."
	echo "			Please wait"
	echo " "
	echo " "

    curl -s "https://api.weather.gov/points/${currentlat},${currentlon}" > db/stationlookup.json
		currentstation=$(cat "db/stationlookup.json" | grep '"radarStation"' | awk -F'"' '{print $4}')
		errorcheck=$(cat db/stationlookup.json | grep fireWeather)
	
	if [ -z "${errorcheck}" ]; then
		Error_time
		exit
	fi

    curl -s "https://radar.weather.gov/ridge/standard/${currentstation}_loop.gif" > db/radar.gif
	curl -s "https://api.weather.gov/alerts?point=${currentlat},${currentlon}" > db/alerts.json
		currentzone=$(grep forecastZone db/stationlookup.json | awk -F '"' '{print $4}' | awk -F '/' '{print $6}')
		alert1=$(grep "/$currentzone" db/alerts.json)
	tac db/alerts.json | grep -A 1000 "$alert" | grep '"headline"' > db/activealerts.json
		sevenday=$(cat "db/stationlookup.json" | grep '"forecast"' | awk -F'"' '{print $4}')
	curl -s "$sevenday" > db/7day.json
#	dev notes: you now have 3 assets
# 	stationlookup
# 	7day.json
# 	radar.gif
		currentcity=$(cat db/stationlookup.json | grep city | awk 'NR==2' | awk -F'"' '{print $4}')
		currentcondition=$(cat "db/7day.json" | grep -m 1 -A 27 '"number": 1,' | grep '"shortForecast"' | sed 's/.*: "\(.*\)".*/\1/')
		currenttemp=$(cat "db/7day.json" | grep -m 1 -A 27 '"number": 1,' | grep '"temperature"' | sed 's/.*: "\(.*\)".*/\1/' | sed 's/[^0-9]*\([0-9]\+\).*/\1/' | head -n 1)
		hourlyURL=$(cat "db/stationlookup.json" | grep '"forecastHourly"' | awk -F'"' '{print $4}')
		currentcond=$(cat "db/7day.json" | grep -m 1 -A 27 '"number": 1,' | grep '"detailedForecast"' | awk -F '"' '{print $4}')	

# unused but it works	
	if grep -q "today" db/7day.json; then
		grep "today" db/7day.json
		else
		grep "tonight" db/7day.json
	fi
	
	curl -s "$hourlyURL" > db/TOD.json
	
	# hourly
		hourRawTime1a=$(cat "db/TOD.json" | grep -m 1 startTime | awk -F '[:-T]' '{print $4}')
		hourRawTime2a=$(cat "db/TOD.json" | grep -m 2 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime3a=$(cat "db/TOD.json" | grep -m 3 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime4a=$(cat "db/TOD.json" | grep -m 4 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime5a=$(cat "db/TOD.json" | grep -m 5 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime6a=$(cat "db/TOD.json" | grep -m 6 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime7a=$(cat "db/TOD.json" | grep -m 7 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime8a=$(cat "db/TOD.json" | grep -m 8 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime9a=$(cat "db/TOD.json" | grep -m 9 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime10a=$(cat "db/TOD.json" | grep -m 10 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime11a=$(cat "db/TOD.json" | grep -m 11 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime12a=$(cat "db/TOD.json" | grep -m 12 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime13a=$(cat "db/TOD.json" | grep -m 13 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime14a=$(cat "db/TOD.json" | grep -m 14 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime15a=$(cat "db/TOD.json" | grep -m 15 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime16a=$(cat "db/TOD.json" | grep -m 16 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime17a=$(cat "db/TOD.json" | grep -m 17 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime18a=$(cat "db/TOD.json" | grep -m 18 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime19a=$(cat "db/TOD.json" | grep -m 19 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime20a=$(cat "db/TOD.json" | grep -m 20 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime21a=$(cat "db/TOD.json" | grep -m 21 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime22a=$(cat "db/TOD.json" | grep -m 22 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime23a=$(cat "db/TOD.json" | grep -m 23 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime24a=$(cat "db/TOD.json" | grep -m 24 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)
		hourRawTime25a=$(cat "db/TOD.json" | grep -m 25 startTime | awk -F '[:-T]' '{print $4}' | tail -n 1)

	for i in {1..25}; do
		eval hourTemp${i}a=$(cat 'db/TOD.json' | grep -m $i '"temperature":' | awk -F '[:]' '{print $2}' | awk -F ',' '{print $1}' | awk -F '[ ]' '{print $2}' | tail -n 1)
	done

	for i in {1..25}; do
		eval hourRain${i}a=$(cat 'db/TOD.json' | grep -m $i -A 2 '"probabilityOfPrecipitation' | awk -F '[:]' '{print $2}' | awk -F ',' '{print $1}' | awk -F '[ ]' '{print $2}' | tail -n 1)
	done

	convert_to_12_hour_format() {
		local hour=$1

    # remove leading zeros if present
		hour=${hour#0}

		if (( hour > 12 )); then
			hour=$((hour - 12))
			suffix="pm"
			else
			suffix="am"
		fi

		echo "$hour:00$suffix"
	}

	# generate Times
		hour=$hourRawTime1a
			hourTime1=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime2a
			hourTime2=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime3a
			hourTime3=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime4a
			hourTime4=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime5a
			hourTime5=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime6a
			hourTime6=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime7a
			hourTime7=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime8a
			hourTime8=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime9a
			hourTime9=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime10a
			hourTime10=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime11a
			hourTime11=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime12a
			hourTime12=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime13a
			hourTime13=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime14a
			hourTime14=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime15a
			hourTime15=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime16a
			hourTime16=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime17a
			hourTime17=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime18a
			hourTime18=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime19a
			hourTime19=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime20a
			hourTime20=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime21a
			hourTime21=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime22a
			hourTime22=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime23a
			hourTime23=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime24a
			hourTime24=$(convert_to_12_hour_format "$hour")
		hour=$hourRawTime25a
			hourTime25=$(convert_to_12_hour_format "$hour")

	# 7 day forecast staging
	# convert to american
	weeklyDate1=$(cat db/7day.json | grep generatedAt | awk -F '"' '{print $4}' | awk -F ':' '{print $1}' | awk -F 'T' '{print $1}' | awk -F '-' '{print $1}')
	weeklyDate2=$(cat db/7day.json | grep generatedAt | awk -F '"' '{print $4}' | awk -F ':' '{print $1}' | awk -F 'T' '{print $1}' | awk -F '-' '{print $2}')
	weeklyDate3=$(cat db/7day.json | grep generatedAt | awk -F '"' '{print $4}' | awk -F ':' '{print $1}' | awk -F 'T' '{print $1}' | awk -F '-' '{print $3}')
	weeklyDateFinal=$(echo $weeklyDate2-$weeklyDate3-$weeklyDate1)

	# weekly section / orobas loop
	awk '{printf "%s", $0}' "db/7day.json" > db/weekly/long.txt
	counter=100
	for ((i=1; i<=14; i++)); do
		((counter++))
		cat 'db/weekly/long.txt' | awk -F 'number' -v var="$i" '{print $var}' | awk '{ gsub(/,/, ",\n"); print }' > "db/weekly/$counter.txt"
	done
	directory="db/weekly"
	rm db/weekly/101.txt
	for file in "$directory"/*; do
		if grep -q "night" "$file"; then
			rm "$file"
		fi
	done
	for file in "$directory"/*; do
		if grep -q "Today" "$file"; then
			rm "$file"
		fi
	done
	for file in "$directory"/*; do
		if grep -q "name.*This\|This.*name" "$file"; then
			rm "$file"
		fi
	done
	# initialize counter
	counter=0
	for file in "$directory"/*; do
		((counter++))
		content=$(grep -i "name" "$file" | awk -F '"' '{print $4}')
		declare "weeklyName$counter=$content"
	done
	for ((i = 1; i <= counter; i++)); do
		var="weeklyName$i"
	done
	counter=0
	for file in "$directory"/*; do
		((counter++))
		content=$(grep -i "shortForecast" "$file" | awk -F '"' '{print $4}')
		declare "weeklyShort$counter=$content"
	done
	for ((i = 1; i <= counter; i++)); do
		var="weeklyShort$i"
	done
	counter=0
	for file in "$directory"/*; do
		((counter++))
		content=$(grep -A 10 -i "detailedForecast" "$file" | sed ':a;N;$!ba;s/\n//g' | awk -F '"' '{print $4}')
		declare "weeklyLong$counter=$content"
	done
	for ((i = 1; i <= counter; i++)); do
		var="weeklyLong$i"
	done
	counter=0
	for file in "$directory"/*; do
		((counter++))
    	content=$(grep -i '"temperature"' "$file" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'| awk -F ',' '{print $1}')
        declare "weeklyTemp$counter=$content"
	done
	for ((i = 1; i <= counter; i++)); do
		var="weeklyTemp$i"
	done

# write HTML content to a file
    cat <<EOF >db/frontEndraw.html
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Cloudsy</title>
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
				background-color: white;
				border: 5px solid white;
				padding: 20px;
				border-radius: 10px;
				overflow: auto;
				display: flex;
				flex-direction: row;
				justify-content: space-between;
			}
			.third {
				width: 33%;
			}
			img {
				max-width: 100%;
				max-height: 100%;
				margin-bottom: 20px;
			}
			.left-content {
				display: inline-block;
				text-align: center;
				vertical-align: top; /* Align content at the top */
				width: 40%; /* Adjust the width as needed */
				margin-right: 3%; /* Add some margin between the left and right content */
				margin-left: 3%; /* Add some margin between the left and right content */
			}
			.table-container {
				text-align: center;
			}
			table {
				width: 100%;
				border-collapse: collapse;
				overflow: hidden;
				box-shadow: 0 0 20px rgba(0,0,0,0.1);
				margin: 0 auto;
				background: linear-gradient(45deg, #e4b5d9, #abd4f2);
			}
			th,
			td {
				padding: 10px;
				background-color: rgba(255,255,255,0.2);
				color: #000;
			}
			th {
				text-align: left;
				background-color: rgba(255,255,255,0.6);
				background: linear-gradient(45deg, #e4b5d9, #abd4f2);
			}
			thead th {
				background-color: #55608f;
			}
			tbody tr:hover {
				background-color: rgba(255,255,255,0.3);
			}
			td {
				position: relative;
			}
			td:hover:before {
				content: "";
				position: absolute;
				left: 0;
				right: 0;
				top: -9999px;
				bottom: -9999px;
				background-color: rgba(255,255,255,0.2);
				z-index: -1;
			}
		</style>
	</head>
	<body>
		<div class="container">
		<div class="table-container third">
			<h2>Weekly Forecast</h2>
			<table border="1" style="width: 400px;">
				<tr>
					<th>$weeklyName1</th>
					<th style="text-align: right; font-weight: normal;">$weeklyTemp1°F</th>
				</tr>
				<tr style="height:100px">
					<td colspan="2" style="text-align: left;">$weeklyLong1</td>
				</tr>
				<tr>
					<th>$weeklyName2</th>
					<th style="text-align: right; font-weight: normal;">$weeklyTemp2°F</th>
				</tr>
				<tr style="height:100px">
					<td colspan="2" style="text-align: left;">$weeklyLong2</td>
				</tr>
				<tr>
					<th>$weeklyName3</th>
					<th style="text-align: right; font-weight: normal;">$weeklyTemp3°F</th>
				</tr>
				<tr style="height:100px">
					<td colspan="2" style="text-align: left;">$weeklyLong3</td>
				</tr>
				<tr>
					<th>$weeklyName4</th>
					<th style="text-align: right; font-weight: normal;">$weeklyTemp4°F</th>
				</tr>
				<tr style="height:100px">
					<td colspan="2" style="text-align: left;">$weeklyLong4</td>
				</tr>
				<tr>
					<th>$weeklyName5</th>
					<th style="text-align: right; font-weight: normal;">$weeklyTemp5°F</th>
				</tr>
				<tr style="height:100px">
					<td colspan="2" style="text-align: left;">$weeklyLong5</td>
				</tr>
				<tr>
					<th>$weeklyName6</th>
					<th style="text-align: right; font-weight: normal;">$weeklyTemp6°F</th>
				</tr>
				<tr style="height:100px">
					<td colspan="2" style="text-align: left;">$weeklyLong6</td>
				</tr>
			</table>
		</div>
		<div class="left-content third">
			<p><img src="logo.gif" alt="--Cloudsy--"></p>
			<h3><center>NOAA Information</center></h3>
			<p><strong><center>City Name:</strong> $currentcity</center></p>
			<p><strong><center>Condition:</strong> $currentcondition</center></p>
			<p><strong><center>Current Temp:</strong> $currenttemp°F</center></p>
			<p><strong><center>Radar Station:</strong> $currentstation</center></p>
			<img src="radar.gif" alt="Radar Image Unavailable">
			<p style="max-width: 400px; margin: 0 auto; text-align: center;">$currentcond</center></p>
		</div>
		<div class="table-container third">
			<h2>Hourly Forecast</h2>
			<table border="1">
				<tr>
					<th>Local Time</th>
					<th>Temperature</th>
					<th>Change of Rain</th>
				</tr>
				<tr>
					<td>$hourTime1</td>
					<td>$hourTemp1a°F</td>
					<td>$hourRain1a%</td>
				</tr>
				<tr>
					<td>$hourTime2</td>
					<td>$hourTemp2a°F</td>
					<td>$hourRain2a%</td>
				</tr>
				<tr>
					<td>$hourTime3</td>
					<td>$hourTemp3a°F</td>
					<td>$hourRain3a%</td>
				</tr>
				<tr>
					<td>$hourTime4</td>
					<td>$hourTemp4a°F</td>
					<td>$hourRain4a%</td>
				</tr>
				<tr>
					<td>$hourTime5</td>
					<td>$hourTemp5a°F</td>
					<td>$hourRain5a%</td>
				</tr>
                <tr>
					<td>$hourTime6</td>
					<td>$hourTemp6a°F</td>
					<td>$hourRain6a%</td>
				</tr>
                <tr>
					<td>$hourTime7</td>
					<td>$hourTemp7a°F</td>
					<td>$hourRain7a%</td>
				</tr>
                <tr>
					<td>$hourTime8</td>
					<td>$hourTemp8a°F</td>
					<td>$hourRain8a%</td>
				</tr>
                <tr>
					<td>$hourTime9</td>
					<td>$hourTemp9a°F</td>
					<td>$hourRain9a%</td>
				</tr>
                <tr>
					<td>$hourTime10</td>
					<td>$hourTemp10a°F</td>
					<td>$hourRain10a%</td>
				</tr>
                <tr>
					<td>$hourTime11</td>
					<td>$hourTemp11a°F</td>
					<td>$hourRain11a%</td>
				</tr>
                <tr>
					<td>$hourTime12</td>
					<td>$hourTemp12a°F</td>
					<td>$hourRain12a%</td>
				</tr>
                <tr>
					<td>$hourTime13</td>
					<td>$hourTemp13a°F</td>
					<td>$hourRain13a%</td>
				</tr>
                <tr>
					<td>$hourTime14</td>
					<td>$hourTemp14a°F</td>
					<td>$hourRain14a%</td>
				</tr>
                <tr>
					<td>$hourTime15</td>
					<td>$hourTemp15a°F</td>
					<td>$hourRain15a%</td>
				</tr>
                <tr>
					<td>$hourTime16</td>
					<td>$hourTemp16a°F</td>
					<td>$hourRain16a%</td>
				</tr>
                <tr>
					<td>$hourTime17</td>
					<td>$hourTemp17a°F</td>
					<td>$hourRain17a%</td>
				</tr>
                <tr>
					<td>$hourTime18</td>
					<td>$hourTemp18a°F</td>
					<td>$hourRain18a%</td>
				</tr>
                <tr>
					<td>$hourTime19</td>
					<td>$hourTemp19a°F</td>
					<td>$hourRain19a%</td>
				</tr>
                <tr>
					<td>$hourTime20</td>
					<td>$hourTemp20a°F</td>
					<td>$hourRain20a%</td>
				</tr>
                <tr>
					<td>$hourTime21</td>
					<td>$hourTemp21a°F</td>
					<td>$hourRain21a%</td>
				</tr>
                <tr>
					<td>$hourTime22</td>
					<td>$hourTemp22a°F</td>
					<td>$hourRain22a%</td>
				</tr>
                <tr>
					<td>$hourTime23</td>
					<td>$hourTemp23a°F</td>
					<td>$hourRain23a%</td>
				</tr>
                <tr>
					<td>$hourTime24</td>
					<td>$hourTemp24a°F</td>
					<td>$hourRain24a%</td>
				</tr>
                <tr>
					<td>$hourTime25</td>
					<td>$hourTemp25a°F</td>
					<td>$hourRain25a%</td>
				</tr>
			</table>
		</div>
	</div>
<!-- JavaScript to refresh the page every 10 minutes -->
	<script>
		setTimeout(function(){
			location.reload();
		}, 610000); // Refresh every 10 minutes (600,000 milliseconds)
	</script>
</body>
</html>


EOF

	# fix the words
	awk '{if (gsub("Cloudy", "Cloudsy")) print; else print $0}' db/frontEndraw.html > db/frontEnd1.html
	awk '{if (gsub("cloudy", "cloudsy")) print; else print $0}' db/frontEnd1.html > db/frontEnd.html

	# cleanup
	rm db/frontEndraw.html
	rm db/frontEnd1.html

	# wait for 600 seconds (10 minutes) before fetching data again
	echo "  will refresh in 10 minutes..."
    sleep 600
done