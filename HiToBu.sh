#!/bin/bash
# Hierarchical Token Bucket (HTB) successfully replaces Class Based Queuing (CBQ) due to the precise and easy to understand way it operates.
# HTB Tools wrapper script over (q_show, q_parser, q_checkcfg).



if [ `id -u` -ne 0 ]; then
        echo "This script must be run as root"
        exit -1
fi


Q_SHOW="/q_show"
Q_PARSER="/q_parser"
Q_CHECKCFG="/q_checkcfg"
PAGER=`which less`
CONF_DIR="/etc/config"
REMOVE=`which rm`
TC="/tc"
SED=`which sed`

function running_with()
	{
		echo -n "Q_SHOW is $Q_SHOW / "
		echo -n "Q_PARSER is $Q_PARSER / "
		echo -n "Q_CHECKCFG is $Q_CHECKCFG / "	
		echo " "
		echo -n "PAGER is $PAGER / "
		echo -n "CONF_DIR is $CONF_DIR / "
		echo -n "REMOVE is $REMOVE / "
		echo -n "TC is $TC"
	}




function show_usage()
	{
		echo "Usage:"
		echo "	htb interface {start|stop|stats|generate}"
		echo "	htb {help|version}"
		echo ""
		echo "where:"
		echo "	interface - the network interface you want to do shaping"
		echo "	start 	  - applies the setting from the config file on the interface"
		echo "	stop  	  - deletes the rules applied to the specified interface"
		echo "	stats 	  - displays realtime traffic statistics for the interface"
		echo "	generate  - only creates the script that applies the traffic rules"
		echo "	help	  - displays a little help information"
		echo "	version	  - displays version number & copyright information"
	}

function show_version()
	{
		echo "htb-tools initscript for Linux."
		echo "2022 Xcod3bughunt3r master@itsecurity.id"
		echo "This script is released under the terms of MIT License."
		echo "Work based on https://www.itsecurity.id/htbtools/htbtools.html"
	}

function show_help()
	{
		echo "The configuration files are located in $CONF_DIR must be named: eth[0-255]-qos.cfg"
		echo "Configuration examples and some documentation can be found in /opt/Xcod3-HTB/doc/"
		echo "for more information on how HTB works, visit https://www.itsecurity.id/htbtools/htbtools.html"
	}

function compile_rules()
	{
		echo "Compiling rules for $CONF_DIR/$1-qos.cfg..."
		echo  " "
		echo -n "Checking the configuration file ... "
		$Q_CHECKCFG $1 100000 100000 $CONF_DIR/$1-qos.cfg 1>/dev/null 2>&1
			if [ $? = 0 ]; then
				echo "OK."
					else
				echo -n "FAILED."
				echo -n "The configuration file contains errors."
				exit -1
			fi
                echo "Generating configuration file(s) for $1"
		$Q_PARSER $1 100000 100000 $CONF_DIR/$1-qos.cfg > /tmp/$1-qos.sh
	
		$SED 's/^[ ]*echo/#echo/g' /tmp/$1-qos.sh  > /tmp/$1-qos1.sh
                $SED 's/\$TC/echo/g'       /tmp/$1-qos1.sh > /tmp/$1-qos2.sh

                . /tmp/$1-qos2.sh >  /tmp/$1-qos.sh

                echo "The $1-qos.sh script file is saved to /tmp/$1-qos.sh"
                echo "You can start the traffic rules like: tc -b /tmp/$1-qos.sh"
                echo  " "
		exit 0
	}

function apply_rules()
	{
		echo "  "
		echo "Starting HTB-tools on $1 ..."
		echo -n "Checking the config file ..."
		$Q_CHECKCFG $CONF_DIR/$1-qos.cfg 1>/dev/null 2>&1
			if [ $? = 0 ]; then
				echo -n "OK"
				echo "  "
					else
				echo -n "FAILED"
				echo "The configuration file contains errors."
				exit -1
			fi
		$Q_PARSER $1 100000 100000 $CONF_DIR/$1-qos.cfg > /tmp/$1-qos.sh
		echo -n "Checking kernel support for HTB: "
		$TC qdisc add dev $1 root handle 1: htb default 10 1>/dev/null 2>&1
		if [ $? = 0 ]; then
			echo -n "present."
			echo " "

			$SED 's/^[ ]*echo/#echo/g' /tmp/$1-qos.sh  > /tmp/$1-qos1.sh
                        $SED 's/\$TC/echo/g'       /tmp/$1-qos1.sh > /tmp/$1-qos2.sh
			
	               . /tmp/$1-qos2.sh >  /tmp/$1-qos.sh

			$TC qdisc del dev $1 root 1>/dev/null 2>&1
          		$TC qdisc del dev $1 ingress 1>/dev/null 2>&1
	
	                $TC -b /tmp/$1-qos.sh
			$REMOVE -f /tmp/$1-qos.sh /tmp/$1-qos1.sh /tmp/$1-qos2.sh
        		echo "HTB-tools was successfuly started on $1."
			echo "  "
		else
			echo -n "not present."
			echo "Your kernel lacks support for HTB or HTB alredy running."
			echo "Try stop and then start again. Aborting..."
			exit -1
		fi
	}

function display_statistics()
	{
		echo "To stop viewing the statistics, press Ctrl+C."
		sleep 2
		$Q_SHOW	--interface $1 --file $CONF_DIR/$1-qos.cfg 
		exit 0
	}


if [ "$#" = "2" ]; then

	case "$2" in
		start)
			apply_rules $1
			exit 0
		;;
		stop)
			echo "Deleting rules for device $1"
			$TC qdisc del dev $1 root >/dev/null 2>&1
			$TC qdisc del dev $1 ingress >/dev/null 2>&1
			exit 0
		;;
		stats)
			display_statistics $1
			exit 1
		;;
	
		generate)
			compile_rules $1
			exit 0
		;;
	esac
else

	case "$1" in
			version)
				show_version
				exit 0
			;;
			help)
				show_help
				exit 0
			;;
		
			*)
				show_usage
				exit -1
			;;
	esac
fi
