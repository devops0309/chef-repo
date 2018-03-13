# mongodb

This is the complete cookbook for installing and configuring mongodb (standalon) + replication.

The recipes are :- 
1)  default.rb :- calling recipes (install.rb and hostname.rb) in it 
2)  install.rb :- For installing mongodb on a single machine 
3)  replication.rb :- For configuring replication on the cluster 
4)  hostname.rb for configuring hostname of the individual machines with updated rc.local file. 

The templates are :-
1) mongodb.conf.erb :- This is the mongodb configuration file. 
2) mongodb.service.erb :- mongodb init service file. 
3) rc.local.erb :- rc.local file for each mongodb instance 


How it works:
1) First of all you have to create 3 roles. If you want to configure only mongodb on a single machine, grant the role only mongodb to a node. If you want to configure replication, then grant an additional role named mongodb_replica_member to it in addition to a mongodb_primary to a single node to make it a primary member.
2) The mongodb role has install.rb and hostname.rb in it. The mongodb_replica_member role has recipe mongodb_replica_member in it and mongodb_primary role is just to identify the primary node. 
3) The recipe make use of chef search feature to get the Ips of the machine which has the role mongodb on them and make the desired etc hosts entry.
4) While bootstrapping the node, the name which you asssign to the machine will be set its hostname. The hostname should be a FQDN while you are configuring the mongodb replication. So please name it something like mongonode1.example.com.
5) This uses mongodb version 3.4.2.
