# -*- coding: utf-8 -*-
"""
저자:
설명: 1.database에 있는 랜드마크 이름,위도,경도,해발고도,건물 높이를 불러온다.
     2.제작한 선형회귀모델을 사용 get요청으로 예측값을 보낸다.
"""
# 파이썬 서버 구동
from flask import Flask, jsonify, render_template, request,current_app
# json으로 데이터 송신
import json
import joblib
# sql 접근
import pymysql
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

# 플라스크 서버 지정
app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False #for utf8

template_dir = os.path.abspath(os.path.dirname(__file__))  # 현재 파일의 절대 경로

# html에 파라미터를 주기위해 jinja2 라이브러리 사용
env = Environment(loader=FileSystemLoader(template_dir))
template = env.get_template('jsp/tooltipList.html')

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
    scale, clf = joblib.load(f"{current_app.root_path}/model_with_scaler.sea")

    scaled_data = scale.transform(inputdata)
    pre = clf.predict(scaled_data)

    pre_int = list(map(int, pre))
    return {'result' : pre_int}

# 서버 테스트용
@app.route("/test")
def iris2():
    #print(os.getcwd())
    return '<h1>테스트 서버</h1><br><h2>테스트 서버</h2>'

# 지도 보여주기
@app.route("/showmap",methods=['GET','POST'])
def mapview():
    
    # 대한민국 지도
    korea_map = folium.Map(
    location=[36, 127.7],
    zoom_start= 7,
    
    )
    #korea_map.fit_bounds([[33, 124.0], [38.6, 131.9]])
    korea_map.zoom_start = 7
    savedata = json.loads(select())

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
            tooltip=i[0],
            fill=True,
            lazy=True,
            ).add_to(korea_map)

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


    return korea_map.get_root().render()

@app.route("/goSwiftfile",methods=['GET','POST'])
def goswift():

    name = request.args.get('name')

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
    sql = "select * from mappoint where landname=%s"
    curs.execute(sql,(name))
    rows = curs.fetchall()
    conn.close()

    # response = jsonify({'result': name})
    # response.headers.add('Content-Type', 'application/json; charset=utf-8')

    return {"result" : rows}

    # return json.dumps(rows, ensure_ascii=False).encode('utf8')

if __name__ == "__main__":
    app.run(host="127.0.0.1",port=5000, debug=True)

