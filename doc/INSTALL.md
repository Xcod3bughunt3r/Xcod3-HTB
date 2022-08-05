# *!!! NOTE:*
__________________________
###### *This documentation is valid for HTB-tools 0.2.7 and HTB-tools 0.3.0 only if you do NOT use the setup program. In order to use setup, please consult the README option from the installing menu.*
__________________________

###### *THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A ARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*


Requirements:
--------------
 - GNU/Linux distribution;
 - GCC compiler;
 - Iproute2 (the latest version is recommended
   http://linux-net.osdl.org/index.php/Iproute2);
 - Linux Kernel 2.4.34.1 or 2.6.20 (www.kernel.org);
 - dialog for HTB-tools 0.3.0
   (the latest version from http://invisible-island.net/dialog/)
 - Apache and php for web q_show and web HTB-tools config file generator.
 - flex version 2.5.4a.

And now, on with the show ...  :-) 

GNU/Linux distribution
-----------------------
You must have a functional GNU/Linux distribution.
I received feedback from users who successfully run HTB-tools on:
Slackware, Gentoo, Fedora Core, Red Hat, Debian, Suse.
If you have tested and successfully run HTB-tools on other distributions
than what I mentioned, please send me an e-mail to update this section.

GCC compiler
-------------
Most Linux distributions have a GCC compiler included.
If you do not have GCC installed please see your distribution manual or
documentation on how to install GCC. You need this to compile HTB-tools.


Linux Kernel 2.4.34.1 ( http://www.kernel.org )
----------------------------------------------
If you compile the Kernel from sources, you will need to select the
following options for HTB-tools 0.2.7 and 0.3.0:

#
# QoS and/or fair queuing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_CSZ=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_QOS=y
CONFIG_NET_ESTIMATOR=y
CONFIG_NET_CLS=y
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_POLICE=y


Linux Kernel 2.6.20 ( http://www.kernel.org )
------------------------------------------------
If you compile the kernel from sources, you will need to select the
following options for HTB-tools 0.2.7 and/or HTB-tools 0.3.0:

#
# QoS and/or fair queuing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_CLK_JIFFIES=y
# CONFIG_NET_SCH_CLK_GETTIMEOFDAY is not set
# CONFIG_NET_SCH_CLK_CPU is not set

#
# Queuing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m
#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_ESTIMATOR=y

!!! NOTE !!! ===========================================================
To successfully use mark_in_u32 you MUST use at least the kernel 2.6.11.
           !!!  IT IS BEST TO USE THE LATEST VERSION !!!
========================================================================


Iproute2 - http://linux-net.osdl.org/index.php/Iproute2
-------------------------------------------------------
Before compiling HTB-tools 0.2.7 or HTB-tools 0.3.0, you need
iproute2-2.6.10-ss050124 or a greater version to be installed.

!!!  IT IS BEST TO USE THE LATEST VERSION !!!

After downloading and extracting the sources, please execute
"make" followed by "make install" commands. After compilation you need to
copy the tc binary to /sbin directory.


HTB-tools 0.2.7 or HTB-tools 0.3.0 ( http://htb-tools.arny.ro )
-----------------------------------------------------------------------
HTB-tools Bandwidth Management Software is a suite of tools that help
simplify the difficult process of bandwidth allocation, for both upload
and download traffic, using the Linux kernel's HTB facility. It can
generate and check configuration files. It also provides a real time
traffic overview for each separate client.

The set of HTB-tools includes:
q_parser  : reads a configuration file (the file defines classes,
            clients, bandwidth limits) and generates an HTB settings
            script;

q_checkcfg: check configuration files;

q_show    : displays in the console the status of the traffic and the
            allocated bandwidth for each class/client defined
            in the configuration file;

q_show.php: displays in a web page the status of the traffic and the
            allocated bandwidth for each class/client defined in the
            configuration file;

wHTB-tools_cfg_gen: create and generate configuration files from
                    a web page (only in HTB-tools 0.3.0)

htbgen    : generate configuration files from bash;


Compile and install
---------------------
Download the sources
  HTB-tools-0.2.7.tar.gz or HTB-tools.0.3.0.tar.gz

- extract and compile the sources:
   *for HTB-tools 0.2.7:
       tar -zxvf HTB-tools-0.2.7a.tar.gz
       cd HTB-tools-0.2.7a
       make

   *for HTB-tools 0.3.0
      tar -zxvf HTB-tools.0.3.0.tar.gz
      cd HTB-tools.0.3.0
      make

After compilation is done and if you install HTB-tools for the first
time then you must run the following command:

      make full

- this will install the binaries q_parser, q_show, q_checkcfg, htb,
  htbgen in the /sbin directory, the rc.htp init script to your
  init scripts directory, the two default configuration files
  eth0-qos.cfg for upload and eth1-qos.cfg for download in /etc/htb,
  q_show.php and wHTB-tools config generator.


UPGRADE
--------
You can upgrade HTB-tools using the fallowing command:

   make install

This will upgrade only the binary files q_parser, q_checfg, q_show,
the htb, rc.htb and htbgen scripts.

Now is time to read the How To use and configure HTB-tools 
from docs/.
