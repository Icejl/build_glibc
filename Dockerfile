FROM ubuntu:22.04

COPY sources.list /etc/apt/sources.list

# sed -i "s@http://archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list && \

RUN apt-get update && \
    apt-get install -y wget xz-utils bison python3 make gawk gcc

COPY build_libc.sh /root/build_libc.sh

WORKDIR /root

RUN chmod +x /root/build_libc.sh

CMD ["/bin/bash"] #sleep infinity
