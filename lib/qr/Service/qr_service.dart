import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../map/service/facility_service.dart';
import '../../map/model/facility_model.dart';
import '../../map/model/firestore_facility_model.dart'; // Firestore 전용 모델 추가

class QRService {
  final FacilityService _facilityService = FacilityService();

  /// QR 코드로 시설을 검증하고 데이터를 반환하는 핵심 함수
  Future<Map<String, dynamic>> verifyQRCode(String scannedId) async {
    try {
      // 1단계: 먼저 우리 Firestore DB에서 ID로 직접 조회 (가장 빠름)
      var doc = await FirebaseFirestore.instance
          .collection('facilities')
          .doc(scannedId)
          .get();

      if (doc.exists) {
        // DB에 있다면 Firestore 전용 모델로 변환
        final facility = FirestoreFacilityModel.fromFirestore(doc);
        return _buildSuccessResponse(facility);
      }

      // 2단계: 만약 DB에 없다면, 기존 방식대로 서울시 API에서 이름으로 검색 시도
      // (scannedId가 시설 이름인 경우를 대비한 하이브리드 로직)
      print("DB에 데이터가 없어 API 조회를 시작합니다: $scannedId");
      FacilityModel? apiFacility = await _facilityService.getFacilityDetail(scannedId);

      if (apiFacility != null) {
        // 찾았다면 이 기회에 DB에 저장 (나중을 위해 동기화)
        await _facilityService.syncToFirebase([apiFacility]);

        return {
          "success": true,
          "facilityName": apiFacility.name,
          "address": apiFacility.address,
          "entryTime": DateTime.now().toIso8601String(),
          "facilityObject": apiFacility,
          "source": "API", // 어디서 가져왔는지 구분용
        };
      }

      // 3단계: 둘 다 없으면 실패
      return {
        "success": false,
        "message": "등록되지 않은 시설입니다. (ID: $scannedId)"
      };

    } catch (e) {
      return {
        "success": false,
        "message": "QR 인식 처리 중 오류 발생: $e"
      };
    }
  }

  /// 공통 성공 응답 빌더
  Map<String, dynamic> _buildSuccessResponse(FirestoreFacilityModel facility) {
    return {
      "success": true,
      "facilityName": facility.name,
      "address": facility.address,
      "entryTime": DateTime.now().toIso8601String(),
      "facilityObject": facility,
      "source": "Firestore",
    };
  }
}