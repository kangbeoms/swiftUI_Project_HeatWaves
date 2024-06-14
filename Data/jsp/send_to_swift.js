

document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('tooltipForm');
    var button = document.getElementById('gogogo');

    button.addEventListener('click', function(event) {
        event.preventDefault();  //기본동작 막기

        // 폼 데이터 수집
        var nameValue = document.querySelector('input[name="name"]').value;

        // Swift로 메시지 전송
        window.webkit.messageHandlers.serverEvent.postMessage(nameValue);
    });
});


// $(document).ready(function() {

// 	$("#gogogo").click(function() {
		
// 		$.ajax({
// 			type: "POST",
// 			url: "purchaseCart", 

// 			success: function(response) {
				
// 			},
// 			error : function(error){
				
// 			}//ERROR END
// 		})//AJAX END
// 	})//CLICKED END
// })//DOCUMENT READY EN