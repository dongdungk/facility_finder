// lib/map/service/facility_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/facility_model.dart';

class FacilityService {
  final String _seoulBaseUrl = 'http://openAPI.seoul.go.kr:8088';
  final String _serviceName = 'facilities';

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
    String processedQuery = query.toLowerCase().trim();
    String searchKeyword = _queryAliases[processedQuery] ?? processedQuery;

    final String? serviceKey = dotenv.env['SEOUL_API_KEY'];
    if (serviceKey == null) return [];

    final Uri url = Uri.parse('$_seoulBaseUrl/$serviceKey/json/$_serviceName/1/1000/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> dataList = body[_serviceName]?['row'] ?? body['DATA'] ?? [];

        return dataList
            .map((jsonItem) => FacilityModel.fromJson(jsonItem))
            .where((facility) {
          bool isBadminton = facility.category.contains('배드민턴') || facility.name.contains('배드민턴');
          bool isLocationMatch = searchKeyword.isEmpty || facility.district.contains(searchKeyword);
          return isBadminton && isLocationMatch;
        }).toList();
      }
      return [];
    } catch (e) {
      print('Seoul API Error: $e');
      return [];
    }
  }

  Future<FacilityModel?> getFacilityDetail(String facilityName) async {
    List<FacilityModel> all = await searchFacilities("");
    try {
      return all.firstWhere((f) => f.name.contains(facilityName));
    } catch (e) {
      return null;
    }
  }
}