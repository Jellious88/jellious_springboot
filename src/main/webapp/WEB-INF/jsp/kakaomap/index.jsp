<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>NCOV TEST PAGE</title>
    <style>
.map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.side_wrap, .side_wrap * {padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}
.map_wrap {position:relative;width:70%;height:600px;float:right;}
.side_wrap a, .side_wrap a:hover, .side_wrap a:active{color:#000;text-decoration: none;}
.side_wrap {width:30%;height:700px;marginbottom:20px;float:left;}
.use_bounds{position: absolute;top: 10px;left: 10px;z-index: 1;}
#menu_wrap {position:absolute;top:0;left:0;bottom:0;width:400px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(230, 230, 230, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}
.bg_white {background:#fff;}
#menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
#menu_wrap .option{text-align: center;}
#menu_wrap .option p {margin:10px 0;}  
#menu_wrap .option button {margin-left:5px;}
#placesList li {list-style: none;}
#placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
#placesList .item span {display: block;margin-top:4px;}
#placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
#placesList .item .info{padding:10px 0 10px 55px;}
#placesList .info .gray {color:#8a8a8a;}
#placesList .info .jibun {padding-left:26px;background:url(http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
#placesList .info .tel {color:#009900;}
#placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
#placesList .item .marker_1 {background-position: 0 -10px;}
#placesList .item .marker_2 {background-position: 0 -56px;}
#placesList .item .marker_3 {background-position: 0 -102px}
#placesList .item .marker_4 {background-position: 0 -148px;}
#placesList .item .marker_5 {background-position: 0 -194px;}
#placesList .item .marker_6 {background-position: 0 -240px;}
#placesList .item .marker_7 {background-position: 0 -286px;}
#placesList .item .marker_8 {background-position: 0 -332px;}
#placesList .item .marker_9 {background-position: 0 -378px;}
#placesList .item .marker_10 {background-position: 0 -423px;}
#placesList .item .marker_11 {background-position: 0 -470px;}
#placesList .item .marker_12 {background-position: 0 -516px;}
#placesList .item .marker_13 {background-position: 0 -562px;}
#placesList .item .marker_14 {background-position: 0 -608px;}
#placesList .item .marker_15 {background-position: 0 -654px;}
#pagination {margin:10px auto;text-align: center;}
#pagination a {display:inline-block;margin-right:10px;}
#pagination .on {font-weight: bold; cursor: default;color:#777;text-decoration:underline;}
.placeinfo_wrap {position:absolute;bottom:28px;left:-150px;width:300px;}
.placeinfo {position:relative;width:100%;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;padding-bottom: 10px;background: #fff;}
.placeinfo:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
.placeinfo_wrap .after {content:'';position:relative;margin-left:-12px;left:50%;width:22px;height:12px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
.placeinfo a, .placeinfo a:hover, .placeinfo a:active{color:#fff;text-decoration: none;}
.placeinfo a, .placeinfo span {display: block;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
.placeinfo span {margin:5px 5px 0 5px;cursor: default;font-size:13px;}
.placeinfo .title {font-weight: bold; font-size:14px;border-radius: 6px 6px 0 0;margin: -1px -1px 0 -1px;padding:10px; color: #fff;background: #d95050;}
.placeinfo .tel {color:#0f7833;}
.placeinfo .jibun {color:#999;font-size:11px;margin-top:0;}
</style>
</head>
<body>
<div class="side_wrap">
	<div id="menu_wrap" class="bg_white">
	    <div class="option">
	        <div>
	            <form onsubmit="searchPlaces(); return false;">
	                키워드 : <input type="text" value="선별진료소" id="keyword" size="15" /> 
	                <button type="submit">검색하기</button>
	              <input type="checkbox" id="useMapBounds" /> 현 지도 내 검색
	              
	            </form>
	        </div>
	    </div>
	    <hr>
	    <ul id="placesList"></ul>
	    <div id="pagination"></div>
    </div>
</div>
<div class="map_wrap">
    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
    <p class="use_bounds">
        <button onclick="setKeywordAndSearchPlace('선별진료소')">현 지도 내<br/>선별진료소검색</button>
        <button onclick="setKeywordAndSearchPlace('안심병원')">현 지도 내<br/>안심병원검색</button>
        <button onclick="setKeywordAndSearchPlace('검체채취가능')">현 지도 내<br/>검체채취가능병원검색</button>
    </p>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4252e979058064f2029555413d35b8eb&libraries=services"></script>
<script>
// 마커를 담을 배열
var markers = [];
// useMapBounds 사용여부
var useMapBounds = false;

var mapContainer = document.getElementById('map'); // 지도를 표시할 div 
var mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도 생성
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 장소 검색 객체 생성
var ps = new kakao.maps.services.Places(map);  

//커스텀 오버레이 생성 및 설정
var placeOverlay = new kakao.maps.CustomOverlay({zIndex:1});
var contentNode = document.createElement('div');
contentNode.className = 'placeinfo_wrap';
placeOverlay.setContent(contentNode);

//HTML5의 geolocation 사용 가능여부
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
    	
        var lat = position.coords.latitude; // 위도
        var lon = position.coords.longitude; // 경도
        var locPosition = new kakao.maps.LatLng(lat, lon); // 좌표 생성
      
        // 현재 위치 마커 
        /*
        var marker = new kakao.maps.Marker({  
            position: locPosition
        });
        
        marker.setMap(map);
        */
        
        // 지도 중짐좌표 및 지도 레벨 설정
        map.setLevel(3);
        map.setCenter(locPosition);
            
      });
    
} else {
	//geolocation 사용 불가능
    alert("사용자의 위치정보를 가져올 수 없습니다.");
}

// 매개변수로 넘어온 키워드를 사용하여 검색하는 함수 (useMapBounds)
function setKeywordAndSearchPlace(keyword){
	document.getElementById('keyword').value = keyword;
	document.getElementById('useMapBounds').checked = true;
	searchPlaces();
}

// 키워드 검색을 요청하는 함수
function searchPlaces() {
	var keyword = document.getElementById('keyword').value;
	// 콜백함수에서 사용하기 위해 전역으로 설정
	useMapBounds = document.getElementById('useMapBounds').checked;
	
    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // 키워드로 장소검색
    ps.keywordSearch( keyword, placesSearchCB, {useMapBounds:useMapBounds}); 
}

// 장소검색 콜백함수
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
		// 결과 목록, 마커, 커스텀오버레이 컨텐츠 설정
        displayPlaces(data);

        // 페이징
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {
        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}

//결과 목록, 마커, 커스텀오버레이 컨텐츠 설정 함수
function displayPlaces(places) {

    var listEl = document.getElementById('placesList');
    var menuEl = document.getElementById('menu_wrap');
    var fragment = document.createDocumentFragment(); 
    var bounds = new kakao.maps.LatLngBounds(); 
    var listStr = '';
    
    // 기존 검색 목록 제거
    removeAllChildNods(listEl);

    // 기존 마커 제거
    removeMarker();
    
    for ( var i=0; i<places.length; i++ ) {
	
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
        var marker = addMarker(placePosition, i);	// 마커 설정 
        var itemEl = getListItem(i, places[i]); // 검색 결과 element 생성

        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표 추가 (현위치에서 검색 X 경우)
        if(!useMapBounds)bounds.extend(placePosition);

        // 마커와 검색결과 항목에 mouseover시 
        // 해당 장소에 커스텀 오버레이 표시 mouseout 시 닫기
        (function(marker, places, placePosition) {
            kakao.maps.event.addListener(marker, 'mouseover', function() {
            	displayPlaceInfo(places);
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
             	placeOverlay.setMap(null);
            });
            
            itemEl.onmouseover =  function () {
            	displayPlaceInfo(places);
            };
            
            itemEl.onmouseout =  function () {
             	placeOverlay.setMap(null);
            };

            itemEl.onclick =  function () {
	            	map.setLevel(3);
            	map.setCenter(placePosition);
            };
        })(marker, places[i], placePosition);

        fragment.appendChild(itemEl);
    }

    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정 (현위치에서 검색 X 경우)
    if(!useMapBounds)map.setBounds(bounds);
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

    // 기존에 추가된 페이지번호 삭제
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

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
	
	content += '    <span class="tel">' + place.phone + '</span>' + 
	'</div>' + 
	'<div class="after"></div>';

	contentNode.innerHTML = content;
    placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
    placeOverlay.setMap(map); 
}

 // 검색결과 목록의 자식 Element를 제거하는 함수
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}

 </script>
</body>
</html>

