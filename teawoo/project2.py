"""
author:
Description: Python의 Ai 예측값 보내기
http://127.0.0.1:5000/seal?co2=13000
이산화탄소 선형회귀 완료!
"""

from flask import Flask, jsonify, request, current_app
import joblib

app = Flask(__name__)

@app.route("/seal")
def sea():
    co2=float(request.args.get("co2"))
    datalist = [co2]

    clf = joblib.load(f"{current_app.root_path}/lr_sealevel.m3")
    pre = clf.predict([datalist])
    print(pre)
    # return jsonify({'result':pre[0][5]}) # for flutter
    # return jsonify([{'result':pre[0][5:]}]) # for swift, {} 형식 데이터 못 받음.
    return jsonify({'result':pre[0]}) # for wift

@app.route("/iris2")
def iris2():
    return "GGGG"


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)