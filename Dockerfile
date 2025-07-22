# 使用一个非常小、干净的基础镜像
FROM alpine:latest

# 设置时区等环境变量，确保日志时间正确
ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8

# 在镜像内创建一个工作目录
WORKDIR /app

# 从构建参数接收二进制文件名 (这是由 GitHub Actions 自动传入的)
ARG VNT_BINARY
# 将下载的二进制文件复制到镜像的工作目录中，并重命名为 vnts
COPY ${VNT_BINARY} /app/vnts

# 赋予程序执行权限
RUN chmod +x /app/vnts

# 声明服务将使用的端口
EXPOSE 29872
EXPOSE 29870

# 声明一个数据卷用于持久化数据（例如日志）
# 注意：这只是一个声明，您在 docker run 命令中仍需使用 -v 参数来实际挂载
VOLUME ["/data"]

# 设置容器启动时默认执行的命令
ENTRYPOINT ["/app/vnts"]
