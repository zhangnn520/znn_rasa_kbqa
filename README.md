# 采用基于Rasa 3.1.0的知识图谱问答 

## 一、环境配置

### 1.1、linux环境

​			ubuntu 20.04TL，docker 23.0.0

### 1.2、代码环境

​			建议使用conda 安装环境安装requriment.txt

```powershell
			markdownify==0.11.6
			py2neo==2021.1.5
			rasa_sdk==3.4.0
			skimage==0.0
```

​		`pip install -r requriment.txt -i https://pypi.doubanio.com/simple ` 

​		注：			

​			1、win在安装MITIE时，比较麻烦，推荐采用Linux环境直接进行安装，安装方法为

​						`pip install git+https://github.com/mit-nlp/MITIE.git`

​			2、非win安装不可时，[win10安装 Mitie](https://blog.csdn.net/liu765023051/article/details/83107254?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-83107254-blog-93622942.pc_relevant_vip_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-83107254-blog-93622942.pc_relevant_vip_default&utm_relevant_index=2)        [MITIE自然语言处理工具](https://blog.csdn.net/wangyizhen_nju/article/details/93622942?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-93622942-blog-80965689.pc_relevant_vip_default&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-93622942-blog-80965689.pc_relevant_vip_default&utm_relevant_index=1)

## 二、neo4j数据导入

### 	2.1、安装neo4j

​		安装环境为linux，如果使用win环境安装neo4j，直接百度或google，选择win安装neo4j教程。
​		值得说明的是：
​		1、这里使用的是docker neo4j 使用镜像为neo4j 4.1 在neo4j_data下直接执行sh run.sh即可，

```powershell
	docker rm -f rasa_neo4j
	docker run  -d \
	--name rasa_neo4j   \
	-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/data:/data  \
	-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/log:/logs  \
	-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/conf:/var/lib/neo4j/conf  \
	-v /mnt/e/ENOCH-2022/RASA/Rasa_neo4j/neo4j/neo4j_data/import:/var/lib/neo4j/import \
	--env=NEO4J_AUTH=none  \# 没有设置账号和密码，直接点击登录
	--publish=7474:7474  \
	--restart=always  \
	--publish=7687:7687 neo4j:4.1
```

​		2、重启docker，导致数据丢失，这里将数据直接挂载到工程目录的neo4j/neo4j_data/data中。

### 	2.2、数据导入neo4j

​		1、首次导入数据，检查create_graph中neo4j IP及端口号是否正确
​		2、将medical.json解压至data目录下,该数据如果缺少，可以请在参考（2）中自行查找
​		3、执行Python neo4j/create_graph.py,正常情况下可以看到数据正在导入neo4j数据库
​		4、导入成功后查看是否有数据保存至neo4j_data的conf,log,data，如果有则说明数据导入正常
​		5、下次启动，直接启动neo4j_data/run.sh即可，就可以将之前导入的数据直接加载至容器中即可。

## 三、rasa train训练

1. Rasa训练数据集的构造：使用到了 [**Chatito工具**](https://rodrigopivi.github.io/Chatito/)
2. 下载用于mitie的模型文件放到`chat/data`文件夹下， [**百度网盘**](https://pan.baidu.com/s/1kNENvlHLYWZIddmtWJ7Pdg) ，密码：p4vx

### 3.1、nlu core 同时训练

```
python -m rasa train  --config conf/config.yml --domain conf/domain.yml --data data/ --out models
```

<img src="img\rasa_train1.png" alt="训练图片1" style="zoom:80%;" />

<img src="img\rasa_train2.png" alt="image-20230216134357076" style="zoom:80%;" />

### 3.2、只训练nlu

```
python -m rasa train nlu --config conf/config.yml --out models
```

###  3.3、只训练core

```
python -m rasa train core --domain conf/domain.yml --out models
```

## 四、启动rasa服务

### 4.1、启动action server

```
python -m rasa run actions --port 5055 --actions actions --debug
```

![image-20230216141332448](img\image-20230216141332448.png)

### 4.2、启动rasa shell 

​		直接在另一个终端上输入下面命令，注意：这时候的需要跟第一个终端在相同conda环境和目录下执行命令。

```
rasa shell --endpoints conf/endpoints.yml
```

<img src="img\image-20230216141112950.png" alt="image-20230216141914752" style="zoom:80%;" />



## 五、参考声明
1、https://github.com/zhangwanyu2020/Rasa_chat <br />
2、https://github.com/pengyou200902/Doctor-Friende <br />
3、https://github.com/changsha2999/Rasa_neo4j <br />
4、https://www.jianshu.com/p/07c87c63e83a











