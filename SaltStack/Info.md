### Salt...

> Topology
```
Master/Minion
Using 
ZeroMQ library (Networking) 
MessagePack (very fast message transfer)


```

* 4505 4506 > Ports on master that needs to oopen to subscribe 
* No Ports on Minion Needs to be open
* For respond from Minion using 4506 

#### Installing Salt Minion 

> Get Salt from RPM
* yum install https://repo.saltstack.com/yum/redhat/salt-repo-2018.3-1.el7.noarch.rpm
* yum install salt-minion salt-api

> create vim /etc/salt/minion.d/local.conf
* Specify id: and master:

```
master: 00.00.00.205 or hostname
id: slave1
```

*  systemctl start salt-minion

#### Installing Salt Master 
> Get Salt from RPM
* yum install https://repo.saltstack.com/yum/redhat/salt-repo-2018.3-1.el7.noarch.rpm
* yum install salt-master salt-api
* systemctl start salt-master
* iptables -F (Drop IP Tables)
#### Key Acceptance and Encryption 
* Pub and Priv RSA keypaird 
* AES Key every 24 hr, or whenever keys were deleted or updated on minion 
* Salt will rotate AES Key 
```
master.pem
master.pub

[root@SaltStackLearning ~]# ls /etc/salt/pki/master/
master.pem  minions           minions_denied  minions_rejected
master.pub  minions_autosign  minions_pre
```

> Master collects data about Minions in 
* minions minions_denied  minions_rejecte minions_autosign  minions_pre
```
minion.pem
minion.pub

[root@SaltStackLearning-03 ~]# ls /etc/salt/pki/minion/
minion.pem  minion.pub

```
* Master sends pub key to minions and minions need to accept it  (More info in salt-key --help | less)
* To see Keys 
```
[root@SaltStackLearning ~]# salt-key --list-all
Accepted Keys:
Denied Keys:
Unaccepted Keys:
slave1
slave2
```
* To accept the key 
```
cp /etc/salt/pki/master/minions_pre/* /etc/salt/pki/master/minions
or
salt-key -A

[root@SaltStackLearning minions_pre]# salt-key --list-all
Accepted Keys:
slave1
slave2


```
* To generate "preseed" Keys 
```
salt-key --gen-keys slave3
[root@SaltStackLearning test_salt_key]# ll
total 8
-r--------. 1 root root 1678 Nov 14 02:04 slave3.pem
-rw-r--r--. 1 root root  450 Nov 14 02:04 slave3.pub

cp slave3.pub /etc
```

### Execution Modules