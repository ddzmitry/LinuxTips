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
> Key manipulation 
* Master collects data about Minions in:
* `minions minions_denied  minions_rejecte minions_autosign  minions_pre`
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
* To generate "pre-seed" Keys 
```
salt-key --gen-keys slave3
[root@SaltStackLearning test_salt_key]# ll
total 8
-r--------. 1 root root 1678 Nov 14 02:04 slave3.pem
-rw-r--r--. 1 root root  450 Nov 14 02:04 slave3.pub

cp slave3.pub /etc
```

### Execution Modules
> Targeting Minions 

```
[root@SaltStackLearning master]# salt '*' test.ping
slave2:
    True
slave1:
    True
    
```
> Grains

* Static information about each Minion
* Generated on Minion start
* Cached on the Master
* Custom Grain values can be set
* Custom Grain modules can be written 

```
salt-call grains.items

Gives Info about the Minion

* Check who is running RedHat 
[root@SaltStackLearning master]# salt -G os_family:RedHat test.ping
slave2:
    True
slave1:
    True

* Check who is running RedHat and name begins with slave
[root@SaltStackLearning master]# salt -C 'G@os_family:RedHat and slave*' test.ping
  slave2:
      True
  slave1:
      True


```
> Execution Module Services (Written in Python and return as JSON)
```
[root@SaltStackLearning master]# salt '*' pkg.install httpd
slave2:
    ----------
    apr:
        ----------
        new:
            1.4.8-3.el7_4.1
        old:
    apr-util:
        ----------
        new:
            1.5.2-6.el7
        old:
    centos-logos:
```
```
[root@SaltStackLearning master]# salt '*' cmd.exec_code python 'for i in range(1,10):print("Hello")'
slave2:
    Hello x9
slave1:
    Hello x9
```

> Common execution modules 
```
[root@SaltStackLearning master]# salt '*' sys.doc test.ping
test.ping:

    Used to make sure the minion is up and responding. Not an ICMP ping.

    Returns ``True``.

    CLI Example:

        salt '*' test.ping
        
salt slave1 test.versions_report 
slave1:
    Salt Version:
               Salt: 2018.3.3

    Dependency Versions:
               cffi: Not Installed
           cherrypy: 5.6.0
           dateutil: Not Installed
          docker-py: Not Installed
              gitdb: Not Installed
          gitpython: Not Installed
              ioflo: Not Installed


```
> List packages installed on minion 
```
salt slave1 sys.doc pkg.list_pkgs | less

salt slave1 pkg.list_pkgs | less
slave1:
    ----------
    GeoIP:
        1.5.0-11.el7
    PyYAML:
        3.10-11.el7
    acl:
        2.2.51-14.el7
    apr:
        1.4.8-3.el7_4.1
    apr-util:
        1.5.2-6.el7

[root@SaltStackLearning master]# salt slave1 pkg.list_pkgs | grep vim
    vim-common:
    vim-enhanced:
    vim-filesystem:
    vim-minimal:
    

```
> Installing
```
[root@SaltStackLearning master]# salt '*' pkg.install wget

```
> User Module 
```
[root@SaltStackLearning master]# salt slave1 user.list_users
slave1:
    - adm
    - apache
    - bin
    - centos
    - chrony
[root@SaltStackLearning master]# salt slave1 user.getent root
slave1:
    |_
      ----------
      fullname:
          root
      gid:
          0
      groups:
          - root
      home:

```
> Service Module `[root@SaltStackLearning master]# salt slave1 sys.doc service | less`
```
salt slave1 service.get_running | less
slave1:
    - auditd
    - chronyd
    - crond
    - dbus
    - dbus.socket
    - getty@tty1
    - gssproxy
```
> Statuse Module (disk stats , memory stats etc.)

```
salt slave1 status.uptime
slave1:
    ----------
    days:
        0
    seconds:
        10830
    since_iso:
        2018-11-14T00:36:34.944495
    since_t:
        1542155794
    time:
        3:0
salt slave1 status.diskusage
[root@SaltStackLearning master]# salt slave1 status.diskusage
slave1:
    ----------
    /:
        ----------
        available:
            25636282368
        total:
            26831990784
    /dev:

```

> CMD  module 
```
[root@SaltStackLearning master]# salt '*' cmd.run 'whoami'
slave2:
    root
slave1:
    root
    
[root@SaltStackLearning master]# salt '*' cmd.run 'ls -ltr ${PWD}'
slave2:
    total 16
    -rw-------. 1 root root 6577 May 16 20:54 original-ks.cfg
    -rw-------. 1 root root 6921 May 16 20:54 anaconda-ks.cfg    
    
salt sl* cmd.run 'curl "https://stackoverflow.com/questions/42633049/deploy-a-python-script-with-saltstack-test-if-it-works-correctly" '
cmd.run_all
cmd.script salt://myscript.sh

```
> Grains module 
```
[root@SaltStackLearning master]# salt slave[1-2] grains.get os_family

slave2:
    RedHat
slave1:
    RedHat


[root@SaltStackLearning master]# salt slave[1-2] cp.list_master
slave2:
slave1:

Check if list is matching 
[root@SaltStackLearning master]# salt slave1 match.list slave2
slave1:
    False

```

### Call from master or Minions 
```sh
salt '*' network.netstat
salt '*' network.netstat -l debug
slave2:
    |_
      ----------
      inode:
          14553
      local-address:
          0.0.0.0:111
      program:
          474/rpcbind
      proto:
          tcp
      recv-q:
          0
      remote-address:
          0.0.0.0:*
      send-q:
          0
      state:
          LISTEN
      user:
          0
    |_

salt 'slave[1-2]' cmd.run 'ls -la'
salt 'slave[1-2]' cmd.run cmd='ls' cwd='/etc/salt'

```
> Positional Arguments
```bash
salt 'slave[1-2]' test.arg foo bar=Bar baz='{quz:Qux}'

slave1:
    ----------
    args:
        - foo
    kwargs:
        ----------
        __pub_arg:
            - foo
            |_
              ----------
              bar:
                  Bar
              baz:
                  {quz:Qux}

salt 'slave[1-2]' test.arg foo bar=Bar baz='{quz:Qux}' quux=True
slave1:
    ----------
    args:
        - foo
    kwargs:
        ----------
        __pub_arg:
            - foo
            |_
              ----------
              bar:
                  Bar
              baz:
                  {quz:Qux}
              quux:
                  True

```
### Defining the State of Infrastructure
```
create:
/srv/salt

vim apache.sls
install_apache:
 pkg.installed:
   - name: apache2

and if converted to JSON will be 

{
  "install_apache": {
    "pkg.installed": [
      {
        "name": "apache2"
      }
    ]
  }
}
```

> ####  salt '*' state.sls apache
```
To version control 
It will cache file to all minionos

salt slave[1-2] cp.cache_file salt://apache.sls
slave2:
    /var/cache/salt/minion/files/base/apache.sls
slave1:
    /var/cache/salt/minion/files/base/apache.sls

```
> Get IP Address data 
```
 salt '*' network.ip_addrs
 salt '*' network.get_hostname
```
