<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath">${pageContext.request.contextPath }</c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- global css -->	
<link rel="stylesheet" href="${cpath }/mymap/css/mymap.css">
<!-- jqueryCDN -->
<script  src="https://code.jquery.com/jquery-3.5.1.min.js"  integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="  crossorigin="anonymous"></script>
<style type="text/css">
		.erase {width: auto; height: auto;}

	.sido {
		width: auto;
		height: 30px;
		padding-left: 10px;
		padding-right: 10px;
		background: rgb(67, 77, 104);
		border: 2px solid rgb(67, 77, 104);
		border-radius: 30px;
		color: white;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.mark {
	border-radius:10px; border: 1px solid blue; color: white; font-size: 14px; width: 30px; height: 30px; background: blue
	}
	.circle {
	border-radius:50%; border: 1px solid aqua; color: white; font-size: 24px; width: 100px; height: 100px; background: aqua; display: flex; align-items: center; justify-content: center;
	}
</style>
</head>
<body>
	<p style="margin-top: -12px">
		<em class="link"> <a href="/web/documentation/#MapTypeId"
			target="_blank">지도 타입을 보시려면 여기를 클릭하세요!</a>
		</em>
	</p>
	<div id="map" style="width: 800px; height: 500px; margin: 0 auto"></div>
	<p id="message"></p>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=683cef37c8e822b967d6997468818ca4"></script>
	<script>
	
	let data = [
			[33.450701, 126.570667, 'A'],
			[33.350701, 126.170667, 'B'],
			[33.550701, 126.370667, 'C'],
			[33.250701, 126.270667, 'D'],
			[33.250701, 126.170667, 'E'],
			[33.450701, 126.370667, 'F'],
			[33.440701, 126.560667, 'G'],
			[33.450701, 126.460667, 'H'],
			[33.460701, 126.560667, 'I'],
			[33.440701, 126.570667, 'G'],
			[33.455701, 126.563667, 'I'],
		]	
	
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
// 			center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
			center : new kakao.maps.LatLng(35.202582, 129.056756), // 지도의 중심좌표
			level : 6
		// 지도의 확대 레벨
		};

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	
		// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
		var mapTypeControl = new kakao.maps.MapTypeControl();

		// 지도 타입 컨트롤을 지도에 표시합니다
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
		
		getInfo();
		
		function getInfo() {
			// 지도의 현재 중심좌표를 얻어옵니다 
			var center = map.getCenter();
			// 지도의 현재 레벨을 얻어옵니다
			var level = map.getLevel();
			
			switch (level) {
			case 5:
				underfive();
				break;
			case 6:
			case 7:
			case 8:
			case 9:
				overfive();
				break;
			case 10:
			case 11:
				sidoLevel();
				break;
			case 12:
			case 13:
			case 14:
				map.setLevel(11);
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
		
	// 지도 레벨이 바뀔 때마다 이벤트
	kakao.maps.event.addListener(map, 'zoom_changed', getInfo);
	// 지도 움직일 때마다 이벤트
	kakao.maps.event.addListener(map, 'dragend', getInfo);        
	
	
	overfive();
	
	function overfive() {
	  $('.erase').parent().remove();
		
  	  for(i = 0; i < data.length; i++) {
  	 		let content = '<div class="erase"><div class="mark">' + data[i][2] +'</div></div>';
 		   	    	
			// 커스텀 오버레이가 표시될 위치입니다 
			let position = new kakao.maps.LatLng(data[i][0], data[i][1]);  

			// 커스텀 오버레이를 생성합니다
			let customOverlay = new kakao.maps.CustomOverlay({
		   	 position: position,
		   	 content: content,
	    		xAnchor: 0.3,
	   			 yAnchor: 0.91
			});
		
			// 커스텀 오버레이를 지도에 표시합니다
			customOverlay.setMap(map);
// 			globaloverlay.push(customOverlay);
    	}
	}
	
	function underfive() {
		$('.erase').parent().remove();
		
		let bounds = map.getBounds();
		let swLatLng = bounds.getSouthWest();		// 남서
		let neLatLng = bounds.getNorthEast();		// 북동
		let count = 0;

	  	for(i = 0; i < data.length; i++) {
// 			console.log('중심 : ', map.getCenter());
// 	  		console.log('data[0][1] : ', data[i][1]);
// 	  		console.log('swLatLng[1] : ', swLatLng.La);
// 	  		console.log('neLatLng[1] : ', neLatLng.La);
// 	  		console.log('data[0][0] : ', data[i][0]);
// 	  		console.log('swLatLng[0] : ', swLatLng.Ma);
// 	  		console.log('neLatLng[0] : ', neLatLng.Ma);
	  		
	  		if(data[i][0] > swLatLng.Ma && data[i][0] < neLatLng.Ma) {
	  			if(data[i][1] > swLatLng.La && data[i][1] < neLatLng.La) {
			  		count++;
	  			}
	  		}
	  	}
	  	
	  	if (count == 0)
	  		return false;
	  	
		let content1 = '<div class="erase"><div class="circle">' + count +'</div></div>';
	    let center1 = map.getCenter();	
		// 커스텀 오버레이가 표시될 위치입니다 
// 		let position = new kakao.maps.LatLng(center1[0], center1[1]);  

		// 커스텀 오버레이를 생성합니다
		let customOverlay1 = new kakao.maps.CustomOverlay({
	   	 position: center1,
	   	 content: content1,
    		xAnchor: 0.3,
   			 yAnchor: 0.91
		});
	
		// 커스텀 오버레이를 지도에 표시합니다
		customOverlay1.setMap(map);
	}
	
	function sidoLevel() {
		$('.erase').parent().remove();
		
		// define		: Korean_1985_Korea_Central_Belt	-> TM
		// projection	: GCS_WGS_1984						-> WGS
		let sidoCenter = [
			['서울특별시',126.989704304000043,37.554652018000070],
			['부산광역시',129.056755798000040,35.202582395000036],
			['대구광역시',128.563210852000111,35.832479974000080],
			['인천광역시',126.379741421000062,37.581222317000027],
			['광주광역시',126.833350815000017,35.158504522000044],
			['대전광역시',127.391941359000043,36.342568954000058],
			['울산광역시',129.236540311000113,35.556393074000027],
			['세종특별자치시',127.256688456000006,36.563423479000051],
			['경기도',127.176049491000072,37.337718695000081],
			['강원도',128.298985815000037,37.727934259000051],
			['충청북도',127.828405814000007,36.740672952000068],
			['충청남도',126.845523122000031,36.532614624000075],
			['전라북도',127.138558927000076,35.718709316000059],
			['전라남도',126.895755980000104,34.876114237000024],
			['경상북도',128.746789721000027,36.350308934000054],
			['경상남도',128.259754123000107,35.325284010000075],
			['제주특별자치도',126.551568295000038,33.389842603000034],
		];
		
	  	  for(i = 0; i < sidoCenter.length; i++) {
			 	let sido_content = '<div class="erase"><div class="sido">' + sidoCenter[i][0] +'</div></div>';
	 		   	    	
				// 커스텀 오버레이가 표시될 위치입니다 
				let sido_position = new kakao.maps.LatLng(sidoCenter[i][2], sidoCenter[i][1]);  

				// 커스텀 오버레이를 생성합니다
				let sido_Overlay = new kakao.maps.CustomOverlay({
			   	 position: sido_position,
			   	 content: sido_content,
		    		xAnchor: 0.3,
		   			yAnchor: 0.91
				});
			
				// 커스텀 오버레이를 지도에 표시합니다
				sido_Overlay.setMap(map);
	    	}
	}
	
	$.getJSON("mymap/json/sidogeoJSON.geojson", function(geojson) {
		let sido_datas = geojson.features;
		let sido_coordinates = [];
		let sido_nm = "";
		
		console.log('sido_datas : ', sido_datas);
		
		$.each(sido_datas, function(index, val) {
			sido_coordinates.geometry,coordinates;
			sido_nm = val.preperties.SIGUNGU_NM;
			
			console.log('sido_nm : ', sido_nm);
		})
	})
	</script>
</body>
</html>