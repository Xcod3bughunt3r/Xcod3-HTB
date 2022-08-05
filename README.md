*HTB Tools*
---------------------------------------------------
### *Hierarchical Token Bucket ( HTB ) successfully replaces Class Based Queuing ( CBQ ) due to the precise and easy to understand way it operates. The difference from CBQ is that the bandwidth is allocated to one (or more) classes, and when the class's allocated bandwidth is exceeded, it can (temporarily) borrow unused bandwidth from another class. Moreover, unlike CBQ, you can allocate several clients to one class. Using HTB-tools all classes and all clients can be defined in a configuration file.*

For a better understanding on how it works, let's suppose that we have a
bandwidth of 256kbps shared by 4 clients with public IP addresses,
each client having a guaranteed minimum of 48kbps and a guaranteed
maximum of 64kbps upload/download.

After HTB-tools is installed, you can proceed to edit the configuration
files. Assuming that eth0 is the interface to your provider and eth1
the interface to your clients, on the eth0 interface you can only limit
the upload (only if you use routable IP addresses) and on eth1 only the
download, because you can only control the debit of the packages that
leave the router (the information that enters the router is imposed by
the external environment). For upload limitations/guarantees you have to
edit the file /etc/htb/eth0-qos.cfg and for download
limitations/guarantees you have to edit the file /etc/htb/eth1-qos.cfg.

Configuration files for HTB-tools
----------------------------------
Remarks:
- the format of the configuration files resembles the format of bind's
  configuration files;
- the bandwidth users are divided into classes;
- these classes can not share the bandwidth among themselves;
- the members of a class (clients) can share the same bandwidth
  according to the parameters specified in the configuration file;
- a class may contain one or more clients;
- a special class is the default class, that defines the bandwidth
  allocated to those which are not included in any class;
- the transfer rate is specified in kbit;
- the lines having # as the first character are considered comments.
- you can NOT specify the fields src and dst for a class; these fields
  are only defined for clients.

The class syntax:
------------------
bandwidth 192; - the guaranteed minimum for the class;
                 represents the minimum total sum guaranteed for the
                 clients of the class;
limit 256;     - the maximum transfer rate for the class;
burst 2;       - the maximum number of kbits sent at once by the class;
!!! NOTE !!!============================================================
If you don't set the burst value properly, the limits might not work
correctly. Eg: for the limit 10000kbit you must use a burst of 12 kbit.
THIS IS AVAILABLE ONLY OF YOU USE PUBLIC IPs !
=======================================================================.

burst 0;       - ONLY for HTB-tools 0.3.0 - if burst is set to 0 then
                 HTB-tools will calculate the burst value automatically.
                 This is valid for clients side too.

priority 1;    - priority of the class; there are 8 priority levels:
                 from 0 to 7; the packets are served in ascending order of
                 priority. For example, if the priority is 0 then the
                 packets will first be served to this class, on the other
                 hand if the priority is 4 then the packets will first be
                 sent to the class having priority 0 and only then to the
                 class having priority 4;
que sfq;       - we can specify the qdisc for a class, if not specified
(or esfq;)       the default is pfifo limit 5.

For more details about esfq, please see http://fatooh.org/esfq-2.6/.

As specified above, we have a bandwidth of 256kbps that we want to
allocate to 4 clients, both for upload and for download. For this, we
first define the class:

       class class_1 {
               bandwidth 192;
               limit 256;
               burst 2;
               priority 1;
               que sfq;

The clients syntax:
--------------------
bandwidth 48;  - guaranteed minimum for the client;
   limit 64;   - maximum transfer rate for the client;
    burst 2;   - maximum number of kbits sent to the client at once;
    mark 20;   - if only mark is specified, without dst/src, then fw
                 will be used; if the source/destination is specified,
                 then u32 will be used with the possibility to mark
                 (match_in_u32); dst or src can be used together in the
                 configuration file only for clients; if you wish to
                 limit the upload then you must use src, and if you wish
                 to limit the download then you must use dst; in our
                 example above we have used limitation/allocation for
                 download and the configuration file will be eth1-qos.cfg;
priority 1;    - client priority;

IPs representation:
--------------------
192.168.100.12/32; - single IP;
192.168.1.0/24;    - class representation;
192.168.1.14/32 80 25; - limit the traffic on port 80 and 25 for a single IP;
192.168.1.0/24 25; - limit tge traffic on port 25 for a class;

The next step is to define the 4 clients. For each client a minimum of 48kbit
and a maximum of 64kbit will be allocated.

client client1 {
       bandwidth 48;
       limit 64;
       burst 2; # or burst 0; ONLY for HTB-tools 0.3.0
       priority 1;
       mark 20;
       dst {
               192.168.100.4/32;
               };
       };


client client2 {
       bandwidth 48;
       limit 64;
       burst 2; # or burst 0; ONLY for HTB-tools 0.3.0
       priority 1;
       mark 20;
       dst {
               192.168.100.5/32;
               };
       };


client client3 {
       bandwidth 48;
       limit 64;
       burst 2; # or burst 0; ONLY for HTB-tools 0.3.0
       priority 1;
       mark 20;
       dst {
               192.168.100.8/32;
               };
       };


client clien4 {
       bandwidth 48;
       limit 64;
       burst 2; # or burst 0; ONLY for HTB-tools 0.3.0
       priority 1;
       mark 20;
       dst {
               192.168.100.10/32;
               };
       };


class default { bandwidth 8; };
    };
};


