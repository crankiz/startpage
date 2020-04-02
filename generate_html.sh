#!/bin/bash
bookmarks="./bookmark.db"
# sysinfo_page - A script to produce an HTML file
categories=($(awk -F "," '!seen[$3] {print $3} {++seen[$3]}' "${bookmarks}"))

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
    for category in ${categories[@]}
    do
        links=($(awk -F "," '/'${category}'/{print $1","$2}' "${bookmarks}"))
        echo -e "${grid}"
        echo -e "<h4>${category}</h4>"
        echo -e "<ul>"
        for link in ${links[@]}
        do
            echo -e "<li><a href="${link##*,}">${link%",${link##*,}"}</a></li>"
        done
        echo -e "</ul>"
        echo -e "</div>"
    done
)


cat <<- _EOF_
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <!-- Basic Page Needs
        –––––––––––––––––––––––––––––––––––––––––––––––––– -->
        <meta charset="utf-8">
        <title>Your page title here :)</title>
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
                <div class="two-thirds column" style="margin-top: 25%">
                    <h1 class="date" id="day"></h1>
                    <h4 class="date" id="month"></h4>
                    <h1 class="date" id="time"></h1>
                </div>
            </div>
            <div class="row">
                <div class="twelve.columns">
                    <h6>
                    4,947☣ 512▲ 239☠ 59♻
                    </h6>
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