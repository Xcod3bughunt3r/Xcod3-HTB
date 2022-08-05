# *REAME file for web q_show*

#### *The idea is simple. First you need to set up a cron job to collect trafic to a file (q_show.log). After that, the q_show.php script will parse the log file and will output the real time trafic to web.  This is done every 60 seconds.*

###### *Configuring. First you need to have a functional http server with php. You need a domain ( ex mydomain.com ) and the default DocumentRoot directory ( /var/www/htdocs/). After you run make, make install, now is time to run make install_web. In /var/www/htdocs/ will be created the webhtb directory where the php script will be installed.*

###### *Before add the cron job, you need to set:*
````
- time interval, */1 every 1 minute generate the logfile; you can set any time you want;
- the path to the configuration file to be correct (eg: /etc/htb/eth1-qos.cfg);
- the interface, ethx where x = 0, 1, 2 ... etc, the interface you want to monitor;
- set the correct path to webhtb. By default it set to /var/www/htdocs;
- add this to crontab (crontab -e):

*/1 * * * * /sbin/q_show -i eth1 -f /etc/htb/ethX-qos.cfg -1 > /var/www/htdocs/webhtbb/q_show.log
````

###### *To view the web page with the traffic statistics, type in your browser: <http://www.mydomain.com/webhtb/index.php>*