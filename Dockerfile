FROM ubuntu:20.04

#자바 등 기타 프로그램 설치
RUN apt-get -y update &&  apt-get install -y --no-install-recommends \
    vim \
    wget \
    unzip \
    ssh openssh-* \
    net-tools \
    openjdk-8-jdk

#ssh 키 생성
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Zookeeper 설치
RUN wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz && \
    tar -xvf apache-zookeeper-3.8.0-bin.tar.gz && \
    mv apache-zookeeper-3.8.0-bin /usr/local/zookeeper && \
    rm apache-zookeeper-3.8.0-bin.tar.gz


# 환경변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    ZOOKEEPER_HOME=/usr/local/zookeeper 
ENV JAVA_HOME=$JAVA_HOME \
    PATH=$PATH:$JAVA_HOME/bin:$ZOOKEEPER_HOME/bin \
    ZOOKEEPER_CONF_DIR=$ZOOKEEPER_HOME/conf 
    
RUN echo 'export ZOOKEEPER_HOME=/usr/local/zookeeper' >> ~/.bashrc && \
    echo 'export ZOOKEEPER_CONF_DIR=$ZOOKEEPER_HOME/conf' >> ~/.bashrc && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin:$ZOOKEEPER_HOME/bin' >> ~/.bashrc 


# 설정파일 복사(zookeeper)
COPY config/zoo.cfg ${ZOOKEEPER_CONF_DIR}/zoo.cfg
RUN mkdir -p /usr/local/zookeeper/data && mkdir -p /usr/local/zookeeper/logs && chown -R $USER:$USER /usr/local/zookeeper && \
    touch /usr/local/zookeeper/data/myid

# 초기 실행파일 복사
COPY start.sh /usr/local/zookeeper/start.sh


RUN mkdir /var/run/sshd


WORKDIR $ZOOKEEPER_HOME

EXPOSE 22


CMD ["bash","start.sh"]

#ENTRYPOINT ["/usr/sbin/sshd","-D"]


#    start-all.sh && \
#    mr-jobhistory-daemon.sh start historyserver && \
#    /bin/bash
