FROM ubuntu:bionic

COPY sources.list /etc/apt/sources.list

# sed -i "s@http://archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list && \

RUN apt-get update && \
    apt-get install -y wget git vim && \
    apt-get install -y gcc cmake gawk bison python3

COPY build_libc.sh /root/build_libc.sh

WORKDIR /root

RUN chmod +x /root/build_libc.sh && /root/build_libc.sh

ENTRYPOINT sleep infinity
