# random_image_api
> 基于python+docker搭建个人的随机获取图片API(脚本仅支持linux使用),在构建博客时存在这个需求,于是编写了这个镜像。

##### 项目结构

```tex
/image-api
|-- Dockerfile (docker镜像构建文件)
|-- app.py (服务)
|-- api_key.txt (初始key)
|-- convert_images.sh (将/images图片转为webp格式,非图片删除,可能会误删,建议图片格式png、jpg、webp)
|-- update_api_key.sh (生成或更新key)
|-- /images (存放用于随机读取的图片)
```



##### 使用

1. 使用前提：正确安装`docker`,并可以正常拉取镜像。

2. 克隆仓库：

   ```bash
   git clone git@github.com:dreamfishyx/random_image_api.git
   
   cd ./random_image_api
   ```

3. 在`images`中准备好你所需要的图片文件(非图片格式在构建镜像时会被删除)

4. 构建并启动镜像后重置key：

   ```bash
   # 构建镜像
   docker build -t random-image-api .
   
   # 运行容器
   docker run -dp 5000:5000 --name api random-image-api
   
   # 更新key
   docker exec -it api /app/update_api_key.sh
   ```

5. 通过访问`http://localhost:5000/random-image?key=xxxxxxxxxxxx`来测试`API`，它会随机返回一张图片。





##### 自定义

待补
