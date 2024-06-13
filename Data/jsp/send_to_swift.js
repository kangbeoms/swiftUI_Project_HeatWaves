

document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('tooltipForm');
    
    form.addEventListener('submit', function(event) {
        event.preventDefault();  // 폼의 기본 제출 동작을 막습니다.

        // 폼 데이터 수집
        var formData = new FormData(form);
        var data = {};
        formData.forEach((value, key) => {
            data[key] = value;
            print("가져온 밸류값",value)
        });

        // Swift로 메시지 전송
        window.webkit.messageHandlers.serverEvent.postMessage(data);
    });
});
