#!/bin/bash
#######################################################
#
# @Author: Hardik Mehta <hard.mehta@gmail.com>
#
# @version: 0.3	  further improvements, removed google - Sebastian Gumprich <sebastian.gumprich (at) 38 (dot) de>
# @version: 0.2   optimized 
# @version: 0.1   basic script
#
########################################################
usage(){
	printf %s "\
        \${execi 1800 $0/weather.sh location option }
        Usage Example:
        \${execi 1800 $0/weather.sh "Munich,Germany" }     - prints current conditions
        \${execi 1800 $0/weather.sh "Munich,Germany" cp }  - prints symbol for current condition
        \${execi 1800 $0/weather.sh "Munich,Germany" dl }  - prints list of days
        \${execi 1800 $0/weather.sh "Munich,Germany" fct}  - list of high/low temperature
	"
	exit 1
}

# "City,Country" e.g. "Munich,Germany"
LOCID=$1

# Possible conditions:
# cp - prints symbol for current condition
# dl - prints list of days
# fct- list of high/low temperatures
CONDITIONS=$2

# API-Key from worldweatheronline.com
KEY=

# s=standard units, m=metric units
UNITS=m

# where this script and the XSLT lives
RUNDIR=`dirname $0` 
XSLTDIR="${RUNDIR}/worldweather"
weather_xml="${RUNDIR}/weatherInfo.xml"

# Binaries
command -v curl >/dev/null 2>&1 || { echo "I require curl but it's not installed. Aborting." >&2; exit 1; }
command -v xsltproc >/dev/null 2>&1 || { echo "I require xsltproc but it's not installed. Aborting." >&2; exit 1; }

CURLCMD="$(command -v curl) -s"
XSLTCMD="$(command -v xsltproc)"

# CURL url. 
WWWURL="http://api.worldweatheronline.com/free/v1/weather.ashx?q=${LOCID}&format=xml&num_of_days=4&key=${KEY}"

# don't get the file if created within an hour
update=3600


#######
#   Optimization. 
#   We cache the xml in a file and don't get the file
#   from internet if it is less than an hour old

function get_file ()
{
    # check if the file exists
    if [ ! -e $weather_xml ];
	then
		touch $weather_xml;
		age=`expr $update + 1`;
    else
	if [ $(stat -c %s $weather_xml) ];
        then
            now=`date -u +%s`
            created=`stat -c %Y $weather_xml`
            age=`expr $now - $created`
        else
            age=`expr $update + 1`
        fi
    fi
    # get the file if it is older than update time
    if [ $age -ge  $update ];
    then
        $CURLCMD -o $weather_xml "$WWWURL"
    fi

}




# The XSLT to use when translating the response from weather.com
# You can modify this xslt to your liking 
case $CONDITIONS in
	"cp")
		XSLT=${XSLTDIR}/conditions.xslt
		;;
	"dl")
		XSLT=${XSLTDIR}/fcDayList.xslt
		;;
	"fcp")
		XSLT=${XSLTDIR}/fcConditions.xslt
		;;
	"ct")
		XSLT=${XSLTDIR}/currentTemp.xslt
		;;
	"cc")
		XSLT=${XSLTDIR}/currentCondition.xslt
		;;
	"fct")
		XSLT=${XSLTDIR}/fcTemp.xslt
		;;
	*)
		XSLT=${XSLTDIR}/weather.xslt
		;;
esac
		
if [ -z $1 ]; then
	usage;
fi
get_file

eval "$XSLTCMD  $XSLT $weather_xml"