!!! Only for HTB-tools 0.3.0 !!! =======================================
Another new feature is the "upload" function, which would assist in
managing the upload, if you use SNAT (private IP addresses). This can
be done using the same configuration file that you would use to manage
the download.

!!! WARNING: this type of shaping (ingress) drops the packets that are
over the limit, which generates additional traffic when entering the
interface. For this reason it is recommended to have the shaping machine
in the same LAN with the shaped machines. The "upload" option uses dst.


Configuration examples (client side):

client client {
   bandwidth 3500;
   limit 12000;
   burst 0; #NEW 0 = burst automatic calculation
   priority 3;
   mark 4;
   upload 300; #( in kbits) <- new
   dst {
    192.168.100.5/32;
   };
};

client client {
   bandwidth 3500;
   limit 12000;
   burst 0;  #NEW 0 = burst automatic calculation
   priority 3;
   upload 300; #  (in kbits)
   dst {
    192.168.100.5/32;
   };
};

UPLOAD option available from 0.3.0 works only with dst.
You can specify mark or src but this options will NOT
affect outgoing trafic.
========================================================================

The next step is checking the configuration file using the q_checkcfg
command:

   q_checkcfg /etc/htb/eth1-qos.cfg

   Default bandwidth: 8
   Class class_1, CIR: 192, MIR: 256
   ** 4 clients, CIR2: 192, MIR2: 256
   1 classes; CIR / MIR = 192 / 256; CIR2 / MIR2 = 192 / 256

* the configuration files are syntactically correct.

Starting with version 0.2.6, during installation you have the
option to install an HTB-tools start-up script. With this script you
can start, stop, restart and monitor the limitations/guarantees for
upload/download or for both.

To start the bandwidth policies for upload and download at boot time, you must
add to /etc/rc.d/rc.local the following line:
(this example is works on Slackware linux)

               /etc/rc.d/rc.htb start

- if you wish to limit/guarantee the bandwidth only for download then you
  must use the command:

               /etc/rc.d/rc.htb start_eth1

- if you wish to limit/guarantee the bandwidth only for upload then you must use
  the command:

               /etc/rc.d/rc.htb start_eth0

rc.htb complete options and usage
----------------------------------
/etc/rc.d/rc.htb start     | stop      | restart      |
                start_eth0 | stop_eth0 | restart_eth0 |
                start_eth1 | stop_eth1 | restart_eth1 |
                start_eth2 | stop_eth2 | restart_eth2 |
                show_eth0  | show_eth1 | show_eth2    |
                gen_eth0   | gen_eth1  |


Real time traffic
------------------
q_show allows you to see in real-time the traffic and bandwidth usage
for each client (download). In order to see mealtime traffic please run:

               /etc/rc.d/rc.htb show_eth1

...and the result is:

   class_1     224.80  2       192     256
   client_1    62.25   1       48      64
   client_2    51.05   1       48      64
   client_3    48.25   1       48      64
   client_4    63.25   1       48      64
   _default_   0       0       0       0


If you like to pass some options to q_show, please see the q_show(8) man page.

Web q_show
-----------
Web q_show is a tool that displays in a web page the traffic status and
allocated bandwidth for each class/client according to the configuration
file.
A cron job collects the traffic data in a .log file, namely q_show.log.
From here on it is the job of .php script (index.php) that parses the
file and displays the content in a web page.

Web q_show configuration
-------------------------
Before starting anything, you must have php installed and a working web
server (apache).
Let's assume that you have domain.com and the default directory for the
web pages is /var/www/htdocs/. The default directory specified at the
install time  will have a folder called webhtb with index.php script.

Before adding the line to crontab, set:
- the time interval (*/1 every minute or */5 every 5 minutes etc) at
  which to generate the traffic logs in the file;
- the correct path to the configuration file
- the interface, ethx where x = 0, 1, 2 ... etc, the interface
  you want to monitor;
- ethx-qos.cfg the configuration file for the monitored interface;
- the path to the webhtb directory;

Add to crontab (crontab -e):

*/1 * * * * /sbin/q_show -i eth1 -f /etc/htb/eth1-qos.cfg -1 > /var/www/htdocs/webhtb/q_show.log

You can see the traffic at the address http://www.yourdomain.com/webhtb/index.php


Web HTB-tools configuration files generator
--------------------------------------------

The web q_show install will get you whtbcfg in the same directory as webhtb
(i.e.: /var/www/htdocs/whtbcfg). You will need a functional httpd (apache) 
with php support to be able to use it.

php.ini settings
-----------------
Please set register_globals to ON in php.ini and
disable error_reporting like this:

register_globals = On
#error_reporting = E_ALL & ~E_NOTICE

After modifying php.ini, please restart the httpd server and point your
browser to:

   http://www.yourdomain.com/whtbcfg

to be able to generate configuration files.

Possible configurations in HTB-tools 0.3.0
--------------------------------------------
Please see the file cfg/possible_configs
