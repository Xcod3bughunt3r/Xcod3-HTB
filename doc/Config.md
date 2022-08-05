## *Some specifications:*
###### *The format of the configuration file is similar with bind configuration file format. The bandwidth compsumers are divided into classes. This classes can't share bandwidth between them. The members of a class (clients) can share bandwidth between them, as specified in the configuration file. One class can contain one or more clients. A special class is default class who specifies the bandwidth for the rest on the clients (the ones that we are not talking about in configuration file). Transfer rate (bandwidth) is specified in kbit/sec.*

###### *Configuration file format:*
````
 class <class_name> {
   bandwidth <class_bandwidth>;
   limit <maximum_bandwidth>;
   burst <no of kbytes that can be send once>;
   priority <class_priority>;

   client <client_name> {
      bandwidth <client_bandwidth>;
      limit <maximum_bandwidth_of_client>;
      burst <no of kbytes that can be send once>;
      priority <client_priority_in_this_class>;

      dst {
         <d_ip1 or d_network_1> d_port_1_1,d_port_1_2,...,d_port_1_x1;
         <d_ip2 or d_network_2> d_port_2_1,d_port_1_2,...,d_port_1_x2;
         ...
         <d_ipn or d_network_n> d_port_n_1,d_port_n_2,...,d_port_m_xn;
      };
      src {
         <s_ip1 or s_network_1> s_port_1_1,s_port_1_2,...,s_port_1_x1;
         <s_ip2 or s_network_2> s_port_2_1,s_port_2_2,...,s_port_2_x2;
         ...
         <s_ipn or s_network_n> s_port_n_1,d_port_n_2,...,d_port_2_xn;
      };
   };
};

class default { bandwidth <maximum_bandwidth_for_others>; };
````

###### *Examples: see sample.cfg and complex.cfg*

##### *Note:*
###### *For high transfer rate (greater than 2Mbit) the burst value must be at least 64 you can specify either source, either destination, either both.*