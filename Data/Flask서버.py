# -*- coding: utf-8 -*-
"""
저자:
설명: 1.database에 있는 랜드마크 이름,위도,경도,해발고도,건물 높이를 불러온다.
     2.제작한 선형회귀모델을 사용 get요청으로받은 파라메터로 예측값을 보낸다.
     3.크롤링후 데이터를 디비에 넣는다.
     4.폴리움 지도를 서버에 추가한다.
"""
#MARK:import 모음
# 파이썬 서버 구동
from flask import Flask, jsonify, render_template, request,current_app
# json으로 데이터 송신
import json
import joblib
# sql 접근
import pymysql
from sqlalchemy import create_engine
# 파이썬 맵 사용
import folium
# json파일 불러오기
from joblib import dump, load
#회귀모델 스케일링
from sklearn.discriminant_analysis import StandardScaler
# os 명령어 사용
import os
# 폴리움 지도 옵션 
from folium.plugins import MousePosition
from folium.plugins import Search
from folium.plugins import FloatImage

# html 파일 실행
from jinja2 import Environment, FileSystemLoader

# 데이터프레임 생성
import pandas as pd

# 셀레니움 사용
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By

# 크롤링 시 시간 텀 주기
import time

import numpy as np

from folium.elements import *
from folium.utilities import JsCode
from folium.plugins import Realtime
#MARK:Flask 서버 시작 설정
# 플라스크 서버 지정
app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False #for utf8

template_dir = os.path.abspath(os.path.dirname(__file__))  # 현재 파일의 절대 경로

# html에 파라미터를 주기위해 jinja2 라이브러리 사용
env = Environment(loader=FileSystemLoader(template_dir))
template = env.get_template('jsp/tooltipList.html')
#MARK: MYSQL 서버 설정

#MARK: 폴리움 맵 마커 DB SELECT
# 지도에 마커를 표시하기 위한 데이터베이스 진입
@app.route("/select")
def select():
        # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()
    # sql 문장
    sql = "select * from mappoint"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()

    result = json.dumps(rows, ensure_ascii=False).encode('utf8')

    return result

#MARK: 해수면 예측값 회귀모델 전송
# 선형회귀모델 예측값 보내기
@app.route('/getpred')
def sea():
    datalist = []
    # 7개의 컬럼 알규먼트 받기 
    datalist.append(float(request.args.get("Year")))
    datalist.append(float(request.args.get("co2")))
    datalist.append(float(request.args.get("Population")))
    datalist.append(float(request.args.get("Thickness")))
    datalist.append(float(request.args.get("북극해빙면적평균")))
    datalist.append(float(request.args.get("해상평균온도")))
    datalist.append(float(request.args.get("지구평균온도")))

    inputdata = [datalist]  
    # 스케일된 train_input 과 모델을 불러옴
    scale, clf = joblib.load(f"{current_app.root_path}/선형회귀모델/model_with_scaler.sea")

    scaled_data = scale.transform(inputdata)
    pre = clf.predict(scaled_data)

    pre_int = list(map(int, pre))
    return {'result' : pre_int}
#MARK: 서버 테스트
# 서버 테스트용
@app.route("/test")
def iris2():

    return '<h1>테스트 서버</h1><br><h2>테스트 서버</h2>'
