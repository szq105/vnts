vnts Docker 部署说明
本文档提供了两种使用 Docker 部署 vnts 服务端的方法：使用 docker run 命令直接部署，或使用 docker-compose 进行部署。

注意: 两种方法均已包含 数据持久化 和 WireGuard流量支持 (--allow-wg) 的配置。

方法一：使用 docker run 命令
这是最直接的部署方式，通过一条命令即可启动服务。

1. 创建数据目录
首先，在您的服务器上创建一个用于存放 vnts 日志等数据的目录。

mkdir -p /opt/vnts_data

2. 运行Docker命令
复制并执行以下命令。请务必将 WEB用户名 和 WEB密码 替换为您自己的设置。

docker run \
  --name vnts \
  -p 29872:29872 \
  -p 29870:29870/tcp \
  -v /opt/vnts_data:/data \
  -e TZ=Asia/Shanghai \
  --restart=always \
  -d szq105/vnts \
  --allow-wg \
  -p 29872 \
  -P 29870 \
  -U WEB用户名 \
  -W WEB密码 \
  --log-path /data/vnts.log

参数说明:

-v /opt/vnts_data:/data: 数据持久化。将服务器的 /opt/vnts_data 目录挂载到容器的 /data 目录。

--log-path /data/vnts.log: 将日志文件输出到我们挂载的数据目录中。

--allow-wg: 启用WireGuard流量支持。

-U WEB用户名 -W WEB密码: 请替换为您的Web管理后台的用户名和密码。

方法二：使用 docker-compose
使用 docker-compose 可以更方便地管理和维护您的服务配置。

1. 创建 docker-compose.yml 文件
在您的服务器上创建一个名为 docker-compose.yml 的文件，并将以下内容复制进去。

version: '3.9'
services:
    vnts:
        image: szq105/vnts:latest
        container_name: vnts
        restart: always
        ports:
            - '29870:29870/tcp'
            - '29872:29872'
        environment:
            - TZ=Asia/Shanghai
        volumes:
            # 数据持久化: 将宿主机的 ./vnts_data 目录挂载到容器的 /data 目录
            - ./vnts_data:/data
        command: >
          --allow-wg
          -p 29872 
          -P 29870 
          -U WEB用户名
          -W WEB密码
          --log-path /data/vnts.log

注意:

请确保将 WEB用户名 和 WEB密码 替换为您自己的设置。

./vnts_data:/data 表示会在 docker-compose.yml 文件所在的目录下自动创建一个 vnts_data 文件夹用于存放数据。

2. 启动服务
在 docker-compose.yml 文件所在的目录中，执行以下命令即可启动服务。

docker-compose up -d

服务管理
查看日志:

docker logs -f vnts

停止服务:

(对于 docker run): docker stop vnts

(对于 docker-compose): docker-compose down

更新镜像并重启:

docker pull szq105/vnts:latest

停止并删除旧容器 (docker rm -f vnts 或 docker-compose down)。

重新执行启动命令。由于数据已持久化，配置不会丢失。
