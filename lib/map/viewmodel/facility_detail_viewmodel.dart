// lib/map/viewmodel/facility_detail_viewmodel.dart

import 'package:flutter/material.dart';
// ⭐️ [FIX] FacilityReviewService 임포트 추가 ⭐️
import '../service/facility_review_service.dart';
import '../model/facility_model.dart';
import '../service/facility_service.dart';
import '../service/facility_photo_service.dart'; // PhotoService 추가

class FacilityDetailViewModel extends ChangeNotifier {

  final FacilityService _facilityService;
  final PhotoService _photoService;

  FacilityModel? _facility;
  bool _isLoading = false;

  FacilityModel? get facility => _facility;
  bool get isLoading => _isLoading;
  String? get facilityName => _facility?.name;

  // ⭐️ [FIX] FacilityReviewService 타입을 인식하도록 수정 ⭐️
  FacilityDetailViewModel(this._facilityService, this._photoService, FacilityReviewService reviewService);

  // ⭐️ loadFacility 함수에서 사진도 함께 로드합니다.
  Future<void> loadFacility(String facilityId) async {
    _isLoading = true;
    _facility = null;
    notifyListeners();

    try {
      // 1. 공공 API에서 시설 정보 로드
      final facilityDataFuture = _facilityService.getFacilityDetail(facilityId);

      // 2. ⭐️ Firestore에서 이미지 URL 로드
      final photoUrlsFuture = _photoService.getPhotos(facilityId);

      // 두 비동기 작업을 동시에 기다립니다.
      final results = await Future.wait([facilityDataFuture, photoUrlsFuture]);
      final FacilityModel? facilityData = results[0] as FacilityModel?;
      final List<String> photoUrls = results[1] as List<String>;

      // 3. ⭐️ [합병] FacilityModel에 이미지 리스트를 넣어줍니다.
      if (facilityData != null) {
        _facility = FacilityModel(
          id: facilityData.id,
          name: facilityData.name,
          address: facilityData.address,
          phone: facilityData.phone,
          category: facilityData.category,

          // ⭐️ 로드된 사진 리스트를 images 필드에 할당
          images: photoUrls,

          // 나머지 필드는 기존 데이터 유지
          hours: facilityData.hours, price: facilityData.price,
          status: facilityData.status, reservation: facilityData.reservation,
          district: facilityData.district, rating: facilityData.rating,
          reviewCount: facilityData.reviewCount, distance: facilityData.distance,
          currentOccupancy: facilityData.currentOccupancy, maxCapacity: facilityData.maxCapacity,
        );
      } else {
        _facility = null;
      }

    } catch (e) {
      print("DetailViewModel Load Error: $e");
      _facility = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}