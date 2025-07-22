# 使用一个非常小、干净的基础镜像
FROM alpine:latest

# 在镜像内创建一个工作目录
WORKDIR /app

# 从构建参数接收二进制文件名 (这是由 GitHub Actions 自动传入的)
ARG VNT_BINARY
# 将下载的二进制文件复制到镜像的工作目录中，并重命名为 vnts
COPY ${VNT_BINARY} /app/vnts

# 赋予程序执行权限
RUN chmod +x /app/vnts

# 设置容器启动时默认执行的命令
ENTRYPOINT ["/app/vnts"]
