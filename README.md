# LinuxTips
LinuxTips

### Make a symlink to folder 
```

ln -s /opt/kafka_2.11-2.0.0 kafka  
ln - LINK
-s - Path to folder 
kafka name of the shortcut

PS That way cd kafka will take you to /opt/kafka
```

### Find processes 
```
ps aux | grep java
```

### See history
```
history | more
...
 119  ~/kafka/bin/kafka-server-start.sh -daemon ~/kafka/config/server.properties 
 121  ~/kafka/bin/zookeeper-server-start.sh -daemon ~/kafka/config/zookeeper.properties
 133  ~/kafka/bin/kafka-server-stop.sh
 134  ~/kafka/bin/zookeeper-server-stop.sh

```
### Run form history
```
!119
!121

```

### Open Port
```
sudo ufw allow 22/tcp
```

### Copy from Remote top local
```$xslt
scp -r user@your.server.example.com:/path/to/foo /home/user/Desktop/
```

### Windows
```$xslt
kafka-console-consumer.bat --bootstrap-server ip:9092 --topic testing
kafka-console-producer.bat --broker-list ip:9092 --topic testing

SSL
kafka-console-consumer.bat --bootstrap-server ip:9093 --topic testing --consumer.config C:\Users\ddzmi\Desktop\kafkasecured\client.properties
kafka-console-producer.bat --broker-list ip:9093 --topic testing --producer.config C:\Users\ddzmi\Desktop\kafkasecured\client.properties
```