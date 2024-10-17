FROM python:3.11-slim

RUN echo "deb http://mirrors.aliyun.com/debian/ bookworm main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ bookworm main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian-security bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian-security bookworm-security main" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian/ bookworm-updates main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/debian/ bookworm-updates main" >> /etc/apt/sources.list \
    && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && apt-get update \
    && apt-get install -y \
       imagemagick \
       libwebp-dev \
       openssl \
       file \
       webp \
    && pip install --upgrade pip \
    && pip install Flask \
  	&& pip install flask-cors \
  	&& pip install gunicorn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./app /app

RUN chmod +x /app/convert_images.sh /app/update_api_key.sh 

EXPOSE 5000

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "--timeout", "37", "app:app"]
