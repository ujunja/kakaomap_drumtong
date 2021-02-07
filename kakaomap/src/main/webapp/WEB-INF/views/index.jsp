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
	<span style="visibility: hidden;" id="currentlatitude"></span>
	<span style="visibility: hidden;" id="currentlongitude"></span>
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
		
	<script type="text/javascript" src="mymap/js/kakaomap-main.js"></script>	
	<script type="text/javascript" src="mymap/js/kakaomap-sub.js"></script>
	<script type="text/javascript" src="mymap/js/kakaomap-shop.js"></script>
	<script type="text/javascript" src="mymap/js/kakaomap-emd.js"></script>
	<script type="text/javascript" src="mymap/js/kakaomap-sig.js"></script>
	<script type="text/javascript" src="mymap/js/kakaomap-sido.js"></script>
</body>
</html>