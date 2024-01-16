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

api_key="xxxx"

while true; do


curl -s "http://api.openweathermap.org/data/2.5/weather?zip=${zip_code}&units=imperial&appid=${api_key}" | sed 's/,/,\'$'\n/g' > weather.json






# Example: Parsing the temperature from the JSON response
# Extract temperature using grep, awk, and more






## this is the radar picture making part

# Input coordinates



input_latitude=$(cat "weather.json" | grep '"lat"' | tr -d '[:alpha:]' | awk '{gsub(/[^0-9.]/, ""); print}')
input_longitude=$(cat "weather.json" | grep '"lon"' | tr -d '[:alpha:]' | awk '{gsub(/[^0-9.]/, ""); print}')



find_closest_station() {
    local input_latitude=$1
    local input_longitude=$2

    declare -A station_coordinates=(
["KEAX"]="39.2722,-94.5661"
["KTFX"]="47.4822,-111.3825"
["KRIW"]="43.0642,-108.4597"
["KMAX"]="39.2322,-121.7833"
["KILN"]="39.4208,-83.8225"
["PGUA"]="13.4589,144.7956"
["KIWA"]="33.3078,-111.6558"
["TMIA"]="25.7839,-80.3167"
["TCMH"]="7.4622,151.8433"
["KDMX"]="41.7239,-93.7183"
["KFDR"]="34.3628,-98.9839"
["PABC"]="61.1695,-149.9982"
["KMOB"]="30.6783,-88.2431"
["KBRO"]="25.9086,-97.4175"
["KDLH"]="46.8389,-92.1806"
["KCLE"]="41.4117,-81.8497"
["KDOX"]="38.8433,-77.0372"
["KNQA"]="36.0458,-86.8864"
["TCVG"]="8.7161,167.7317"
["PAKC"]="64.3206,-158.7219"
["KGJX"]="39.0667,-106.885"
["KATX"]="48.3078,-101.4342"
["KABX"]="35.1553,-106.8236"
["KINX"]="35.2414,-91.7733"
["KEPZ"]="31.8753,-106.7003"
["KHNX"]="36.3139,-119.6292"
["KFSX"]="40.5908,-104.9508"
["KBYX"]="24.5769,-81.7069"
["KGGW"]="48.2125,-106.6233"
["KPAH"]="37.0608,-88.7739"
["KABR"]="45.4494,-98.4211"
["KAMX"]="25.6114,-80.4128"
["TTPA"]="27.7022,-82.4006"
["KHDX"]="34.7622,-92.2931"
["KLOT"]="41.6031,-88.0847"
["KTBW"]="27.6997,-82.4075"
["KSFX"]="44.4281,-89.6667"
["KVAX"]="30.8967,-83.0028"
["KLZK"]="34.8356,-92.2594"
["KLIX"]="30.3383,-89.8208"
["KRLX"]="38.4811,-81.0769"
["KLSX"]="38.6353,-90.3794"
["KJKL"]="37.5942,-83.3136"
["KBIS"]="46.7747,-100.7606"
["KFFC"]="33.3642,-84.5661"
["KMSX"]="46.9739,-120.5394"
["KCBX"]="40.6997,-124.2361"
["KDDC"]="37.7628,-99.9667"
["KFDX"]="34.6414,-99.3342"
["KMLB"]="28.1033,-80.6453"
["KDYX"]="32.5408,-99.7289"
["KVNX"]="36.7403,-97.9122"
["KTLH"]="30.3983,-84.3456"
["PACG"]="56.8503,-135.5247"
["KDIX"]="40.0128,-74.5917"
["KGLD"]="39.3664,-101.6944"
["KPDT"]="45.6989,-118.8414"
["KCYS"]="41.1558,-104.8064"
["PAEC"]="58.1889,-152.1144"
["KJGX"]="31.8508,-81.6003"
["KMHX"]="35.6372,-75.9369"
["KMXX"]="37.1603,-100.7283"
["KGRK"]="30.7153,-97.3844"
["KHTX"]="35.1772,-111.6664"
["KEMX"]="31.9503,-110.4569"
["KBBX"]="31.9833,-99.2661"
["KCCX"]="40.1803,-80.6656"
["KRTX"]="34.0669,-88.7808"
["PHWA"]="19.7236,-155.0869"
["KSOX"]="34.2667,-119.2075"
["KARX"]="43.8283,-91.1911"
["KGYX"]="43.8914,-70.2569"
["TPBI"]="26.5192,-80.0914"
["KBLX"]="32.6119,-114.6572"
["KBHX"]="32.5156,-94.7528"
["KMTX"]="45.6475,-111.6761"
["KSHV"]="32.4539,-93.8428"
["KICX"]="38.3369,-98.8581"
["KTWX"]="35.3181,-97.4222"
["KVWX"]="33.085,-83.2358"
["KVBX"]="34.7336,-120.5839"
["KFTG"]="39.7803,-104.5292"
["PAHG"]="60.9672,-149.125"
["KLWX"]="38.9936,-77.4878"
["KVTX"]="34.5131,-112.4678"
["KMAF"]="31.9369,-102.1886"
["KLTX"]="33.9867,-78.4292"
["KUEX"]="43.4297,-112.0711"
["KIWX"]="41.4481,-85.7031"
["KEYX"]="31.4383,-87.9883"
["KGWX"]="33.4944,-88.5917"
["KYUX"]="40.2208,-110.0328"
["KSRX"]="32.5167,-94.7333"
["KSJT"]="31.3711,-100.4964"
["KEWX"]="29.6981,-98.1172"
["KEVX"]="30.5336,-87.9389"
["KCBW"]="39.2722,-80.2286"
["KDGX"]="30.6889,-88.0564"
["KBUF"]="42.9403,-78.7356"
["KMPX"]="44.8544,-93.5639"
["KFSD"]="43.5833,-96.7333"
["KPUX"]="38.4678,-104.1739"
["KMUX"]="37.2358,-121.8611"
["RKSG"]="35.1236,128.9464"
["KICT"]="37.6481,-97.4331"
["PHKI"]="20.1272,-155.7856"
["RKJK"]="35.9089,126.6156"
["KTYX"]="46.4308,-120.3136"
["KBMX"]="33.1747,-86.7722"
["TRDU"]="35.8825,-78.7897"
["KOAX"]="41.3219,-96.3664"
["KOTX"]="47.6847,-117.6269"
["KJAX"]="30.4836,-81.7003"
["KEOX"]="31.3589,-85.4494"
["KENX"]="42.5861,-74.0642"
["KDVN"]="41.6114,-90.5808"
["KFWS"]="32.5681,-97.3033"
["KAPX"]="44.9139,-84.715"
["KGRB"]="44.4881,-88.1106"
["KLGX"]="32.6164,-93.2194"
["KAMA"]="35.2375,-101.7117"
["KBGM"]="42.2083,-75.9828"
["KLBB"]="33.6547,-101.8142"
["KLVX"]="37.9353,-85.9489"
["KNKX"]="32.0906,-81.0806"
["KGSP"]="34.8725,-82.2178"
["KCXX"]="36.3969,-97.3428"
["KRAX"]="35.8294,-78.675"
["KMBX"]="48.3931,-100.8711"
["KHPX"]="34.3636,-89.5308"
["KLNX"]="41.9586,-100.5814"
["KCAE"]="33.9381,-81.1183"
["KGRR"]="42.8931,-85.5442"
["KILX"]="40.15,-89.3369"
["KRGX"]="29.9953,-99.0983"
["KLCH"]="30.1214,-93.2164"
["KPBZ"]="40.5317,-80.2186"
["PAIH"]="59.4422,-146.3133"
["KDAX"]="37.1211,-118.2792"
["TPIT"]="40.5581,-80.4106"
["PHMO"]="20.0014,-155.6683"
["KAKQ"]="37.2533,-76.3558"
["KBOX"]="42.2344,-71.0033"
["KUDX"]="37.1747,-101.7242"
["KTLX"]="35.3356,-97.2761"
["PAPD"]="59.9731,-147.6219"
["KOHX"]="36.2472,-86.5625"
["KFCX"]="38.5708,-78.15"
["KCLX"]="41.0383,-95.9797"
["KDFX"]="37.7631,-103.9589"
["KCRP"]="27.7847,-97.5125"
["KPOE"]="31.1558,-92.9756"
["KOKX"]="40.8558,-72.8642"
["KHGX"]="29.4719,-95.0783"
["KMRX"]="35.9636,-83.8733"
["KIND"]="39.7075,-86.2781"
["KESX"]="29.6667,-95.1583"
["PHKM"]="19.7358,-156.0417"
["KSGF"]="37.2458,-93.3886"
["KMQT"]="46.5306,-87.5603"
["TICH"]="35.1831,-94.2275"
["KLRX"]="29.5394,-95.0836"
["KDTX"]="42.6644,-83.4181"
["KMKX"]="42.965,-88.2394"
["KMVX"]="44.6603,-90.6578"
        # Add more station coordinates as needed
    )

    local closest_station=""
    local min_distance=999999999

    for station in "${!station_coordinates[@]}"; do
        coordinates="${station_coordinates[$station]}"
        station_latitude=$(echo "$coordinates" | cut -d',' -f1)
        station_longitude=$(echo "$coordinates" | cut -d',' -f2)

        # Calculate squared distance using awk
        distance_squared=$(awk -v ilat="$input_latitude" -v ilon="$input_longitude" -v slat="$station_latitude" -v slon="$station_longitude" 'BEGIN { print ( ilat - slat )^2 + ( ilon - slon )^2 }')

        # Compare distances using awk
        if [ $(awk -v dsq="$distance_squared" -v min="$min_distance" 'BEGIN { print (dsq < min) }') -eq 1 ]; then
            min_distance=$distance_squared
            closest_station=$station
        fi
    done
echo "$closest_station"
}

# Call the function here
closest_station=$(find_closest_station $input_latitude $input_longitude)

## link maybe?

echo "Found closest stations at $closest_station"

curl -o radar.gif "https://radar.weather.gov/ridge/standard/${closest_station}_0.gif"



























echo "City Name:"
currentcity=$(cat "weather.json" | grep '"name"' | awk -F'"' '{print $4}')
echo "$currentcity"


echo


echo "Condition:"
currentcondition=$(cat "weather.json" | grep -m 1 '"main"' | awk -F'"' '{print $4}')
echo "$currentcondition"


echo


echo "Current Temp:"
currenttemp=$(cat "weather.json" | grep '"temp"' | tr -d '[:alpha:]' | awk '{gsub(/[^0-9.]/, ""); print}')
echo "$currenttemp°F"



    sleep 600
done