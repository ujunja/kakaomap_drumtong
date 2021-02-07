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