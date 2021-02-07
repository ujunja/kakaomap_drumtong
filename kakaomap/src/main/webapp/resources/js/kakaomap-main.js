		window.onload = function() {
			getInfo();	// 윈도우즈 활성화 될때마다 지도 처음 레벨은 6에 맞는 부분을 활성화시켜줌
		}
		
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div

			mapOption = {
		 			center : new kakao.maps.LatLng(37.55102, 126.99023), // 지도의 중심좌표
					level : 7
				// 지도의 확대 레벨
				};
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		
		// HTML5의 geolocation으로 사용할 수 있는지 확인합니다
		// 현재 위치를 기반으로 맵의 중심을 결정한다
		if (navigator.geolocation) {
		    
		    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
		    navigator.geolocation.getCurrentPosition(function(position) {
		        const currentlat = position.coords.latitude; // 위도
		        const currentlon = position.coords.longitude; // 경도
		        
		        const currentPosition = new kakao.maps.LatLng(currentlat, currentlon); // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
		        map.setCenter(currentPosition);
		    });
		} 
		else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
			const currentPosition = new kakao.maps.LatLng(37.55102, 126.99023);
			map.setCenter(currentPosition);
		}
		
			function getInfo() {		// 레벨별로 지도 정보를 가져오는 함수
			// 지도의 현재 중심좌표를 얻어옵니다 
			var center = map.getCenter();
			// 지도의 현재 레벨을 얻어옵니다
			var level = map.getLevel();
			
			switch (level) {
			case 1:	case 2:	case 3:	case 4: 
				deleteShopMarkers();
				shopLevel();
				deleteEmd();
				break;
			case 5:	case 6:	case 7: 
				emdLevel();
				deleteShopMarkers();
				deleteEmd();
				break;
			case 8:	case 9:	
				sigunguLevel();
				deleteEmd();
				break;
			case 10: case 11:
  				sidoLevel();
				deleteEmd();
				break;
			case 12: case 13: case 14:
				map.setLevel(12);
				break;
			default:
				break;
			}
			
			// 지도타입을 얻어옵니다
			var mapTypeId = map.getMapTypeId();
			// 지도의 현재 영역을 얻어옵니다 
			var bounds = map.getBounds();
			// 영역의 남서쪽 좌표를 얻어옵니다 
			var swLatLng = bounds.getSouthWest();
			// 영역의 북동쪽 좌표를 얻어옵니다 
			var neLatLng = bounds.getNorthEast();
			// 영역정보를 문자열로 얻어옵니다. ((남,서), (북,동)) 형식입니다
			var boundsStr = bounds.toString();
		
			var message = '지도 중심좌표는 위도 ' + center.getLat() + ', <br>';
			message += '경도 ' + center.getLng() + ' 이고 <br>';
			message += '지도 레벨은 ' + level + ' 입니다 <br> <br>';
			message += '지도 타입은 ' + mapTypeId + ' 이고 <br> ';
			message += '지도의 남서쪽 좌표는 ' + swLatLng.getLat() + ', '
					+ swLatLng.getLng() + ' 이고 <br>';
			message += '북동쪽 좌표는 ' + neLatLng.getLat() + ', '
					+ neLatLng.getLng() + ' 입니다';
			
			document.getElementById('message').innerHTML = message;
			// 개발자도구를 통해 직접 message 내용을 확인해 보세요.
		}
		
		
	function setLevel9() {
		map.setLevel(9);
	}
	
	function setLevel7() {
		map.setLevel(7);
	}
		