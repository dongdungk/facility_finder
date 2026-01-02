import 'package:flutter/material.dart';
import '../model/facility_model.dart';
import '../service/facility_service.dart';
import '../service/kakao_service.dart'; // ⭐️ KakaoService 추가
import '../service/facility_photo_service.dart';
import '../service/facility_review_service.dart';

class FacilityDetailViewModel extends ChangeNotifier {
  final FacilityService _facilityService;
  final KakaoService _kakaoService; // ⭐️ 추가
  final PhotoService _photoService;

  FacilityModel? _facility;
  bool _isLoading = false;

  FacilityModel? get facility => _facility;
  bool get isLoading => _isLoading;
  String? get facilityName => _facility?.name;

  // 생성자에 KakaoService 주입
  FacilityDetailViewModel(
      this._facilityService,
      this._kakaoService,
      this._photoService,
      FacilityReviewService reviewService,
      );

  /// 상세 정보 로드 함수
  /// [isKakao]가 true이면 카카오 API 기반으로, false이면 서울시 API 기반으로 동작합니다.
  Future<void> loadFacility(String facilityId, {bool isKakao = false}) async {
    _isLoading = true;
    _facility = null; // 로딩 시작 시 초기화
    notifyListeners();

    try {
      FacilityModel? facilityData;

      if (isKakao) {
        // 1-1. 카카오 시설인 경우 (스터디카페 등)
        // 검색 결과 리스트에서 상세 정보를 찾거나, 필요한 경우 추가 API 호출 로직을 넣습니다.
        // 여기서는 예시로 전달받은 ID를 통해 상세 정보를 로드한다고 가정합니다.
        facilityData = await _kakaoService.getKakaoFacilityDetail(facilityId);
      } else {
        // 1-2. 서울시 시설인 경우 (배드민턴장 등)
        facilityData = await _facilityService.getFacilityDetail(facilityId);
      }

      // 2. Firestore에서 해당 시설의 추가 사진 로드
      final List<String> photoUrls = await _photoService.getPhotos(facilityId);

      // 3. 최종 데이터 합병
      if (facilityData != null) {
        _facility = FacilityModel(
          id: facilityData.id,
          name: facilityData.name,
          address: facilityData.address,
          phone: facilityData.phone,
          category: facilityData.category,
          lat: facilityData.lat, // ⭐️ 새 모델에 추가된 위도
          lng: facilityData.lng, // ⭐️ 새 모델에 추가된 경도
          district: facilityData.district,
          // Firestore 사진이 있으면 우선 사용, 없으면 기본 API 사진 사용
          images: photoUrls.isNotEmpty ? photoUrls : facilityData.images,
          hours: facilityData.hours,
          price: facilityData.price,
          status: facilityData.status,
          reservation: facilityData.reservation,
          rating: facilityData.rating,
          reviewCount: facilityData.reviewCount,
        );
      }
    } catch (e) {
      print("FacilityDetailViewModel Load Error: $e");
      _facility = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}