#MARK: 폴리움 지도 설정
# 지도 보여주기
@app.route("/showmap",methods=['GET','POST'])
def mapview():
            # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()
    
    # 대한민국 지도
    korea_map = folium.Map(
    location=[36, 127.7],
    zoom_start= 7,
    
    )

    korea_map.zoom_start = 7
    savedata = json.loads(select())

    my_js = """
    $(document).ready(function() {
        $('#gogogo').click(function() {
           var input = document.getElementById('name');
            alert('버튼이 클릭되었습니다.',input);
            
        });
    });  
"""
    getitem = JsCode("""$(document).ready(function() {
        $('#gogogo').click(function() {
           var input = document.getElementById('name');
            alert('버튼이 클릭되었습니다.',input);
            
        });
    }); """)
   
    
  
    #korea_map.get_root().html.add_child(folium.JavascriptLink(f'/{current_app.root_path}/jsp/func.js'))
    # html파일 읽어오기
    file_path = os.path.abspath(f"{current_app.root_path}/jsp/tooltipList.html")
    with open(file_path, "r", encoding='utf-8') as file:
        html_content = file.read()

    for i in savedata:

        folium.IFrame(html=html_content, width=3500, height=500).add_to(korea_map)
        # html파일에 파라미터를 부여해 정보 보이기
        html_content = template.render(name= i[0], height= i[3],imagepath=i[0])

        # 미리 지정한 위치에 마커를 표시하고 클릭 시 html파일로 이동
        folium.Marker(
            [i[1],i[2]],
            popup=html_content,
            #tooltip=i[0],
            fill=True,
            lazy=True,
            ).add_to(korea_map)
    
    #marker.popup.add_child(getitem)

    # GeoJSON 파일 열기
    with open(f"{current_app.root_path}/json/korea_map.json", "r") as f:
        geojson_data = json.load(f)

    style_function = lambda feature: {
        #'fillColor': 'white',  # 예시 채우기 색상
        'color': 'black',  # 경계선 색상
        'weight': 2,  # 경계선 굵기 (얇게 설정)
        'fillOpacity': 0.1,  # 채우기 불투명도
    }

    #GeoJSON 데이터를 폴리움 객체로 변환하여 맵에 추가
    folium.GeoJson(   
        geojson_data,
        name="geojson",
        style_function=style_function
    ).add_to(korea_map)

    # 모바일 환경과 맞지않아 사용안함
    MousePosition().add_to(korea_map)
    korea_map.get_root().script.add_child(Element(my_js))
    return korea_map.get_root().render()
#korea_map._repr_html_()korea_map.get_root().render()

#MARK: 지도 마커 클릭시 값 보내기
@app.route("/goSwiftfile",methods=['GET','POST'])
def goswift():

        # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()

    name = request.args.get('name')

    # sql 문장
    sql = "select * from mappoint where landname=%s"
    curs.execute(sql,(name))
    curs.fetchall()

    conn.close()
    curs.close()

    return {"result" : name}

#MARK: 네이버 뉴스 크롤링,DB INSERT
@app.route("/getnews")
def startup():

            # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()

    # 전에있던 리스트 삭제
    sql = "delete from navernews"
    curs.execute(sql)
    conn.commit()

    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--headless")
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
    driver.get("https://news.naver.com/breakingnews/section/103/248")
    title = []
    publish = []
    link = []
    image = []

    try:
        for num in range(1,5):

            newstitle = driver.find_element(By.XPATH, f'//*[@id="newsct"]/div[2]/div/div[1]/div[1]/ul/li[{num}]/div/div/div[2]/a/strong') 
            newspublish = driver.find_element(By.XPATH, f'//*[@id="newsct"]/div[2]/div/div[1]/div[1]/ul/li[{num}]/div/div/div[2]/div[2]/div[1]/div[1]') 
            newsimage = driver.find_element(By.XPATH, f'//*[@id="newsct"]/div[2]/div/div[1]/div[1]/ul/li[{num}]/div/div/div[1]/div/a/img') 
            newslink = driver.find_element(By.XPATH, f'//*[@id="newsct"]/div[2]/div/div[1]/div[1]/ul/li[{num}]/div/div/div[1]/div/a') 
                
            title.append(newstitle.text)
            publish.append(newspublish.text)
            image.append( newsimage.get_attribute('src'))
            link.append(newslink.get_attribute('href'))
            time.sleep(0.3)
        data_list = []
        for j in range(4):
            # sql 문장
            sql = "insert into navernews (title,publish,image,link) values (%s,%s,%s,%s)"
            curs.execute(sql,(title[j],publish[j],image[j],link[j]))
            conn.commit()

            data_dict = {
            'title': title[j],
            'publish': publish[j],
            'image': image[j],
            'link': link[j]
            }
            data_list.append(data_dict)
        
    except Exception as e:
        print(f"에러 발생: {e}")
        if 'conn' in locals():
            conn.rollback()  # 롤백 수행
            conn.close()
            curs.close()
    
    return json.dumps(data_list, ensure_ascii=False).encode('utf8')

