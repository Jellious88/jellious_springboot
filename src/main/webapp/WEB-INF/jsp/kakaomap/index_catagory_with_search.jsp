<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>NCOV MAP TEST PAGE</title>
    <style>
.map_wrap, .map_wrap * {margin:10; padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.side_wrap, .side_wrap * {padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
.map_wrap {position:relative;width:70%;height:700px;float:right;}
.side_wrap a, .side_wrap a:hover, .side_wrap a:active{color:#000;text-decoration: none;}
.side_wrap {width:30%;height:700px;marginbottom:20px;float:left;}
#category {position:absolute;top:10px;left:10px;border-radius: 5px; border:1px solid #909090;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.4);background: #fff;overflow: hidden;z-index: 2;}
#category li {float:left;list-style: none;width:50px;px;border-right:1px solid #acacac;padding:6px 0;text-align: center; cursor: pointer;}
#category li.on {background: #eee;}
#category li:hover {background: #ffe6e6;border-left:1px solid #acacac;margin-left: -1px;}
#category li:last-child{margin-right:0;border-right:0;}
#category li span {display: block;margin:0 auto 3px;width:27px;height: 28px;}
#category li .category_bg {background:url(http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png) no-repeat;}
#category li .bank {background-position: -10px 0;}
#category li .mart {background-position: -10px -36px;}
#category li .pharmacy {background-position: -10px -72px;}
#category li .oil {background-position: -10px -108px;}
#category li .cafe {background-position: -10px -144px;}
#category li .store {background-position: -10px -180px;}
#category li.on .category_bg {background-position-x:-46px;}
.placeinfo_wrap {position:absolute;bottom:28px;left:-150px;width:300px;}
.placeinfo {position:relative;width:100%;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;padding-bottom: 10px;background: #fff;}
.placeinfo:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
.placeinfo_wrap .after {content:'';position:relative;margin-left:-12px;left:50%;width:22px;height:12px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
.placeinfo a, .placeinfo a:hover, .placeinfo a:active{color:#fff;text-decoration: none;}
.placeinfo a, .placeinfo span {display: block;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
.placeinfo span {margin:5px 5px 0 5px;cursor: default;font-size:13px;}
.placeinfo .title {font-weight: bold; font-size:14px;border-radius: 6px 6px 0 0;margin: -1px -1px 0 -1px;padding:10px; color: #fff;background: #d95050;background: #d95050 url(http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
.placeinfo .tel {color:#0f7833;}
.placeinfo .jibun {color:#999;font-size:11px;margin-top:0;}
#menu_wrap {position:absolute;top:0;left:0;bottom:0;width:400px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(200, 200, 200, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}
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
#pagination .on {font-weight: bold; cursor: default;color:#777; text-decoration:underline}
	</style>
</head>
<body>
<div>
	<div class="side_wrap">
		<div id="menu_wrap" class="bg_white">
		    <div class="option">
		        <div>
		            <form onsubmit="search(); return false;">
		                키워드 : <input type="text" id="keyword" size="15"> 
		                <button type="submit">검색하기</button> 
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
	    <ul id="category">
	        <li id="01" data-order="0"> 
	            <span class="category_bg bank"></span>선별<br/>진료소
	        </li>       
	        <li id="02" data-order="1"> 
	            <span class="category_bg mart"></span>안심<br/>병원
	        </li>
	        <li id="03" data-order="2"> 
	            <span class="category_bg pharmacy"></span>검체채취<br/>가능병원
	        </li>  
	    </ul>
	</div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4252e979058064f2029555413d35b8eb&libraries=services"></script>
<script>
var useMapBounds = false; // keywordSearch에서 useMapBounds옵션 사용 여부를 위한 변수 (현재 영역 내 검색)
var placeOverlay = new kakao.maps.CustomOverlay({zIndex:1}); // 마커 클릭시 보여줄 info 오버레이
var contentNode = document.createElement('div'); // 커스텀 오버레이 컨텐츠를 담기위한 div
var markers = []; // 마커 배열
var currCd = '';  // currCd == 01 : 선별진료소, 02 : 안심병원, 03 : 검체채취가능병원, 04 : 검색버튼

// 지도 설정
var mapContainer = document.getElementById('map'); // 지도를 표시할 div 
var mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 5 // 지도의 확대 레벨
    };  

// 지도 생성
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 장소 검색 객체 생성
var ps = new kakao.maps.services.Places(map); 

// 커스텀 오버레이의 컨텐츠 노드에 css class를 추가
contentNode.className = 'placeinfo_wrap';

// 커스텀 오버레이의 컨텐츠 노드에 mousedown, touchstart 이벤트가 발생했을때
// 지도 객체에 이벤트가 전달되지 않도록 이벤트 핸들러로 kakao.maps.event.preventMap 메소드를 등록
addEventHandle(contentNode, 'mousedown', kakao.maps.event.preventMap);
addEventHandle(contentNode, 'touchstart', kakao.maps.event.preventMap);

// 커스텀 오버레이 컨텐츠를 설정
placeOverlay.setContent(contentNode);  

// 각 카테고리에 클릭 이벤트를 등록
addCategoryClickEvent();

// 엘리먼트에 이벤트 핸들러를 등록하는 함수
function addEventHandle(target, type, callback) {
    if (target.addEventListener) {
        target.addEventListener(type, callback);
    } else {
        target.attachEvent('on' + type, callback);
    }
}

function search() {
	keyword = document.getElementById('keyword').value;
	
	if (!keyword.replace(/^\s+|\s+$/g, '')) {
		alert('키워드를 입력해주세요!');
		currCd = "";
		return false;
	}
	
	currCd = "04";
	useMapBounds = false;	// 현재 영역내 검색 X
	searchPlaces();
	kakao.maps.event.removeListener(map, 'idle', searchPlaces);
}


// 카테고리 검색을 요청하는 함수
function searchPlaces() {
    // 검색 => 콜백함수 placesSearchCB
    ps.keywordSearch(convertCurrCdToKeyword(currCd), placesSearchCB, {useMapBounds:useMapBounds});
}

function convertCurrCdToKeyword(currCd){
	var keyword = "";
	
	// currCd == 01 : 선별진료소, 02 : 안심병원, 03 : 검체채취가능병원, 04 : 검색버튼
	if (currCd == "01") {
		keyword = "선별진료소";
	} else if (currCd == "02") {
		keyword = "안심병원";
	} else if (currCd == "03") {
		keyword = "검체채취가능";
	} else if (currCd == "04") {
		keyword = document.getElementById('keyword').value;
	}
	
	document.getElementById('keyword').value = keyword;
	
	return keyword;
}

// 키워드 검색 콜백 함수
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
    	// 정상 처리
        displayPlaces(data);
     	// 페이지 번호
        displayPagination(pagination);
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
    	// 결과 없음
        alert("검색 결과가 없습니다.");
    } else if (status === kakao.maps.services.Status.ERROR) {
    	// 에러 발생 
    	alert("오류가 발생했습니다.\n잠시후 다시시도하여 주십시오.");
    }
}

// 마커 표시 및 지도 재설정 (지도 재설정은 검색인 경우만)
function displayPlaces(places) {
    var listEl = document.getElementById('placesList');
    var menuEl = document.getElementById('menu_wrap');
    var fragment = document.createDocumentFragment();
    var bounds = new kakao.maps.LatLngBounds();
    var listStr = '';

    // 커스텀 오버레이 숨김
    placeOverlay.setMap(null);

    // 마커 제거
    removeMarker();
    
 	// 기존 검색 결과 제거
    removeAllChildNods(listEl);
    
    // currCd == 01 : 선별진료소, 02 : 안심병원, 03 : 검체채취가능병원, 04 : 검색버튼
    // data-orer를 이용하여 마커에 표시할 이미지 선택
    if(currCd != 04) {
    	var order = document.getElementById(currCd).getAttribute('data-order');
    } else {
    	order = '3';
    }
	
    for ( var i=0; i<places.length; i++ ) {
		// 마커생성 및 표시
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
        var marker = addMarker(placePosition, order);
        var itemEl = getListItem(i, places[i]);
        
        bounds.extend(placePosition);
        
        // 마커와 검색결과 항목을 클릭 했을 때, 장소정보를 표시
        
        (function(marker, place) {
            kakao.maps.event.addListener(marker, 'click', function() {
                displayPlaceInfo(place);
            });
            
            itemEl.onclick =  function () {
            	displayPlaceInfo(place);
            	changeCategoryClass();
            };


        })(marker, places[i]);
        
        fragment.appendChild(itemEl);
    }
	 // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;
    
    //useMapBounds를 사용하지 않는경우 bounds 객채를 이용하여 맵 재설정
    if(!useMapBounds)map.setBounds(bounds);
}

//검색결과 항목을 Element로 반환하는 함수
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



function removeAllChildNods(el) {   
    while (el.hasChildNodes()) { 
        el.removeChild (el.lastChild);
    }
}

// 마커 생성 및 지도에 표시
function addMarker(position, order) {
    var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png'; // 마커 이미지 url, 스프라이트 이미지를 씁니다
    var imageSize = new kakao.maps.Size(27, 28);  // 마커 이미지의 크기
    var imgOptions =  {
            spriteSize : new kakao.maps.Size(72, 208), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(46, (order*36)), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(11, 28) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        };
   var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커 표시
    markers.push(marker);  // 배열에 생성된 마커 추가

    return marker;
}

//마커 제거
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}
//검색결과 페이징
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination');
    var fragment = document.createDocumentFragment();

    // 기존에 추가된 페이지번호 삭제
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild(paginationEl.lastChild);
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
                    changeCategoryClass();
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}


// 마커 클릭시 정보 표시 (커스텀 오버레이)
function displayPlaceInfo (place) {
    var content = '<div class="placeinfo">' +
                    '   <a class="title" href="' + place.place_url + '" target="_blank" title="' + place.place_name + '">' + place.place_name + '</a>';   

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

// 각 카테고리에 클릭 이벤트 등록
function addCategoryClickEvent() {
    var category = document.getElementById('category'),
        children = category.children;

    for (var i=0; i<children.length; i++) {
        children[i].onclick = onClickCategory;
    }
}

// 카테고리를 클릭했을 때 호출되는 함수
function onClickCategory() {
    var cd = this.id;
    var className = this.className;
    
    useMapBounds = true; // 현재 영역내 검색 O

    placeOverlay.setMap(null);

    if (className === 'on') {
    	currCd = '';
        changeCategoryClass();
        removeMarker();
    } else {
    	currCd = cd;
        changeCategoryClass(this);
        searchPlaces();
	}
}

// 클릭된 카테고리에 'on' class 추가
function changeCategoryClass(el) {
    var category = document.getElementById('category');
    var children = category.children;
	
 	// 카테고리 해제 -> idle 이벤트를 제거
    kakao.maps.event.removeListener(map, 'idle', searchPlaces);
    
    for (var i=0; i<children.length; i++ ) {
        children[i].className = '';
    }

    if (el) {
        el.className = 'on';
     	// 카테고리 선택 -> idle 이벤트를 추가하여 맵 이동 또는 범위 설정 시 현재 영역 내 재검색 수행
        kakao.maps.event.addListener(map, 'idle', searchPlaces);
    } 
}

function initCategoryClass(){
	
}
//기존 결과 목록 제거
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}
</script>
</body>
</html>
