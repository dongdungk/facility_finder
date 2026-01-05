import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/facility_model.dart';
import '../../map/model/firestore_facility_model.dart'; // 경로 확인 필요

class FacilityService {
  final String _seoulBaseUrl = 'http://openAPI.seoul.go.kr:8088';
  final String _serviceName = 'facilities';
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

        List<FacilityModel> results = dataList
            .map((jsonItem) => FacilityModel.fromJson(jsonItem))
            .where((facility) {
          bool isBadminton = facility.category.contains('배드민턴') || facility.name.contains('배드민턴');
          bool isLocationMatch = searchKeyword.isEmpty || facility.district.contains(searchKeyword);
          return isBadminton && isLocationMatch;
        }).toList();

        // ⭐️ 추가: 검색 결과가 있으면 Firestore에 자동 저장
        if (results.isNotEmpty) {
          await syncToFirebase(results);
        }

        return results;
      }
      return [];
    } catch (e) {
      print('Seoul API Error: $e');
      return [];
    }
  }

  // ⭐️ 추가: 서울시 데이터를 Firestore에 저장하는 핵심 로직
  Future<void> syncToFirebase(List<FacilityModel> facilities) async {
    try {
      final batch = _db.batch();
      for (var f in facilities) {
        String docId = f.id.isEmpty || f.id == f.name ? f.name : f.id;
        final firestoreModel = FirestoreFacilityModel(
          id: docId,
          name: f.name,
          address: f.address,
          phone: f.phone,
          category: f.category,
          lat: f.lat,
          lng: f.lng,
          district: f.district,
        );
        var docRef = _db.collection('facilities').doc(docId);
        batch.set(docRef, firestoreModel.toFirestore(), SetOptions(merge: true));
      }
      await batch.commit();
      print("✅ 서울시 데이터 Firestore 동기화 완료");
    } catch (e) {
      print("❌ 서울시 데이터 동기화 에러: $e");
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