# random_image_api

> 基于python+docker搭建个人的随机获取图片API(脚本仅支持linux使用),在构建博客时存在这个需求,于是编写了这个镜像。嗯...说实话...好low啊...hah

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

---

##### 使用

1. 使用前提：正确安装`docker`,并可以正常拉取镜像。

2. 克隆仓库：(图片内存有点大,可能有些慢)

   ```bash
   git clone https://github.com/dreamfishyx/random_image_api.git
   
   cd ./random_image_api
   ```

3. 在`images`中准备好你所需要的图片文件(非图片格式在构建镜像时会被删除)。`images`中内置一些我自己收藏的壁纸(图片来源于网络,不可商用),不喜欢的可以自行筛选删除,但请确保构建镜像前`images`文件夹不为空。

4. 构建并启动镜像后重置key(镜像名、容器名可自定义)：在构建镜像的图片格式转换过程，若图片较大转换可能比较慢，此外更新源的过程也比较慢。

   ```bash
   # 构建镜像
   docker build -t random-image-api .
   
   # 运行容器
   docker run -dp 5000:5000 --name api random-image-api
   
   # 更新key
   docker exec -it api /app/update_api_key.sh
   ```

5. 初始key在`api_key.txt`中,但是不建议使用。请按照上述命令更新key,更新后原来的key失效(含初始key)。

6. 通过访问`http://localhost:5000/random-image/xxxxxx you key xxxxxx`来测试`API`，它会随机返回一张图片。

---

##### 自定义

1. 实际上述API也可以直接部署,不需要`docker`(纯粹个人需要),但是需要改一些配置、安运行一些命令。但这些代码并不复杂,可自行尝试。

2. 足够熟悉这些文件可以修改和补充,构建自己的镜像。文件内容详解：后续在博客中编写,待补。
