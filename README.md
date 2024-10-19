# random_image_api

> - 基于python+docker搭建个人的随机获取图片API,在构建博客时存在这个需求,于是编写了这个镜像。嗯...说实话...有点low。
> - 其实2.0中是采用 `CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "--timeout", "37", "app:app"]` 启动，不知到是否是参数设置的问题，响应速度特别慢，最终还是改回 `CMD ["python","app.py"]` 得到3.0版本。

##### 项目结构

```tex
./image-api
├── app
│   ├── api_key.txt(初始api_key)
│   ├── app.py(服务)
│   ├── convert_images.sh(将/images图片转为webp格式,非图片删除,可能会误删,建议图片格式png、jpg、webp)
│   └── update_api_key.sh(生成或更新key)
├── Dockerfile(docker镜像构建文件)
└── README.md
```

---

1. ##### 构建

   1. 方式一:使用 docker hub拉取: `docker pull dreamfishyx/random-image-api:3.0`。

   2. 方式二:使用阿里云镜像仓库拉取: `docker pull crpi-h14u4qrsee050ru5.cn-hangzhou.personal.cr.aliyuncs.com/dreamfishyx/random-image-api:3.0`

   3. 方式三:手动构建(推荐)

      ```bash
      # 克隆
      git clone --depth 1 https://github.com/dreamfishyx/random_image_api.git
      
      # 进入目录
      cd ./random_image_api
      
      # 构建镜像
      docker build -t random-image-api .
      ```

   > 若是构建过程中拉取镜像超时,可以尝试使用镜像加速。但是目前很多镜像加速都用不了,额...可以试着自己利用开源项目搭建一个自己的私人镜像加速。


   ---

   ##### 运行

   1. 创建并启动容器：

      1. 创建数据卷: `docker volume create random-image-api`。
      2. 创建并运行容器: `docker run -v ~/random-image:/app/images -v ~/flask/log:/app/log -dp 5000:5000 --name image_api random-image-api`(从镜像中心拉取的话，镜像名称可能不一样，自行更改)。

   2. 访问图片：

      1. 查看初始 api-key: `docker exec -it image_api cat /app/api_key.txt`，实际上其默认值为`f52b63814da6efc0d3e5fa5d7ba5790698ee87a34c4fb2c15de9520155ea82cb`。
      2. 访问格式为:`http://localhost:5000/random-image/<your_api_key>`(初始状态没有图片，无法访问，参考下面方式添加图片)。

   3. 更新api-key(初始时建议更新):

      1. 首先手动更新 api-key文件:`docker exec -it image_api  /app/update_api_key.sh`(此时应用未更新，api-key未改变)。
      2. 访问`http://localhost:5000/update-key/<your_api_key>`更新应用api-key改变((api-key更新)，可能需要等待一段时间(还不行就再次访问，直至返回Unauthorized)。

   4. 添加或者修改图片:

      1. 向系统目录 `~/random-image` 中添加或者删除图片(非图片格式在构建镜像时会被删除)。

      2. 执行脚本对容器图片进行格式转换:`docker exec -it image_api /app/convert_images.sh`。

      3. 访问`http://localhost:5000/update-images/<your_api_key>`更新应用图片列表，需要等待一段时间。

   5. 目前这个镜像的优化应该会告一段落。


---

##### 自定义

1. 实际上述API也可以直接部署,不需要`docker`(纯粹个人需要),但是需要改一些配置、安运行一些命令。但这些代码并不复杂,可自行尝试。

2. 足够熟悉这些文件可以修改和补充,构建自己的镜像。文件内容详解：后续在[博客](https://dreamfish.cc/archives/dockerda-jian-ge-ren-sui-ji-tu-pian-api)中编写。
