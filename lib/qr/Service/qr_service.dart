// lib/qr/service/qr_service.dart
import 'dart:async';
// ⭐️ 기존에 만든 FacilityService와 Model을 임포트
import '../../map/service/facility_service.dart';
import '../../map/model/facility_model.dart';

class QRService {
  // ⭐️ FacilityService를 멤버 변수로 가짐
  final FacilityService _facilityService = FacilityService();

  Future<Map<String, dynamic>> verifyQRCode(String facilityNameFromQR) async {
    try {
      // 1. QR에서 읽은 이름으로 실제 서울시 API 조회 (기존에 만든 함수 재사용)
      //    (FacilityService의 getFacilityDetail 함수가 이름을 받아 API를 검색함)
      FacilityModel? facility = await _facilityService.getFacilityDetail(facilityNameFromQR);

      if (facility != null) {
        // 2. API에서 시설을 찾았으면 성공 정보 반환
        return {
          "success": true,
          "facilityName": facility.name, // API에서 온 실제 이름
          "address": facility.address,   // API에서 온 실제 주소
          "entryTime": DateTime.now().toIso8601String(),
          "facilityObject": facility,    // 필요하면 모델 통째로 넘김
        };
      } else {
        // 3. API에 없는 시설이면 실패 처리
        return {
          "success": false,
          "message": "해당 시설 정보를 찾을 수 없습니다."
        };
      }
    } catch (e) {
      // 4. 에러 발생 시
      return {
        "success": false,
        "message": "API 조회 중 오류 발생: $e"
      };
    }
  }
}