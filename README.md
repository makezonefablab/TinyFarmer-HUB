# TinyFarmer-HUB
타이니파머의 센서값과 제어등을 처리하는 농장의 에이전트 (Agent)
==========================

![TinyFarmer-HUB Intro](https://github.com/makezonefablab/TinyFarmer-HUB/blob/master/img/tinyFarmerHub.png)  

[*타이니파머 허브 - 사이트 바로가기*](http://106.240.234.10/mediafarmHome/?page_id=14724)

[*타이니파머 허브 개발관련 카페 - 사이트 바로가기*](http://cafe.naver.com/makezone#)

OS파일 다운로드
--------------

### Latest version 
[*라즈베리 3 (2017.03.07)*](http://my.tinyfarmer.com/tinyfarmer/atth/2017-03-07-raspbian-jessie-Raspberry3_tinyfarmerHUB_8G.img)
```
2017.03.07 
- 채널 값을 로터리 스위치로 변경 
- 비트모스 쉴드에 연결된 HC12를 통해 Relay제어 기능
- USB 웹캠 연결로 CCTV기능 추가 (my.tinyfarmer.com 에서 지정)
```

[*라즈베리 3 (2017.02.07)*](http://my.tinyfarmer.com/tinyfarmer/atth/2017-02-07-raspbian-jessie-Raspberry3_tinyfarmerHUB_8G.img)
```
2017.02.07 
- 마스터 하드웨어 기능을 내부 모듈로 통합 
- HC12,RFM69 등 무선 모듈 통신 기능을 추가 
```


### Old version 

[*라즈베리 2 (2016.11.30)*](http://my.tinyfarmer.com/tinyfarmer/atth/TinyFarmer-Hub-Raspberry2.img)

[*라즈베리 3 (2016.11.30)*](http://my.tinyfarmer.com/tinyfarmer/atth/TinyFarmer-Hub-Raspberry3.img)

[*라즈베리 b+ (2016.11.30)*](http://my.tinyfarmer.com/tinyfarmer/atth/TinyFarmer-Hub-Raspberryb.img)


소개
--------------
농장에 설치된 비트모스(BitMoss)와 연결되어 전송되는 데이터를 타이니파머 서버로 전달합니다.

인터넷과의 연결로 클라우드로 모아진 데이터를 전송하고 제어 명령을 받아 비트모스를 제어합니다.

간단한 설정으로 곧바로 농장에 적용 가능합니다.



설치 
--------------
설치를 위해서는 위의 OS 이미지파일을 바로 사용하거나 기존의 라즈베리파이 OS를 설치 후 아래 지시사항에 따라 개별설치하여도 됩니다.

> 1. 소스 다운로드 
```
~ $ cd /home/mediaflow
~ $ wget https://github.com/makezonefablab/TinyFarmer-HUB/tree/master/src/TinyfarmerHubWeb.zip
~ $ wget https://github.com/makezonefablab/TinyFarmer-HUB/tree/master/src/TinyfarmerHub.zip
~ $ tar xvf TinyfarmerHub.zip
~ $ tar xvf TinyfarmerHubWeb.zip
```
> 2.자바 메인모듈 
```
~ $ cd TinyfarmerHub/bin
~ $ sudo chown root:root TinyfarmerHub.sh
~ $ sudo chmod 744 TinyfarmerHub.sh
```
> 3.Web Application GUI 
```
~ $ sudo vi /usr/local/tomcat-8.0.36/conf/Catalina/localhost/ROOT.xml    (아래 XML 내용 추가)
~ $ sudo service tomcat restart
```


~~~ xml
<?xml version='1.0' encoding='utf-8'?>
<Context crossContext="true" path="" docBase="/home/mediaflow/TinyfarmerHubWeb" >
</Context >
~~~

> 4.rc.local 수정  
```
~ $ sudo nano /etc/rc.local (아래 내용 추가)
```

~~~
# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

sudo chown -hR mediaflow /dev/ttyAMA0

sleep 20 
sudo /home/mediaflow/TinyfarmerHub/bin/TinyfarmerHub.sh start
sleep 10
sudo python /home/mediaflow/TinyfarmerMaster/Master_Start.py

~~~


준비물
--------------

![TinyFarmer-HUB App](https://github.com/makezonefablab/TinyFarmer-HUB/blob/master/img/rasp.jpg) 