#MARK: 유튜브 크롤링,DB INSERT
@app.route("/getyou")
def goyou():

        # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()

    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--headless")
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
    driver.get("https://www.youtube.com/results?search_query=해수면")

    # 전에있던 리스트 삭제
    sql = "delete from youtubevidio"
    curs.execute(sql)
    conn.commit()

    youlink = []
    youimage = []

    try:
        for i in range(1,5):
            if i == 4:
                driver.execute_script("window.scrollBy(0, 600);")
                time.sleep(0.5)  

            video_renderer = driver.find_element(By.XPATH, f"(//ytd-video-renderer)[{i}]")
            yes = video_renderer.find_element(By.CSS_SELECTOR, "a#thumbnail yt-image img")
            no = video_renderer.find_element(By.CSS_SELECTOR, "a#thumbnail")
            youimage.append(yes.get_attribute('src'))
            youlink.append(no.get_attribute('href'))

        data_list2 = []
        for n in range(4):
            # sql 문장
            print("넣을 이미지 이름" ,youimage[n])
            sql = "insert into youtubevidio (link,image) values (%s,%s)"
            curs.execute(sql,(youlink[n],youimage[n]))

            conn.commit()
            #res = curs.fetchall()
            
            data_dict = {
            'link': youlink[n],
            'image': youimage[n]}

            data_list2.append(data_dict)

    except Exception as e:
        print(f"에러 발생: {e}")
    finally:
        curs.close()
        conn.close()
        driver.quit()

    return json.dumps(data_list2, ensure_ascii=False).encode('utf8')

@app.route("/swiftnews")
def asdf():

        # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()

    sql = "select * from navernews"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    dlist = []
    for row in rows[:4]: 
        data_dict = {
        "title": row[0],
        "publish": row[1],
        "image": row[2],
        "link": row[3]
        }
        dlist.append(data_dict)

    result = json.dumps(dlist, ensure_ascii=False).encode('utf8')

    return result

@app.route("/swiftyou")
def fd():

            # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
        # Connection으로부터 Cursor 생성
    curs = conn.cursor()

    sql = "select * from youtubevidio"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    dlist = []

    for link, image in rows[:4]:
        data_dict = {
            "link": link,
            "image": image
        }
        dlist.append(data_dict)

    # 최종 결과 JSON 변환
    result = json.dumps(dlist, ensure_ascii=False).encode('utf8')

    return result

    
@app.route("/inDataFrame")
def godata():

    engine = create_engine("mysql+pymysql://root:qwer1234@127.0.0.1:3306/sealevel")

    
    data_frame = pd.read_csv("Data/file/data_finalver.csv")
    data_frame.to_sql(name='chartdata', con=engine, if_exists='append', index=False)

    return "okok"

@app.route("/getDataFrame")
def getsum():
    # MySql Connection
    conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='qwer1234',
            db='sealevel',
            charset='utf8'
        )
    
    # Connection으로부터 Cursor 생성
    curs = conn.cursor()

    sql = "select * from chartdata"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    dlist = []

    for row in rows: 
        data_dict = {
        "Year": row[0],
        "sealevel": row[1],
        "co2": row[2],
        "Population" : row[3],
        "Thickness": row[4],
        "북극해빙면적평균": row[5],
        "해상평균온도": row[6],
        "지구평균온도": row[7]
        }
        dlist.append(data_dict)

    # 최종 결과 JSON 변환
    result = json.dumps(dlist, ensure_ascii=False).encode('utf8')

    return result


if __name__ == "__main__":
    app.run(host="127.0.0.1",port=5000, debug=True)

