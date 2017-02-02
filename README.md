# TinyFarmer-HUB
타이니파머의 센서값과 제어등을 처리하는 농장의 에이전트 (Agent)
==========================

![TinyFarmer-HUB Intro](https://github.com/makezonefablab/TinyFarmer-HUB/blob/master/img/tinyFarmerHub.png)  

[*타이니파머 허브 - 사이트 바로가기*](http://106.240.234.10/mediafarmHome/?page_id=14724)

[*타이니파머 허브 개발관련 카페 - 사이트 바로가기*](http://cafe.naver.com/makezone#)

OS파일 다운로드
--------------

[*라즈베리 2 (2016.11.30)*](http://my.tinyfarmer.com/tinyfarmer/atth/TinyFarmer-Hub-Raspberry2.img)

[*라즈베리 3 (2016.11.30)*](http://my.tinyfarmer.com/tinyfarmer/atth/TinyFarmer-Hub-Raspberry3.img)

[*라즈베리 b+ (2016.11.30)*](http://my.tinyfarmer.com/tinyfarmer/atth/TinyFarmer-Hub-Raspberryb.img)


소개
--------------
농장에 설치된 비트모스(BitMoss)와 연결되어 전송되는 데이터를 타이니파머 서버로 전달합니다.

인터넷과의 연결로 클라우드로 모아진 데이터를 전송하고 제어 명령을 받아 비트모스를 제어합니다.

별도의 설정이 필요 없이 바로 농장에 적용 가능합니다.



설치 
--------------
> 1. 소스 다운로드 
```
~ $ cd /home/mediaflow
~ $ sudo wget https://github.com/makezonefablab/TinyFarmer-HUB/src/TinyfarmerHubWeb.tar 
~ $ sudo wget https://github.com/makezonefablab/TinyFarmer-HUB/src/TinyfarmerHub.tar
~ $ sudo tar xvf TinyfarmerHub.tar
~ $ sudo tar xvf TinyfarmerHubWeb.tar
```
> 2.자바 메인모듈 
```
~ $ cd TinyfarmerHub/bin
~ $ sudo chown root:root TinyfarmerHub.sh
~ $ sudo chmod 744 TinyfarmerHub.sh
```
> 3.Web Application GUI 
```
~ $ sudo vi /usr/local/tomcat-8.0.36/conf/Catalina/localhost/ROOT.xml

아래 XML 내용 추가

~ $ sudo service tomcat restart
```
~~~xml
<?xml version='1.0' encoding='utf-8'?>
<Context crossContext="true" path="" docBase="/home/mediaflow/TinyfarmerHubWeb" >
</Context >
~~~






준비물
--------------

![TinyFarmer-HUB App](https://github.com/makezonefablab/TinyFarmer-HUB/blob/master/img/rasp.jpg) 





