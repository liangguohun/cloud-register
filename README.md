# cloud-register
用于演示gitlab-runner 部署ci/cd k8s的用例模板
### 创建 gitlab-runner
这里创建不像官网或阿里用helm创建，而是直接在k8s创建镜像实例

有相应镜像部署配置

https://github.com/liangguohun/dynamic-pvc


### 注册执行器

#### 进入控制台kubectl exec -it runner-rc-4l4x7 /bin/sh -n kube-system执行


![](https://user-gold-cdn.xitu.io/2019/10/23/16df8e1ec3731b76?w=1577&h=960&f=png&s=151947)

变量1用来配置发布nexus仓库

变量2用来调用kubectl api(基础镜像dynamic-pvc也有)
```
gitlab-ci-multi-runner register -n \
  --url http://gitlab.letee.top/ \
  --registration-token 27ZV1E1VMkzwG__Rxq2L \
  --tag-list=cloud-runner \
  --description "spring Cloud runner" \
  --kubernetes-namespace="kube-system" \
  --cache-path "/opt/cache" \
  --kubernetes-pull-policy="if-not-present" \
  --kubernetes-image "docker:19.03-dind" \
  --executor kubernetes

```

#### vi修改config.toml



```

[[runners]]
  name = "spring Cloud runner"
  url = "http://gitlab.letee.top/"
  token = "A4mdXQwnCiyR7dm695Xi"
  executor = "kubernetes"
  [runners.custom_build_dir]
  [runners.cache]
    Path = "/opt/cache"
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.kubernetes]
    host = ""
    bearer_token_overwrite_allowed = false
    image = "docker:19.03-dind"
    namespace = "kube-system"
    namespace_overwrite_allowed = ""
    privileged = false
    pull_policy = "if-not-present"
    service_account_overwrite_allowed = ""
    pod_annotations_overwrite_allowed = ""
    [runners.kubernetes.pod_security_context]
    [runners.kubernetes.volumes]
      [[runners.kubernetes.volumes.host_path]]                                       
        name = "docker"                                                              
        mount_path = "/var/run/docker.sock"                                          
        host_path = "/var/run/docker.sock"                                           
      [[runners.kubernetes.volumes.host_path]]
        name = "tmp-cache"
        mount_path = "/opt/cache"
        host_path = "/opt/cache"
```

#### 变量配置

![](https://user-gold-cdn.xitu.io/2019/10/23/16df8e565f2710c5?w=1611&h=594&f=png&s=88881)

执行

**echo $(cat ~/.kube/config | base64) | tr -d " "**

获取kube-config变量值用于通讯

runners.kubernetes.volumes挂载目录要手动补上,否者会链接补上docker，及缓存目录无法在job间传递

![](https://user-gold-cdn.xitu.io/2019/10/23/16df8ddd6ddd51bc?w=350&h=427&f=png&s=20988)
三个核心配置文件1用于管控，3用于构建镜像， 2用于更新服务

#### 工程参考源码

https://github.com/liangguohun/cloud-register.git

### 参考

https://help.aliyun.com/document_detail/106968.html

https://gitlab.com/gitlab-org/gitlab-foss/tree/master/lib/gitlab/ci/templates

http://www.imooc.com/article/293003
