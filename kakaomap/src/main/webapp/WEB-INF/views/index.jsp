<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath">${pageContext.request.contextPath }</c:set>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- global css -->
<link rel="stylesheet" href="${cpath }/mymap/css/mymap.css">
<!-- jqueryCDN -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"
	integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
	crossorigin="anonymous"></script>
<!-- Axios -->
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
</head>
<body>
	<span style="visibility: hidden;" id="sido-hidden"></span>
	<span style="visibility: hidden;" id="hidden"></span>
	<div
		style="width: 100%; height: 100px; background-color: #F0E68C; display: flex; justify-content: center; align-items: center;">
		<h1
			style="background-color: transparent; color: white; font-size: 24pt">
			LSWN's Kakao Map</h1>
	</div>
	<div class="map_wrap">
		<div id="map" style="width: 100%; height: 500px;"></div>
		<div class="hAddr">
			<span class="title">지도중심기준 행정동 주소정보</span> <span id="centerAddr"></span>
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
	
		var emdpkContainer = new Array();
	
		var markersContainer = new Array();	// 생성된 마커를 지워주기 위한 전역변수 저장공간
	 	var markersOverLays = new Array();
		
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
// 			center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
			center : new kakao.maps.LatLng(35.202582, 129.056756), // 지도의 중심좌표
			level : 10
		// 지도의 확대 레벨
		};

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		
		var emd_switch = false;									// 읍면동_폴리곤이 활성화되었으면 더이상 작동 못하게 하는 안전장치 
		polygonoverlay = new kakao.maps.CustomOverlay({}),		// 읍면동_폴리곤의 오버레이
		emdinfowindow = new kakao.maps.InfoWindow({removable: true});

		var polygons = []; 		// 단일 읍면동 폴리곤을 담고 있는 전역변수 -> 이것을 이용해서 읍면동 폴리곤을 제거할 것이다
		var polygonsMap = new Map();

		
		
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
			    callAddress();
		});

		function searchAddrFromCoords(coords, callback) {
		    // 좌표로 행정동 주소 정보를 요청합니다
		    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
		}
		
		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		function callAddress() {
		  	searchDetailAddrFromCoords(map.getCenter(), function(result, status) {
				$('#hidden').html(result[0].address.address_name.split(' ')[2]);
		 	})
		}
		
		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
		    if (status === kakao.maps.services.Status.OK) {
		        var infoDiv = document.getElementById('centerAddr');
				
		        for(var i = 0; i < result.length; i++) {
		            // 행정동의 region_type 값은 'H' 이므로
		            if (result[i].region_type === 'H') {
		            	// 좌측 상단에 행정동 주소 정보를 입력함
		                infoDiv.innerHTML = result[i].address_name;
		            	// id="sido-hidden" 태그에 행정동 시도 정보를 입력함
		            	// 이것을 이용하여 geoJson 을 종류별로 읽어올 수 있도록 한다
		                $('#sido-hidden').html(result[i].address_name.split(' ')[0]);
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
				deleteShopMarkers();
				shopLevel();
				deleteEmd();
				break;
			case 5:	case 6:	case 7: 
				emdLevel();
				deleteShopMarkers();
				deleteEmd();
				polygonsMap.clear();
				emdpkContainer.length = 0;
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

	
	
	function shopLevel() {	// 상점을 보여주는 레벨
		$('.erase').parent().remove();

		let count = 0;

// 	  	for(i = 0; i < data.length; i++) {
	  		
// 	  		if(data[i][0] > swLatLng.Ma && data[i][0] < neLatLng.Ma) {
// 	  			if(data[i][1] > swLatLng.La && data[i][1] < neLatLng.La) {
// 			  		count++;
// 	  			}
// 	  		}
// 	  	}
	  	
// 	  	if (count == 0)
// 	  		return false;
	  	
// 		let content1 = '<div class="erase"><div class="circle">' + count +'</div></div>';
// 	    let center1 = map.getCenter();	
// 		// 커스텀 오버레이가 표시될 위치입니다 
// // 		let position = new kakao.maps.LatLng(center1[0], center1[1]);  

// 		// 커스텀 오버레이를 생성합니다
// 		let customOverlay1 = new kakao.maps.CustomOverlay({
// 	   	 position: center1,
// 	   	 content: content1,
//     		xAnchor: 0.3,
//    			 yAnchor: 0.91
// 		});
	
// 		// 커스텀 오버레이를 지도에 표시합니다
// 		customOverlay1.setMap(map);

		shopAxios();

	}
	
	function shopAxios() {		// 상점 레벨 비동기
		const axiosPath = 'mymap/shopmap/rest/';
		const axPost = async() => {
		    await axios.post(axiosPath)
		    // 정상
				.then( (response) => {
		    const data = response.data;
		    let shopCenter = data;			// 반환 결과 불러오기
		    console.log('상점 지도 불러오기');
		    console.log(shopCenter);
		    
		    var markerImageSrc = 'mymap/img/laundry_marker.JPG';
			
			let bounds = map.getBounds();
			let swLatLng = bounds.getSouthWest();		// 남서
			let neLatLng = bounds.getNorthEast();		// 북동
			
		    for(i = 0; i < shopCenter.length; i++) {
		    	
		    	if(swLatLng.getLat() < shopCenter[i].latitude && swLatLng.getLng() < shopCenter[i].longitude) {
		    		if(neLatLng.getLat() > shopCenter[i].latitude && neLatLng.getLng() > shopCenter[i].longitude) {
		    	
				        let imageSize = new kakao.maps.Size(64, 69),
			            imageOptions = {   
			        		offset: new kakao.maps.Point(27, 69)
	        		    };
				        
				        console.log('마커 이벤트 : ' + shopCenter[i].brandnaming);
				        let markerContent = '<div class="customoverlay">' +
				        '    <span class="title">' + shopCenter[i].brandnaming + '</span>' +
				        '</div>';
	     
				        // 마커이미지와 마커를 생성합니다
	    			    let markerImage = createMarkerImage(markerImageSrc, imageSize, imageOptions);
	           			let shopmarker = createMarker(shopCenter[i].latitude, shopCenter[i].longitude , markerImage, markerContent);  
	           			shopmarker.setMap(map);
	          		 	markersContainer.push(shopmarker);	// 생성된 마커를 지워주기 위해서 전역변수로 선언된 객체에 저장함
	          		 	
	          		 	console.log('콘텐츠 : ' + shopmarker);
	          		 	
	          			let overposition = new kakao.maps.LatLng(shopCenter[i].latitude, shopCenter[i].longitude);
	        			// 커스텀 오버레이를 생성합니다
	        		 	var customOverlay = new kakao.maps.CustomOverlay({
	        		 	    map: map,
	        		 	    position: overposition,
	        		 	    content: markerContent,
	        		 	    yAnchor: 1,
	        		 	});
	        			
	        		 	markersOverLays.push(customOverlay);
	          		 	
	        		 	customOverlay.setVisible(false);
	        			
 	          		    kakao.maps.event.addListener(shopmarker, 'click', ClickListener(map, shopmarker, customOverlay));
// 	          		    kakao.maps.event.addListener(shopmarker, 'mouseover', makeOverListener(map, shopmarker, customOverlay));
// 	          		    kakao.maps.event.addListener(shopmarker, 'mouseout', makeOutListener(customOverlay));
		    		}
		    	}
		    }
		     })
		}
		return axPost();
	}
	
	function ClickListener(map, marker, overlay) {
		return function() {
			console.log('가시화상태 : ' + overlay.getVisible());
			if(overlay.getVisible() === true)
				overlay.setVisible(false);
			else 
				overlay.setVisible(true);
	    };
	}
	
// 	// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
// 	function makeOverListener(map, marker, overlay) {
// 	    return function() {
// 	    	console.log('mouseOverlay');
// 	        overlay.setVisible(true);
// 	    };
// 	}

// 	// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
// 	function makeOutListener(overlay) {
// 	    return function() {
// 	    	console.log('mouseOutlay');
// 	        overlay.setVisible(false);
// 	    };
// 	}
	
	function deleteShopMarkers() {
		for (i = 0; i < markersContainer.length; i++) {	
			markersContainer[i].setMap(null);
		}
		markersContainer.length = 0;	// 전역변수에 저장된 마커저장 객체 초기화
		
		for(j = 0; j < markersOverLays.length; j++) {
			markersOverLays[j].setMap(null);	
		}
		
		markersOverLays.length = 0;
	}
	
	// 마커이미지의 주소와, 크기, 옵션으로 마커 이미지를 생성하여 리턴하는 함수입니다
	function createMarkerImage(src, size, options) {
	    var markerImage = new kakao.maps.MarkerImage(src, size, options);
	    return markerImage;            
	}

	// 좌표와 마커이미지를 받아 마커를 생성하여 리턴하는 함수입니다
	function createMarker(latitude, longitude, image, content) {
		
		let position = new kakao.maps.LatLng(latitude, longitude);
	    var marker = new kakao.maps.Marker({
	        position: position,
	        image: image
	    });
	    
	    return marker;  
	}   
	
	function sigunguLevel() {		// 시군구 레벨 지도
		$('.erase').parent().remove();
		sigunguAxios();
	}
	
	function sigunguAxios() {		// 시군구 지도 비동기
		const axiosPath = 'mymap/sigungumap/rest/';
		const axPost = async() => {
		    await axios.post(axiosPath)
		    // 정상
				.then( (response) => {
		    const data = response.data;
		    let sigCenter = data;			// 반환 결과 불러오기
		    console.log('시군구 지도 불러오기');
		   
		    for(i = 0; i < sigCenter.length; i++) {
			 	let sigungu_content = '<div class="erase"><div class="sido" onclick="setLevel7()">'
			 	+ sigCenter[i].signame +'</div></div>';
	 		   	    	
				// 커스텀 오버레이가 표시될 위치입니다 
				let sigungu_position = new kakao.maps.LatLng(sigCenter[i].pointy, sigCenter[i].pointx);  
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
		    
		     })
		}
		return axPost();
	}
	

	function sidoLevel() {		// 시도 레벨 지도
		$('.erase').parent().remove();
		sidoAxios();
	}
	
	function sidoAxios() {		// 시도 SQL 비동기
		const axiosPath = 'mymap/sidomap/rest/';
		const axPost = async () => { // async : 비동기 실행 함수
		    await axios.post(axiosPath)
		    // 정상
				.then( (response) => {
		    const data = response.data;
		    let sidoCenter = data;			// 반환 결과 불러오기
		    console.log('시도 지도 불러오기');
			for(i = 0; i < sidoCenter.length; i++) {
			 	let sido_content = '<div class="erase"><div class="sido" onclick="setLevel9()">'
			 										+ sidoCenter[i].sidoname +'</div></div>';
	 		   	    	
				// 커스텀 오버레이가 표시될 위치입니다 
				let sido_position = new kakao.maps.LatLng(sidoCenter[i].pointy, sidoCenter[i].pointx);  

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
			
		     })
		  }
		return axPost();
	}
	
	
	
	// 읍면동 레벨 - 오픈마켓에서 다운받아 좌표변환(WGS 84 : EPGS 4326) 시킨 폴리곤을 나타내줌
 	function emdLevel() {
	  $('.erase').parent().remove();
		 emdAxios();		
	}
	
	function emdAxios() { // 읍면동 지도 비동기
		
		const axiosPath = 'mymap/emdmap/rest/';
		const axPost = async() => {
		    await axios.post(axiosPath)
		    // 정상
				.then( (response) => {
		    const data = response.data;
		    let emdCenter = data;			// 반환 결과 불러오기
		    console.log('읍면동 지도 불러오기');
		    
		    for(i = 0; i < emdCenter.length; i++) {
		    	if(emdCenter[i].count != 0) {
		 	   		let emd_content = '<div class="erase" onclick="emdPolygon(this)" onmouseover="zindexup(this)" onmouseout="zindexdown(this)">' +
		 	   				'<div class="mark-content"><div class="mark-count">' + 
		    				emdCenter[i].count + '</div><h1 class="emdnametag">' + emdCenter[i].emdname +'</h1></div></div>';
		    		let emd_position = new kakao.maps.LatLng(emdCenter[i].pointy, emdCenter[i].pointx); 
		    	
					// 커스텀 오버레이를 생성합니다
					let customOverlay = new kakao.maps.CustomOverlay({
				   		position: emd_position,
				   	 	content: emd_content,
		    			xAnchor: 0.3,
		   				yAnchor: 0.91
					});
				
					// 커스텀 오버레이를 지도에 표시합니다
					customOverlay.setMap(map);
				}
		    }
		    
			})
		}
		return axPost();
	}
	
	
	function emdPolygon(object) {
		let view_emd_nm = object.querySelector('.emdnametag').innerHTML;
		
		if (!emd_switch) {
			console.log('화면 네임 : ' + view_emd_nm);
			
			// EMD250geoJson 을 경상남도, 경상북도, 서울특별시 등으로 바꾼다면
			// 개별적으로 geoJson을 불러올 수 있을 것이다
			// 해당 지도의 중심 값으로 그 값을 가져오면 유용할듯하다
			$.getJSON("mymap/json/sido/" + $('#sido-hidden').html() + ".geojson", function(geojson) {
				let emd_datas = geojson.features;
				let emd_coordinate = [];
				let emd_nm = "";
			
				console.log('emd_datas : ', emd_datas);
			
				$.each(emd_datas, function(index, item) {
					emd_coordinates = item.geometry.coordinates;
					emd_nm = item.properties.EMDNAME;
					emd_num = item.properties.EMDNUM;
					emddisplayArea(emd_coordinates, emd_nm, emd_num, view_emd_nm, object);
				});
			});
		}
	}
	
	// 읍면동 폴리곤 활성화
	function emddisplayArea(coordinates, name, pknum, viewname, object) {
		var emd_path = [];	// 
		
		
		if(name != viewname)
			return false;
		
		if(emdpkContainer.indexOf(pknum) != '-1')
			return false;
		
		
		// 현재 중심좌표의 읍면동이 아닌 읍면동은 실행이 되지 않음
// 		if(name != $('#hidden').html())
// 			return false;
		
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
		emdpkContainer.push(pknum);
		polygonsMap.set(pknum, emd_polygon);		// 맵 자료형태로 읍면동 고유번호와 읍면동 폴리곤 객체를 묶어줬음
		
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

					emdinfowindow.setContent(content);
					emdinfowindow.setPosition(mouseEvent.latLng);
					emdinfowindow.setMap(map);
				});
// 		emd_switch = true;		// 읍면동 폴리곤이 이미 그려졌으니 더이상 그리지 않도록 방지하는 안전장치

		object.setAttribute("onClick", "deletePolygon('" + pknum + "', this)");
		console.log('object : ' , object);
	}
	
	function deletePolygon(pknum, object) {
		polygonsMap.get(pknum).setMap(null);
		polygonsMap.delete(pknum);
		emdpkContainer.splice(emdpkContainer.indexOf(pknum),1);
		object.setAttribute("onClick", "emdPolygon(this)");
	}
	
	function deleteEmd() {
		for(i = 0; i < polygons.length; i++) {
			polygons[i].setMap(null);		// 전역변수에 저장해준 읍면동 폴리곤을 삭제
		}
		polygonoverlay.setMap(null);
		emdinfowindow.setMap(null);
		emd_switch = false;
	}
	
	function setLevel9() {
		map.setLevel(9);
	}
	
	function setLevel7() {
		map.setLevel(7);
	}
	
	function zindexup(object) {		// 읍면동 마커에 마우스를 올리면 제일 위로 올려줌
		object.parentNode.style.zIndex = '100';
	}

	function zindexdown(object) {	// 읍면동 마커에 마우스를 빼면 원래대로 돌려줌
		object.parentNode.style.zIndex = '0';
	}

	
	</script>
</body>
</html>