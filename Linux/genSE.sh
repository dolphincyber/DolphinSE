time=$(date +"%r")
linecount=$(cat conf.sh | wc -l)
totalVulns=$(( $linecount - 10))
Vulns=$(cat assets/previous.txt)
points=$(expr $Vulns \* 5)
i=1
echo "<!DOCTYPE html> <html> <head> <meta http-equiv='refresh' content='60'> <title>DolphinSE Scoring Report</title> <style type='text/css'> h1 { text-align: center; } h2 { text-align: center; } body { font-family: Arial, Verdana, sans-serif; font-size: 14px; margin: 0; padding: 0; width: 100%; height: 100%; background: url('./img/background.png'); background-size: cover; background-attachment: fixed; background-position: top center; background-color: #336699; } .red {color: red;} .green {color: green;} .blue {color: blue;} .main { margin-top: 10px; margin-bottom: 10px; margin-left: auto; margin-right: auto; padding: 0px; border-radius: 12px; background-color: white; width: 900px; max-width: 100%; min-width: 600px; box-shadow: 0px 0px 12px #003366; } .text { padding: 12px; -webkit-touch-callout: none; -webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; } .center { text-align: center; } .binary { position: relative; overflow: hidden; } .binary::before { position: absolute; top: -1000px; left: -1000px; display: block; width: 500%; height: 300%; -webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); transform: rotate(-45deg); content: attr(data-binary); opacity: 0.15; line-height: 2em; letter-spacing: 2px; color: #369; font-size: 10px; pointer-events: none; } </style> <meta http-equiv='refresh'> </head> <body><div class='main'><div class='text'><div class='binary' data-binary=' + teamID + '><p align=center style='width:100%;text-align:center'><img align=middle style='width:180px; float:middle' src='./img/icon.ico'></p>" > ./assets/ScoreReport.html
echo "	<h1> Linux Practice Round  </h1>" >> ./assets/ScoreReport.html
echo "	<h2>Report Generated At: $time </h2>" >> ./assets/ScoreReport.html
echo "	<h2> $Vulns out of $totalVulns vulnerabilities secured</h2>" >> ./assets/ScoreReport.html
echo "	</span> </p> <h3> $Vulns out of $totalVulns scored security issues fixed, for a gain of $points points:</h3><p></p>" >> ./assets/ScoreReport.html
if [ $Vulns != "0" ]; then
    while [[ $i -le $Vulns ]]; do
        echo "	<p>Vulnerablilty check passed</p>" >> ./assets/ScoreReport.html
        i=$(( $i + 1 ))
    done
else
    echo null
fi
echo "</p> <br> <p align=center style='text-align:center'> DolphinSE is free and open source software. This project is in no way endorsed or affiliated with the Air Force Association or the University of Texas at San Antonio. </p> </div> </div> </div> </body> </html>" >> ./assets/ScoreReport.html