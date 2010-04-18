#!/bin/bash


#######################################################
#
# @Author: Hardik Mehta <hard.mehta@gmail.com>
#
# @version: 0.2   optimized 
# @version: 0.1   basic script
#
########################################################



# Usage:
# ${execi 1800 /path/to/weather/weather.sh location option }
# Usage Example:
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" }     - prints current conditions
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" cp }  - prints symbol for current condition
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" dl }  - prints list of days
# ${execi 1800 /home/user/weather/weather.sh "Munich,Germany" fct}  - list of high/low temperatures


# "City,Country" e.g. "Munich,Germany"
LOCID=$1



CONDITIONS=$2
#echo $CONDITIONS

# s=standard units, m=metric units
UNITS=m

# where this script and the XSLT lives
RUNDIR=`dirname $0` 

# there's probably other stuff besides CURL that will work for this, but i haven't 
# tried any others. 
# you can get curl at http://curl.haxx.se/
CURLCMD="/usr/bin/curl -s"

# get it at http://xmlsoft.org/XSLT/
XSLTCMD=/usr/bin/xsltproc

# you probably don't need to modify anything below this point....

# CURL url. Use cc=* for current forecast or dayf=10 to get a multi-day forecast
#CURLURL="http://xoap.weather.com/weather/local/$LOCID?cc=*&unit=$UNITS&dayf=4"
CURLURL="http://www.google.com/ig/api?weather=${LOCID}"

weather_xml="${RUNDIR}/weatherInfo.xml"
# don't get the file  if created within an hour
update=3600


#######
#   Optimization. 
#   We cache the xml in a file and don't get the file
#   from internet if it is less than an hour old

function get_file ()
{
    #echo "get file called"
    # check if the file exists
    if [ -e $weather_xml ];
    then
        size=`stat -c %s $weather_xml`
        if [ $size -ge  1000 ];
        then
            now=`date -u +%s`
            created=`stat -c %Y $weather_xml`
            age=`expr $now - $created`
        else
            age=`expr $update + 1`
        fi
    else
        # if the file dosn't exist create it
        # and set the age older than update time
        touch $weather_xml
        age=`expr $update + 1`
    fi
    #echo $age
    # get the file if it is older than update time
    if [ $age -ge  $update ];
    then
        $CURLCMD -o $weather_xml "$CURLURL"
    fi
    #echo "get file ended"

}




# The XSLT to use when translating the response from weather.com
# You can modify this xslt to your liking 
if [ "$CONDITIONS" = "cp" ];
then
    XSLT=$RUNDIR/conditions.xslt
elif [ "$CONDITIONS" = "dl" ];
then
    XSLT=$RUNDIR/fcDayList.xslt
elif [ "$CONDITIONS" = "fcp" ];
then
    XSLT=$RUNDIR/fcConditions.xslt
elif [ "$CONDITIONS" = "ct" ];
then
    XSLT=$RUNDIR/currentTemp.xslt
elif [ "$CONDITIONS" = "fct" ];
then
    XSLT=$RUNDIR/fcTemp.xslt
else
    XSLT=$RUNDIR/weather.xslt 
fi

# echo $XSLT
#(if you want to convert stuff to lower-case or upper case or something)
#FILTER="|gawk '{print(tolower(\$0));}'"

get_file


#####
#eval "$CURLCMD \"$CURLURL\" 2>/dev/null| $XSLTCMD  $XSLT - $FILTER"
eval "$XSLTCMD  $XSLT $weather_xml"
