# docker-zookeeper


zookeeper 클러스터(3대로 구성)

## 실행
```sh
# 네트워크 생성(docker-compose 파일 내의 network가 external로 설정해놨기 때문에 따로 네트워크를 생성해줘야 한다)
docker network create hadoop_eco

# docker-compose 실행
docker-compose up -d
```

## 접속
```sh
docker exec -it zk1 bash
```

## zookeeper 노드 상태 확인
```sh
# zk1 status
$ZOOKEEPER_HOME/bin/zkServer.sh status

# zk2 zookeeper status
ssh zk2 "$ZOOKEEPER_HOME/bin/zkServer.sh status"

# Kafka03 zookeeper status
ssh zk3 "$ZOOKEEPER_HOME/bin/zkServer.sh status"
```

## zookeeper cli 실행
```sh
# zookeeper cli 실행
$ZOOKEEPER_HOME/bin/zkCli.sh

ls /
```
