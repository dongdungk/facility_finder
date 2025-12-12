// lib/map/service/facility_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/facility_model.dart';

class FacilityService {
  final String _seoulBaseUrl = 'http://openAPI.seoul.go.kr:8088';
  final String _serviceName = 'facilities';

  // ⭐️ [유지] 영어 검색어를 한글 자치구명으로 변환하는 맵은 필수입니다.
  final Map<String, String> _queryAliases = {
    'songpa': '송파', 'gwangjin': '광진', 'seongbuk': '성북', 'dongjak': '동작',
    'gangseo': '강서', 'gangnam': '강남', 'seocho': '서초', 'mapo': '마포',
    'yeongdeungpo': '영등포', 'yongsan': '용산', 'eunpyeong': '은평',
    'jongno': '종로', 'jung': '중구', 'junggu': '중구', 'jungnang': '중랑',
    'dobong': '도봉', 'nowon': '노원', 'guro': '구로', 'geumcheon': '금천',
    'gwanak': '관악', 'gangdong': '강동', 'gangbuk': '강북',
    'yangcheon': '양천', 'seongdong': '성동', 'seodaemun': '서대문',
  };

  Future<List<FacilityModel>> searchFacilities(String query) async {
    // 1. 사용자 입력 (영어)을 소문자로 정리
    String processedQuery = query.toLowerCase().trim();

    // 2. 맵을 통해 검색어를 한글 자치구 이름으로 변환 (예: 'guro' -> '구로')
    String searchKeyword = _queryAliases[processedQuery] ?? processedQuery;

    final String? serviceKey = dotenv.env['SEOUL_API_KEY'];
    if (serviceKey == null) return [];

    final Uri url = Uri.parse(
        '$_seoulBaseUrl/$serviceKey/json/$_serviceName/1/1000/'
    );

    print('Calling Seoul API: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
        jsonDecode(utf8.decode(response.bodyBytes));

        List<dynamic> dataList = [];
        if (body.containsKey(_serviceName)) {
          dataList = body[_serviceName]['row'];
        } else if (body.containsKey('DATA')) {
          dataList = body['DATA'];
        }

        // ⭐️⭐️⭐️ [최종 필터링 로직] ⭐️⭐️⭐️
        List<FacilityModel> facilities = dataList
            .map((jsonItem) => FacilityModel.fromJson(jsonItem))
            .where((facility) {

          // 1. 배드민턴 시설만 골라내기
          bool isBadminton = facility.category.contains('배드민턴') ||
              facility.name.contains('배드민턴');

          // 2. 지역구 일치 여부 확인 (Model에서 이미 공백 제거 완료)
          //    searchKeyword(한글)가 facility.district(한글)에 포함되는지 확인
          //    (facility.district는 이미 깨끗하게 정제된 한글 자치구명입니다.)

          // 검색어가 없으면 모두 통과
          bool isLocationMatch = searchKeyword.isEmpty;

          // 검색어가 있으면 자치구에 해당 검색어가 포함되어야 함
          if (searchKeyword.isNotEmpty) {
            // 자치구 이름도 소문자로 변환하여 비교 (만약을 위해)
            String normalizedDistrict = facility.district.toLowerCase();
            String normalizedSearch = searchKeyword.toLowerCase();

            isLocationMatch = normalizedDistrict.contains(normalizedSearch);
          }

          return isBadminton && isLocationMatch;
        })
            .toList();

        print('✅ Found ${facilities.length} badminton courts in "$searchKeyword"');
        return facilities;

      } else {
        print('API 서버 에러: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('네트워크/파싱 에러: $e');
      return [];
    }
  }

  Future<FacilityModel?> getFacilityDetail(String facilityName) async {
    // 상세 검색은 전체 목록에서 이름으로 찾습니다.
    List<FacilityModel> allFacilities = await searchFacilities("");
    try {
      return allFacilities.firstWhere(
              (facility) => facility.name.contains(facilityName)
      );
    } catch (e) {
      return null;
    }
  }
}