#!/bin/bash
bookmarks="./bookmark.db"
# sysinfo_page - A script to produce an HTML file
weather=$(curl -fsSL "wttr.in/Norrköping?format=4")

# COVID 19
#Total,new,death,mortality)
get_swe=$(curl -A "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0" -fsSL "https://corona-stats.online/SE?minimal=true"|grep 'Sweden')
swe_new=$(awk '{ gsub(",",""); print $5}'<<<${get_swe})
swe_total=$(awk '{ gsub(",",""); print $4}'<<<${get_swe})
swe_death=$(awk '{ gsub(",",""); print $7}'<<<${get_swe})
swe_mortality=$(awk 'BEGIN {print ('${swe_death}'*100/'${swe_total}')}'|awk -F. '{print $1"."substr($2,1,2)}')

get_ost=$(./xlsx2csv.py -a covid19.xlsx)
ost_new=$(awk -F "," '/^'$(date --date="yesterday" +%m-%d-%y)'/{print $NF; exit}' <<<${get_ost})
ost_total=$(awk -F "," '/^Östergötland/{print $2}' <<<${get_ost})
ost_death=$(awk -F "," '/^Östergötland/{print $5}' <<<${get_ost})
ost_mortality=$(awk 'BEGIN {print ('${ost_death}'*100/'${ost_total}')}'|awk -F. '{print $1"."substr($2,1,2)}')

covid19=$(
    printf "Sweden:\t\t%s☣\t%s▲\t%s☠\t%s%%\n" ${swe_total} ${swe_new} ${swe_death} ${swe_mortality}
    printf "Östergötland:\t%s☣\t%s▲\t%s☠\t%s%%\n" ${ost_total} ${ost_new} ${ost_death} ${ost_mortality}
)
# Bookmarks
mapfile -t categories < <(awk -F "," '!seen[$3] {print $3} {++seen[$3]}' "${bookmarks}")

columns=$((12 / ${#categories[@]}))
case $columns in
        0) grid='<div class="one columns">' ;;
        1) grid='<div class="one columns">' ;;
        2) grid='<div class="two columns">' ;;
        3) grid='<div class="three columns">' ;;
        4) grid='<div class="four columns card">' ;;
        5) grid='<div class="five columns">' ;;
        6) grid='<div class="six columns">' ;;
        7) grid='<div class="seven columns">' ;;
        8) grid='<div class="eight columns">' ;;
        9) grid='<div class="nine columns">' ;;
        10) grid='<div class="ten columns">' ;;
        11) grid='<div class="eleven columns">' ;;
        12) grid='<div class="twelve columns">' ;;
esac 

html_links=$(
    for category in "${categories[@]}"
    do
        mapfile -t links < <(awk -F "," '/'"${category}"'/{print $1","$2}' "${bookmarks}")
        echo -e "               ${grid}"
        echo -e "                   <h4>${category}</h4>"
        echo -e "                       <ul>"
        for link in "${links[@]}"
        do
            echo -e "                           <li><a href=""${link##*,}"">${link%",${link##*,}"}</a></li>"
        done
        echo -e "                       </ul>"
        echo -e "               </div>"
    done
)


cat <<- _EOF_
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <!-- Basic Page Needs
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <meta charset="utf-8">
        <title>TS startpage</title>
        <meta name="TS startpage" content="">
        <meta name="Tobias Svedberg" content="">

        <!-- Mobile Specific Metas
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- FONT
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <link href="//fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css">

        <!-- CSS
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/skeleton.css">

        <!-- Favicon
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <link rel="icon" type="image/png" href="images/favicon.png">
        <script>

            function startTime() {
                var today = new Date();
                var month = new Array();
                month[0] = "January";
                month[1] = "February";
                month[2] = "March";
                month[3] = "April";
                month[4] = "May";
                month[5] = "June";
                month[6] = "July";
                month[7] = "August";
                month[8] = "September";
                month[9] = "October";
                month[10] = "November";
                month[11] = "December";
                var n = month[today.getMonth()];
                var d = today.getDate();
                var h = today.getHours();
                var m = today.getMinutes();
                var s = today.getSeconds();
                m = checkTime(m);
                s = checkTime(s);
                document.getElementById('day').innerHTML =
                d;
                document.getElementById('month').innerHTML =
                n;
                document.getElementById('time').innerHTML =
                h + ":" + m + ":" + s;
                var t = setTimeout(startTime, 500);
            }

            function checkTime(i) {
                if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
                return i;
            }

        </script>
    </head>
    <body onload="startTime()">

        <!-- Primary Page Layout
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <div class="container">
            <div class="row">
                <div class="offset-by-two columns">
                    <div class="two-thirds column card" style="margin-top: 25%">
                        <h1 class="date" id="day"></h1>
                        <h4 class="date" id="month"></h4>
                        <h1 class="date" id="time"></h1>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="offset-by-two columns">
                    <div class="four columns card">
                        <h5>Weather</h5>
                        <p>${weather}</p>
                    </div>
                    <div class="four columns card">
                        <h5>COVID 19</h5>
                        <p>${covid19}</p>
                    </div>
                </div>
            </div>
            <div class="row">
${html_links}
            </div>
        </div>
        <!-- End Document
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
    </body>
    </html>

_EOF_