// lib/map/service/kakao_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/facility_model.dart';

class KakaoService {
  final String _baseUrl = "https://dapi.kakao.com/v2/local/search/keyword.json";
  final String _apiKey = dotenv.env['KAKAO_REST_API_KEY'] ?? "";

  Future<List<FacilityModel>> searchStudyCafes(String query) async {
    // 카카오 API는 Authorization 헤더에 KakaoAK {REST_API_KEY}를 넣어야 함
    final Uri url = Uri.parse("$_baseUrl?query=$query");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "KakaoAK $_apiKey"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List documents = data['documents'];

        // 카카오 응답(documents)을 우리 앱의 모델로 변환
        return documents.map((doc) => FacilityModel.fromKakao(doc)).toList();
      }
      return [];
    } catch (e) {
      print('Kakao API Error: $e');
      return [];
    }
  }

  // 상세 페이지 조회를 위한 메서드
  Future<FacilityModel?> getKakaoFacilityDetail(String facilityId) async {
    // 실제로는 ID 기반 조회를 하거나 검색 결과에서 데이터를 유지합니다.
    return null;
  }
}