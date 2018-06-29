# TinyFarmer-HUB
타이니파머의 센서값과 제어등을 처리하는 농장의 에이전트 (Agent)
==========================

![TinyFarmer-HUB Intro](https://github.com/makezonefablab/TinyFarmer-HUB/blob/master/img/tinyFarmerHub.png)  

[*타이니파머 허브 - 사이트 바로가기*](http://106.240.234.10/mediafarmHome/?page_id=14724)

[*타이니파머 허브 개발관련 카페 - 사이트 바로가기*](http://cafe.naver.com/makezone#)

OS파일 다운로드
--------------

### Latest version 

[*라즈베리 3 (2018.06.29)*](http://106.240.234.12/tinyfarmer/atth/2018-01-15-raspbian-jessie-Raspberry3_tinyfarmerHUB_15G.img)
```
2018.01.15 
- 쉴드의 버튼 누름 시 시스템 shutdown기능 추가
- RFM69 통신 모듈 삭제

* 알려진 버그
- 클라우드 상에 허브가 정상적으로 연결이지만, 표시는 "끊김" 표시가 종종 나타남
```

[*라즈베리 3 (2018.01.15)*](http://106.240.234.12/tinyfarmer/atth/2018-01-15-raspbian-jessie-Raspberry3_tinyfarmerHUB_15G.img)
```
2018.01.15 
- 쉴드의 버튼 누름 시 시스템 shutdown기능 추가
- RFM69 통신 모듈 삭제

* 알려진 버그
- 클라우드 상에 허브가 정상적으로 연결이지만, 표시는 "끊김" 표시가 종종 나타남
```

### Old version expired belows

[*라즈베리 3 (2017.10.26)*]
```
2017.10.26 
- 웹GUI에 카메라 설정 기능 추가 (mjpg-streamer)
- 허브모드 ("허브" / "허브+CCTV" / "허브+카메라") 설정 요청 및 장치 등록 기능 추가
- 용량 8G에서 16G로 증가 (마이크로 SD카드를 sdformater에서 "Overwrite Format" 수행 후 이미지 구워야 함)

* 알려진 버그
- 클라우드 상에 허브가 정상적으로 연결이지만, 표시는 "끊김" 표시가 종종 나타남
```

[*라즈베리 3 (2017.06.14)*]
```
2017.05.24 
- 비트모스 콘트롤러에게 데이터 요청하는 시간간격 조절 기능 추가 (웹 GUI에 Time Delay)
- 비트모스 센서에 WT1000(A) 센서 사용 시 Time Delay를 20초 이상으로 설정바람

* 알려진 버그
- 클라우드 상에 허브가 정상적으로 연결이지만, 표시는 "끊김" 표시가 종종 나타남
```

[*라즈베리 3 (2017.05.24)*]
```
2017.05.24 
- 통신보안(security)기능 적용
- 비트모스콘트롤러 프로토콜 변경
- TinyFarmer-Arduino-Shield의 라이브러리 1.5버전과 호환됨 (*)

* 알려진 버그
- 클라우드 상에 허브가 정상적으로 연결이지만, 표시는 "끊김" 표시가 종종 나타남
```

[*라즈베리 3 (2017.04.04)*]
```
2017.04.04 
- 신규 클라우드로 주소(my.tinyfarmer.com) 변경 
- TinyFarmer-Arduino-Shield의 라이브러리 1.5버전과 호환됨 (*)

* 알려진 버그
- 클라우드 상에 허브가 정상적으로 연결이지만, 표시는 "끊김" 표시 상태임
```

[*라즈베리 3 (2017.03.07)*]
```
2017.03.07 
- 채널 값을 로터리 스위치로 변경 
- 비트모스 쉴드에 연결된 HC12를 통해 Relay제어 기능
- USB 웹캠 연결로 CCTV기능 추가 (my.tinyfarmer.com 에서 지정)
- TinyFarmer-Arduino-Shield의 라이브러리 1.5버전과 호환됨 (*)
```

[*라즈베리 3 (2017.02.07)*]
```
2017.02.07 
- 마스터 하드웨어 기능을 내부 모듈로 통합 
- HC12,RFM69 등 무선 모듈 통신 기능을 추가 
```



소개
--------------
농장에 설치된 비트모스(BitMoss)와 연결되어 전송되는 데이터를 타이니파머 서버로 전달합니다.

인터넷과의 연결로 클라우드로 모아진 데이터를 전송하고 제어 명령을 받아 비트모스를 제어합니다.

간단한 설정으로 곧바로 농장에 적용 가능합니다.



설치 
--------------
설치를 위해서는 위의 OS 이미지파일을 바로 사용하거나 기존의 라즈베리파이 OS를 설치 후 아래 지시사항에 따라 개별 설치 하여도 됩니다.

(2018.1월 현재 아래 설치 내용은 유효하지 않습니다. 참고만 하세요. 최신 img파일 다운로드하여 설치를 권장합니다.)

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





