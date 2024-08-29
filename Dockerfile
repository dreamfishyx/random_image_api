# 使用python基础镜像
FROM python:3.11-slim

# 设置 apt 源和 pip 镜像
RUN echo "deb http://mirrors.ustc.edu.cn/debian/ bookworm main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.ustc.edu.cn/debian/ bookworm main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.ustc.edu.cn/debian-security bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.ustc.edu.cn/debian-security bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.ustc.edu.cn/debian/ bookworm-updates main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.ustc.edu.cn/debian/ bookworm-updates main" >> /etc/apt/sources.list \
    && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# 安装必要的软件包和工具
RUN apt-get update \
    && apt-get install -y \
       apt-utils \
       libwebp-dev \
       openssl \
       file \
       webp \
    && pip install --upgrade pip \
    && pip install Flask 

# 设置工作目录并复制文件
WORKDIR /app
COPY . /app

# 使脚本可执行并运行它们
RUN chmod +x /app/convert_images.sh /app/update_api_key.sh \
    && /app/convert_images.sh 

# 暴露应用运行的端口
EXPOSE 5000

# 指定运行应用的命令
CMD ["python", "app.py"]
