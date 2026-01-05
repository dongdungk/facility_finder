import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/facility_model.dart';
import '../../map/model/firestore_facility_model.dart'; // 경로 확인 필요

class KakaoService {
  final String _baseUrl = "https://dapi.kakao.com/v2/local/search/keyword.json";
  final String _apiKey = dotenv.env['KAKAO_REST_API_KEY'] ?? "";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<FacilityModel>> searchStudyCafes(String query) async {
    final Uri url = Uri.parse("$_baseUrl?query=$query 스터디카페");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "KakaoAK $_apiKey"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List documents = data['documents'];

        List<FacilityModel> results = documents
            .map((doc) => FacilityModel.fromKakao(doc))
            .toList();

        // 추가: 검색 결과가 있으면 Firestore에 자동 저장
        if (results.isNotEmpty) {
          await syncToFirebase(results);
        }

        return results;
      }
      return [];
    } catch (e) {
      print('Kakao API Error: $e');
      return [];
    }
  }

  // 추가: 카카오 데이터를 Firestore에 저장하는 핵심 로직
  Future<void> syncToFirebase(List<FacilityModel> facilities) async {
    try {
      final batch = _db.batch();
      for (var f in facilities) {
        final firestoreModel = FirestoreFacilityModel(
          id: f.id,
          name: f.name,
          address: f.address,
          phone: f.phone,
          category: f.category,
          lat: f.lat,
          lng: f.lng,
          district: f.district,
        );
        var docRef = _db.collection('facilities').doc(f.id);
        batch.set(
          docRef,
          firestoreModel.toFirestore(),
          SetOptions(merge: true),
        );
      }
      await batch.commit();
      print("✅ 카카오 데이터 Firestore 동기화 완료");
    } catch (e) {
      print("❌ 카카오 데이터 동기화 에러: $e");
    }
  }

  Future<FacilityModel?> getKakaoFacilityDetail(String facilityId) async {
    return null;
  }
}
