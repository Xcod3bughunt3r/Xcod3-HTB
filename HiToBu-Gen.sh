#!/bin/bash
# HTB-Gen.
# Author: ALIF FUSOBAR - @Xcod3bughunt3r <master@itsecurity.id>
# License: MIT
# Description: HTB Tools Config Generator.

clear

echo "This works ONLY with class C-style network addresses!!!"
echo ""
echo "Please enter your IP class (eg. 192.168.1.): "
read IP_CLASS
echo "Please enter your client 1st and last host part of IP delimited by space: "
read IP_SEQ
echo "Please enter your bandwidth allocated to class (minimum): "
read CLASS_MIN
echo "Please enter your bandwidth allocated to class (maximum): "
read CLASS_MAX
echo "Please enter your burst allocated to class: "
read CLASS_BURST
echo "Please enter your priority allocated to class: "
read CLASS_PRIO
echo "Please enter your client bandwidth (minimum): "
read CLIENT_MIN
echo "Please enter your client bandwidth (maximum): "
read CLIENT_MAX
echo "Please enter your client burst: "
read CLIENT_BURST
echo "Please enter your client priority: "
read CLIENT_PRIO
echo "This will pe applied to source or destination [src/dst]?"
read SRCDST

echo "# Beginning of the script
class net {
	bandwidth $CLASS_MIN;
	limit $CLASS_MAX;
	burst $CLASS_BURST;
	priority $CLASS_PRIO;
" > config.cfg

for i in `seq $IP_SEQ`;
do
	echo "	client IP$i {
		bandwidth $CLIENT_MIN;
		limit $CLIENT_MAX;
		burst $CLIENT_BURST;
		priority $CLIENT_PRIO;
		$SRCDST {
			$IP_CLASS$i/32;
		};
	};" >> config.cfg
done

echo "};

class default { bandwidth 8; };

# Thank you for using this script <master@itsecurity.id>
# End of the script" >> config.cfg

echo "All done! Thank you for using htbgen!"
