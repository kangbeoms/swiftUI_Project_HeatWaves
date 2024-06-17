"""
author:
Description: Python의 Ai 예측값 보내기
http://127.0.0.1:5000/seal?co2=13000
year=2024, carbon=12000, temp=1.2이산화탄소, 해수면편차 다항회귀 완료!

터미널에서 post로 보내는 방법
curl -X POST http://127.0.0.1:5000/seal2 -H "Content-Type: application/json" -d '{"year": 2024, "carbon": 12000, "temp": 1.18}'

http://127.0.0.1:5000/seal5?year=2024&carbon=12000
get으로 받는 방법.
"""
from flask import Flask, request, jsonify
import joblib
import os

app = Flask(__name__)

# 현재 파일의 경로를 기준으로 모델 파일의 경로 설정
model_file = os.path.join(os.path.dirname(__file__), 'polynomial_regression_model.pkl')
poly_file = os.path.join(os.path.dirname(__file__), 'polynomial_features.pkl')
scaler_file = os.path.join(os.path.dirname(__file__), 'scaler.pkl')

# 모델과 PolynomialFeatures 객체 및 스케일러를 불러오기
model = joblib.load(model_file)
poly = joblib.load(poly_file)
scaler = joblib.load(scaler_file)

# 예측 함수
def predict_sealevel(year, carbon):
    new_data = [[year, carbon]]
    new_data_scaled = scaler.transform(new_data)
    new_data_poly = poly.transform(new_data_scaled)
    prediction = model.predict(new_data_poly)
    return prediction[0, 0], prediction[0, 1]  # 해수면 예측값과 온도 예측값 반환

# 예측 API 엔드포인트 (POST 요청)
@app.route("/seal2", methods=["POST"])
def predict_post():
    data = request.get_json(force=True)
    year = data['year']
    carbon = data['carbon']
    sealevel_prediction, temp_prediction = predict_sealevel(year, carbon)
    return jsonify({'sealevel_prediction': sealevel_prediction, 'temp_prediction': temp_prediction})

# GET 요청을 처리하는 엔드포인트
@app.route('/seal5', methods=['GET'])
def predict_get():
    year = float(request.args.get('year'))
    carbon = float(request.args.get('carbon'))
    sealevel_prediction, temp_prediction = predict_sealevel(year, carbon)
    return jsonify({'sealevel_prediction': sealevel_prediction, 'temp_prediction': temp_prediction})

@app.route("/seal3")
def iris2():
    return "do it!TEST!"

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)
