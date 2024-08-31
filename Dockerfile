FROM python:3.11-slim

RUN echo "deb http://mirrors.ustc.edu.cn/debian/ bookworm main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.ustc.edu.cn/debian/ bookworm main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.ustc.edu.cn/debian-security bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.ustc.edu.cn/debian-security bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.ustc.edu.cn/debian/ bookworm-updates main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.ustc.edu.cn/debian/ bookworm-updates main" >> /etc/apt/sources.list \
    && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

RUN apt-get update \
    && apt-get install -y \
       imagemagick \
       libwebp-dev \
       openssl \
       file \
       webp \
    && pip install --upgrade pip \
    && pip install Flask 

WORKDIR /app
COPY . /app

RUN chmod +x /app/convert_images.sh /app/update_api_key.sh \
    && /app/convert_images.sh 

EXPOSE 5000

CMD ["python", "app.py"]
