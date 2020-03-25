var markers = []; 		  // 마커를 담을 배열

var ps;		// 장소 검색 객체	
var map;	// 지도 객체
var placeOverlay;	// 커스텀 오버레이 객체
var contentNode;	// 커스텀 오버레이 내 장소 정보

var currKeywd;		// 현재 선택된 키워드를 가지고 있을 변수
var isItemClick;// 목록 클릭 여부

var searchList = false;

$(function(){
	setTimeout(mapSideTop, 500);
	mapSideHeight();
	
	var region = getParameterByName("region");
	var town = getParameterByName("town");
	var hospitalNm = getParameterByName("hospitalNm");
	
	if(region == "" || town == "" || hospitalNm == "" ){
		searchList = true;
	} else {
		$(".side_wrap").hide()
	}
	
	var mapContainer = document.getElementById('map'); // 지도를 표시할 div 
	var mapOption = {
	        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  
	
	// 지도 생성
	map = new kakao.maps.Map(mapContainer, mapOption);
	kakao.maps.event.addListener(map, 'idle', keywordSearchUseCurrKeywd);

	// 장소 검색 객체 생성
	ps = new kakao.maps.services.Places(map); 
	
	// 커스텀 오버레이 생성 및 설정
	placeOverlay = new kakao.maps.CustomOverlay({zIndex:1});
	contentNode = document.createElement('div');
	contentNode.className = 'placeinfo_wrap';
	placeOverlay.setContent(contentNode);
	
	if(searchList){
		useGeolocation();
	}else{
		searchPlaces(region + " " + town + " " + hospitalNm, false);
	}
});

function useGeolocation() {
	//HTML5의 geolocation 사용 가능여부
	if (navigator.geolocation) {
	    navigator.geolocation.getCurrentPosition(function(position) {
	        var lat = position.coords.latitude; // 위도
	        var lon = position.coords.longitude; // 경도
	        var locPosition = new kakao.maps.LatLng(lat, lon); // 좌표 생성
	      
	        // 지도 중짐좌표 및 지도 레벨 설정
	        map.setLevel(3);
	        map.setCenter(locPosition);
	            
	      });
	    
	} else {
		//geolocation 사용 불가능
	    alert("사용자의 위치정보를 가져올 수 없습니다.");
	}
}

// 키워드 검색을 요청하는 함수
function searchPlaces(keyword, btn) {
	currKeywd = keyword;
	
	$(".btn").attr('class','btn btn_sm btn_gray');
	btn.className = 'btn btn_sm btn_blue';
	
	keywordSearchUseCurrKeywd();
}

function keywordSearchUseCurrKeywd(){
	 if (!currKeywd || isItemClick) {
		 	isItemClick = false;
	        return;
	    }

	// 검색목록 초기화
	initPlacesList(true);
	
    // 키워드로 장소검색
    ps.keywordSearch(currKeywd, placesSearchCB, {useMapBounds:true}); 
}

// 장소검색 콜백함수
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
    	// 결과 목록, 마커, 커스텀오버레이 컨텐츠 설정
        displayPlaces(data);
        // 페이징
        if(searchList && wCatch()=='p'){
        	displayPagination(pagination);
        }
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {
        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}

//placesList 초기화
function initPlacesList(removeAll) {
	var listEl = document.getElementById('placesList');
	var paginationEl = document.getElementById('pagination');
	if(removeAll){
		// 커스텀 오버레이 제거
		placeOverlay.setMap(null);
	}
	// 마커 제거
	removeMarker();
	
	// 검색결과 목록의 자식 Element를 제거
    while (listEl.hasChildNodes()) {
    	listEl.removeChild (listEl.lastChild);
    }
	 
	// 기존에 추가된 페이지번호 삭제
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }
}

