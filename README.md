# 口罩查詢網站

## 實驗目的

- 因應大流量的請求
- 可以動態擴增提供服務的 pod

## docker 版

### 安裝環境

1. 到[這裡](https://docs.docker.com/engine/install/)依照版本安裝 docker
2. 到[這裡](https://docs.docker.com/compose/install/)依照版本安裝 docker-compose
3. Clone 此專案
4. cd 至此專案
5. 執行 `docker-compose up -d`
6. done，他會把服務開在 port 80

### 製作 docker image

> docker buildx build --platform linux/amd64,linux/arm64 -t {account/projectname}:v1 . --push

## K8s

### [Pod autoscaling](https://hackmd.io/-5AfWOIqTmCW-APHm0b7GA)

1. 請先製作好 deployment 、 Service 和 ingress

2. > kubectl autoscale deployment {name of deployment} --cpu-percent=30 --min=1 --max=5
   - 當 cpu 已經佔用 30% 的用量就要開始新增新的 Pod 來提供服務。最多可擴增到五個，當流量太少最少只需部署一個 Pod

## 踩雷

1. k8s 使用當時最新的 stable 版 1.8 ，然而 Autoscaling api有進行改版，但因為是最新版文件極度缺乏，故選擇使用 command line 。

2. 原本 flask 是透過 wsgi ([CGI](https://en.wikipedia.org/wiki/Common_Gateway_Interface)) 來對外溝通。但是在微服務的架構底下每一個 Service 都會被 scaling ，所以每個 Pod 不只需要提供主要服務的 container 還需要 cgi 的 container 。這樣會造成額外的 overhead ，我們應該直接在 main service 上開 port 。