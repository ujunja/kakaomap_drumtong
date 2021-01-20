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
</head>
<body>
	<p style="margin-top: -12px">
		<em class="link"> <a href="/web/documentation/#MapTypeId"
			target="_blank">지도 타입을 보시려면 여기를 클릭하세요!</a>
		</em>
	</p>
	<div class="map_wrap">
		<div id="map" style="width: 100%; height: 500px;"></div>
		 <div class="hAddr">
   	     <span class="title">지도중심기준 행정동 주소정보</span>
   	     <span id="centerAddr"></span>
	   	</div>
	</div>
	<p id="message"></p>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=683cef37c8e822b967d6997468818ca4&libraries=services"></script>
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
		
		var emd_switch = false;									// 읍면동_폴리곤이 활성화되었으면 더이상 작동 못하게 하는 안전장치 
		polygonoverlay = new kakao.maps.CustomOverlay({}),		// 읍면동_폴리곤의 오버레이
		infowindow = new kakao.maps.InfoWindow({removable: true});

		var polygons=[]; 		// 단일 읍면동 폴리곤을 담고 있는 전역변수 -> 이것을 이용해서 읍면동 폴리곤을 제거할 것이다
			

		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	
		// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
		var mapTypeControl = new kakao.maps.MapTypeControl();
		
		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();
		
		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);

		// 지도 타입 컨트롤을 지도에 표시합니다
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
		
		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
		    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		    console.log('행정동 주소 : ' , $('#centerAddr').html());
		});

		var callback = function(result, status){
		    if(status === daum.maps.services.Status.OK){
		        alert("지역명 : " + result[0].address_name);
		    }
		};

		function searchAddrFromCoords(coords, callback) {
		    // 좌표로 행정동 주소 정보를 요청합니다
		    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
		}
		
		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		 searchDetailAddrFromCoords(map.getCenter(), function(result, status) {
			 console.log('지번주소 : ', result[0].address.address_name.split(' ')[2] );
		 })
		
		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
		    if (status === kakao.maps.services.Status.OK) {
		        var infoDiv = document.getElementById('centerAddr');

		        for(var i = 0; i < result.length; i++) {
		            // 행정동의 region_type 값은 'H' 이므로
		            if (result[i].region_type === 'H') {
		                infoDiv.innerHTML = result[i].address_name;
		                break;
		            }
		        }
		    }    
		}
		
		window.onload = function() {
			getInfo();	// 윈도우즈 활성화 될때마다 지도 처음 레벨은 6에 맞는 부분을 활성화시켜줌
		} 
		
		// 지도 레벨이 바뀔 때마다 이벤트
		kakao.maps.event.addListener(map, 'zoom_changed', getInfo);
		// 지도 움직일 때마다 이벤트
		kakao.maps.event.addListener(map, 'dragend', getInfo);        
		
		function getInfo() {
			// 지도의 현재 중심좌표를 얻어옵니다 
			var center = map.getCenter();
			// 지도의 현재 레벨을 얻어옵니다
			var level = map.getLevel();
			
			switch (level) {
			case 1:	case 2:	case 3:	case 4:
				underfive();
				 deleteEmd()
				break;
			case 5:	case 6:	case 7:
				emdLevel();
				break;
			case 8:
			case 9:
				sigunguLevel();
				deleteEmd()
				break;
			case 10:
			case 11:
				sidoLevel();
				 deleteEmd()
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
		

	
	// 읍면동 레벨 - 오픈마켓에서 다운받아 좌표변환(WGS 84 : EPGS 4326) 시킨 폴리곤을 나타내줌
 	function emdLevel() {
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
  	  
		console.log('250m 시작!!!');
		if (!emd_switch) {
			$.getJSON("mymap/json/EMD250geoJson.geojson", function(geojson) {
				let emd_datas = geojson.features;
				let emd_coordinate = [];
				let emd_nm = "";
			
				console.log('emd_datas : ', emd_datas);
			
				$.each(emd_datas, function(index, item) {
					emd_coordinates = item.geometry.coordinates;
					emd_nm = item.properties.EMD_KOR_NM;
					emddisplayArea(emd_coordinates, emd_nm);
				});
			});
		}
	}
	
	function underfive() {
		$('.erase').parent().remove();
		
		let bounds = map.getBounds();
		let swLatLng = bounds.getSouthWest();		// 남서
		let neLatLng = bounds.getNorthEast();		// 북동
		let count = 0;

	  	for(i = 0; i < data.length; i++) {
	  		
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
	
	function sigunguLevel() {
		$('.erase').parent().remove();
		let sigungu = ${sigungu };
		
	  	  for(i = 0; i < sigungu.length; i++) {
			 	let sigungu_content = '<div class="erase"><div class="sido">'
			 	+ (sigungu[i].sigungunm).substring(1, sigungu[i].sigungunm.length - 1) +'</div></div>';
	 		   	    	
				// 커스텀 오버레이가 표시될 위치입니다 
				let sigungu_position = new kakao.maps.LatLng(sigungu[i].pointy, sigungu[i].pointx);  
				// 커스텀 오버레이를 생성합니다
				let sigungu_Overlay = new kakao.maps.CustomOverlay({
			   	 position: sigungu_position,
			   	 content: sigungu_content,
		    		xAnchor: 0.3,
		   			yAnchor: 0.91
				});
			
				// 커스텀 오버레이를 지도에 표시합니다
				sigungu_Overlay.setMap(map);
	    	}
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
	

	
	// 읍면동 폴리곤 활성화
	function emddisplayArea(coordinates, name) {
		var emd_path = [];	// 
		var sigunguName = $('#centerAddr').html().split(' ');
// 		console.log('name : ', name);
		if(name != sigunguName[2])
			return false;
		
		$.each(coordinates[0][0], function(index1, coordinate) { //console.log(coordinates)를 확인해보면 보면 [0]번째에 배열이 주로 저장이 됨.  그래서 [0]번째 배열에서 꺼내줌.
			
			emd_path.push(new kakao.maps.LatLng(coordinate[1], coordinate[0])); //new daum.maps.LatLng가 없으면 인식을 못해서 path 배열에 추가
		
		});	  
		
		// 다각형을 생성합니다 
		var emd_polygon = new kakao.maps.Polygon({
				map : map, // 다각형을 표시할 지도 객체
				path : emd_path,
				strokeWeight : 2,
				strokeColor : '#004c80',
				strokeOpacity : 0.8,
				fillColor : '#fff',
				fillOpacity : 0.7
			});
		polygons.push(emd_polygon);	// 나중에 지도의 폴리곤들을 지우기 위해서 전역변수에 폴리곤 정보를 저장함
		
		// 다각형에 mouseover 이벤트를 등록하고 이벤트가 발생하면 폴리곤의 채움색을 변경합니다 
		// 지역명을 표시하는 커스텀오버레이를 지도위에 표시합니다
		kakao.maps.event.addListener(emd_polygon, 'mouseover', function(
				mouseEvent) {
				emd_polygon.setOptions({
				fillColor : '#09f'
			});

			// 	        polygonoverlay.setContent('<div class="area">' + area.name + '</div>');
			polygonoverlay.setContent('<div class="area">' + name
					+ '</div>');

			polygonoverlay.setPosition(mouseEvent.latLng);
			polygonoverlay.setMap(map);
		});

		// 다각형에 mousemove 이벤트를 등록하고 이벤트가 발생하면 커스텀 오버레이의 위치를 변경합니다 
		kakao.maps.event.addListener(emd_polygon, 'mousemove', function(
				mouseEvent) {

			polygonoverlay.setPosition(mouseEvent.latLng);
		});

		// 다각형에 mouseout 이벤트를 등록하고 이벤트가 발생하면 폴리곤의 채움색을 원래색으로 변경합니다
		// 커스텀 오버레이를 지도에서 제거합니다 
		kakao.maps.event.addListener(emd_polygon, 'mouseout', function() {
			emd_polygon.setOptions({
				fillColor : '#fff'
			});
			polygonoverlay.setMap(null);
		});

		// 다각형에 click 이벤트를 등록하고 이벤트가 발생하면 다각형의 이름과 면적을 인포윈도우에 표시합니다 
		kakao.maps.event.addListener(emd_polygon, 'click',
				function(mouseEvent) {
					var content = '<div class="info">'
							+ '   <div class="title">' + name + '</div>'
							+ '   <div class="size">총 면적 : 약 '
							+ Math.floor(emd_polygon.getArea())
							+ ' m<sup>2</sup></area>' + '</div>';

					infowindow.setContent(content);
					infowindow.setPosition(mouseEvent.latLng);
					infowindow.setMap(map);
				});
		
		emd_switch = true;		// 읍면동 폴리곤이 이미 그려졌으니 더이상 그리지 않도록 방지하는 안전장치 
	}
	
	function deleteEmd() {
		for(i = 0; i < polygons.length; i++) {
			polygons[i].setMap(null);		// 전역변수에 저장해준 읍면동 폴리곤을 삭제
		}
		polygonoverlay.setMap(null);
		infowindow.setMap(null);
		emd_switch = false;
	}
	</script>
</body>
</html>