//결과 목록, 마커, 커스텀오버레이 컨텐츠 설정 함수
function displayPlaces(places) {
    var listEl = document.getElementById('placesList');
    var menuEl = document.getElementById('menu_wrap');
    var fragment = document.createDocumentFragment(); 
    var bounds = new kakao.maps.LatLngBounds(); 
    var listStr = '';
    
    for ( var i=0; i<places.length; i++ ) {
	
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
        var marker = addMarker(placePosition, i);	// 마커 설정 
        var itemEl = getListItem(i, places[i]); // 검색 결과 element 생성

        // 마커와 검색결과 항목에 click시 해당 장소에 커스텀 오버레이 표시
        (function(marker, places, placePosition) {
            kakao.maps.event.addListener(marker, 'click', function() {
            	displayPlaceInfo(places);
            });
            
            itemEl.onclick =  function () {
            	isItemClick = true;
            	displayPlaceInfo(places);
	            map.setLevel(3);
            	map.setCenter(placePosition);
            };
        })(marker, places[i], placePosition);

        if(wCatch()=='p'){
        	fragment.appendChild(itemEl);
        }
        
        if(!searchList){
        	break;
        }
    }

    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;
}

// 검색결과 항목을 Element로 반환하는 함수
function getListItem(index, places) {

    var el = document.createElement('li');
    var itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수
function addMarker(position, idx, title) {
    var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png'; // 마커 이미지 url, 스프라이트 이미지를 씁니다
    var imageSize = new kakao.maps.Size(36, 37);  // 마커 이미지의 크기
    var imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        };
	var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions);
    var marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커 표시
    markers.push(marker);  // 배열에 생성된 마커 추가

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거하는 함수
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination');
    var fragment = document.createDocumentFragment();

    for (var i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커에 mouseover 이벤트가 발생했을경우
// 커스텀 오버레이를 표시하는 함수
function displayPlaceInfo(place) {
	var content = '<div class="placeinfo">' +
	    '   <p class="title" href="' + place.place_url + '" target="_blank" title="' + place.place_name + '">' + place.place_name + '</p>';   
// 	    '   <a class="title" href="https://map.kakao.com/link/to/' + place.place_name + ',' + place.y + ',' + place.x + '" target="_blank" title="' + place.place_name + '">' + place.place_name + '</a>';   
	
	if (place.road_address_name) {
	content += '    <span title="' + place.road_address_name + '">' + place.road_address_name + '</span>' +
	    '  <span class="jibun" title="' + place.address_name + '">(지번 : ' + place.address_name + ')</span>';
	}  else {
	content += '    <span title="' + place.address_name + '">' + place.address_name + '</span>';
	}                
	
	content += '    <span class="tel"><a href="tel:'+place.phone+'">' + place.phone + '</a></span>' + 
	'<a class="btn_close" onclick="placeOverlay.setMap(null)"><span class="hdn">닫기</span></a>'+
	'<a class="btn_roadmap" href="https://map.kakao.com/link/to/' + place.place_name + ',' + place.y + ',' + place.x + '" target="_blank" title="' + place.place_name + '">'+
	'<span>길찾기</span></a></div><div class="after"></div>';

	contentNode.innerHTML = content;
    placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
    placeOverlay.setMap(map); 
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function wCatch() {
	var
		status
	,	wc	= $('.w_catch')
	,	wcP = wc.find('.wc_p').css('display')
	,	wcT = wc.find('.wc_t').css('display')
	,	wcM = wc.find('.wc_m').css('display')
	;

	return "block" === wcP ? status = "p" : "block" === wcT ? status = "t" : "block" === wcM ? status = "m" : void 0

}

function mapSideTop() {

	$('.side_wrap > div').css({
		'padding-top'	:	($('.map_popup_wrap .mp_option').outerHeight()) + 'px'
	});

}

function mapSideHeight() {
	var
		status		=	wCatch()
	,	winH		=	$(window).outerHeight()
	,	sidePadding	=	32
	,	optionH		=	$('.map_popup_wrap .mp_option').outerHeight()
	$('.mp_place_list').css({
		'max-height'	:	(winH - sidePadding - optionH) + 'px'
	});
}

$(window).on('resize', function(){
	mapSideTop();
	mapSideHeight();
});