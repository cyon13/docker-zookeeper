#!/bin/bash


SERVER_HOST_NAME=$HOSTNAME
ZOOKEEPER_HOME=$ZOOKEEPER_HOME

# ssh 실행
service ssh start


nodes="zk1 zk2 zk3"


# hosts 파일 복사
if [ $SERVER_HOST_NAME == zk1 ];
then
	for node in $nodes
	do	
		IPADDR=$(ssh -o  StrictHostKeyChecking=no $node "ifconfig  | grep broadcast| awk '{print \$ 2}'")
		NAME=$(ssh -o  StrictHostKeyChecking=no $node "echo \$HOSTNAME")
		HOST="$IPADDR		$NAME"
		if [[ -z `grep "$node" /etc/hosts` ]]
		then
			echo $HOST >> /etc/hosts
			echo $HOST
		fi
	done

	for node in $nodes
	do	
		scp /etc/hosts $node:/etc/hosts
		scp ~/.ssh/known_hosts $node:~/.ssh/known_hosts
	done
fi

# myid 설정
if [ $SERVER_HOST_NAME == zk1 ];
then 
    echo "1" > /usr/local/zookeeper/data/myid
elif [ $SERVER_HOST_NAME == zk2 ];
then
    echo "2" > /usr/local/zookeeper/data/myid
elif [ $SERVER_HOST_NAME == zk3 ];
then
    echo "3" > /usr/local/zookeeper/data/myid
fi

# zookeeper 실행
if [ $SERVER_HOST_NAME == zk1 ] || [ $SERVER_HOST_NAME == zk2 ] || [ $SERVER_HOST_NAME == zk3 ];
then
    echo `$ZOOKEEPER_HOME/bin/zkServer.sh start`
fi

# zookeeper format
#if [ $SERVER_HOST_NAME == nn1 ];
#then
#    echo `$HADOOP_HOME/bin/hdfs zkfc -formatZK `
#fi


tail -f /dev/null
                  
