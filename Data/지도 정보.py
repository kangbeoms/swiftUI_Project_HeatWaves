# -*- coding: utf-8 -*-
"""
저자:
설명: 1.database에 있는 랜드마크 이름,위도,경도,해발고도,건물 높이를 불러온다.
     2.제작한 선형회귀모델을 사용 get요청으로 예측값을 보낸다.
"""
import branca
from flask import Flask, jsonify, render_template, request,current_app
import json
import joblib
import pymysql
import folium
from joblib import dump, load
from sklearn.discriminant_analysis import StandardScaler
import os

from folium.plugins import MousePosition
from folium.plugins import Search
from folium.plugins import FloatImage

from PIL import Image

from jinja2 import Environment, FileSystemLoader
app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False #for utf8

template_dir = os.path.abspath(os.path.dirname(__file__))  # 현재 파일의 절대 경로
env = Environment(loader=FileSystemLoader(template_dir))
template = env.get_template('jsp/tooltipList.html')
template_gojsp = env.get_template('jsp/goSwift.jsp')

@app.route("/insert")
def insert():
        
        landname = request.args.get("landname")
        lat = request.args.get("lat")
        lng = request.args.get("lng")
        sealevel = request.args.get("sealevel")
        height = request.args.get("height")
        location = request.args.get("location")
        image = request.args.get("image")

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
        sql = "insert into sealevel(landname,lat,lng,sealevel,height,location,image) values (%s,%s,%s,%s,%s,%s,%s)"
        curs.execute(sql,(landname,lat,lng,sealevel,height,location,image))
        conn.commit()
        conn.close()

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
   #print(rows)

    result = json.dumps(rows, ensure_ascii=False).encode('utf8')

    return result

# 선형회귀모델 
@app.route('/getpred')
def sea():
    datalist = []
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

    #print(inputdata)
    scaled_data = scale.transform(inputdata)
    pre = clf.predict(scaled_data)
    #print(pre)
    pre_int = list(map(int, pre))
    return {'result' : pre_int}

@app.route("/test")
def iris2():
    #print(os.getcwd())
    return '<h1>테스트 서버</h1><br><h2>테스트 서버</h2>'

@app.route("/showmap",methods=['GET','POST'])
def mapview():
    
    # 대한민국 지도
    korea_map = folium.Map(
    location=[36.5, 127],
    zoom_start= 7,

    )
    korea_map.fit_bounds([[33, 124.6], [38.6, 131.9]])

    savedata = json.loads(select())
    file_path = os.path.abspath(f"{current_app.root_path}/jsp/tooltipList.html")

    with open(file_path, "r", encoding='utf-8') as file:
        html_content = file.read()

    for i in savedata:
        folium.IFrame(html=html_content, width=500, height=500).add_to(korea_map)
        html_content = template.render(name= i[0], height= i[3],imagepath=i[0])

        folium.Marker(
            [i[1],i[2]],
            popup=html_content,
            tooltip=i[0],
            fill=True,
            lazy=True,
            ).add_to(korea_map)

    #folium.LayerControl().add_to(korea_map)
    # 레이어 사용
    #folium.TileLayer(show=False).add_to(korea_map)

    # GeoJSON 파일 열기
    with open(f"{current_app.root_path}/json/korea_map.json", "r") as f:
        geojson_data = json.load(f)

    style_function = lambda feature: {
        #'fillColor': 'white',  # 예시 채우기 색상
        'color': 'black',  # 경계선 색상
        'weight': 3,  # 경계선 굵기 (얇게 설정)
        'fillOpacity': 0.1,  # 채우기 불투명도
    }

    # GeoJSON 데이터를 폴리움 객체로 변환하여 맵에 추가
    ser = folium.GeoJson(   
        geojson_data,
        name="geojson",
        style_function=style_function
    ).add_to(korea_map)
    MousePosition().add_to(korea_map)

    Search(
        layer=ser,
        geom_type="Polygon",
        placeholder="지역 검색",
        collapsed=False,
        search_label='CTP_KOR_NM',
        weight=10,
        search_zoom= 10

    ).add_to(korea_map)

    url = (" https://raw.githubusercontent.com/ocefpaf/secoora_assets_map/"
        "a250729bbcf2ddd12f46912d36c33f7539131bec/secoora_icons/rose.png")
    FloatImage(url, bottom=65, left=80).add_to(korea_map)

    css = """
    <style>
        .leaflet-control-search {
            width: 250px;
        }
        .leaflet-control-search input {
            width: 200px;
        }
    </style>
    """

    # 현재 나의 위치 표시
    folium.plugins.LocateControl(auto_start=False,setView=False,drawCircle=False).add_to(korea_map)

    korea_map.get_root().html.add_child(folium.Element(css))

    return korea_map.get_root().render()

# 예측페이지로 이동 루트
@app.route("/goSwiftfile",methods=['GET','POST'])
def goswift():
    name = request.args.get('name')
    #swift_get = template_gojsp.render(name= name)
    print("가져온이름",name)

    return {'result' : name}


if __name__ == "__main__":
    app.run(host="127.0.0.1",port=5000, debug=True)


