// lib/map/viewmodel/search_viewmodel.dart
import 'package:flutter/material.dart';
import '../model/facility_model.dart';
import '../service/facility_service.dart';
import '../service/kakao_service.dart'; // ⭐️ KakaoService 추가

class SearchViewModel extends ChangeNotifier {
  final FacilityService _facilityService;
  final KakaoService _kakaoService;

  SearchViewModel(this._facilityService, this._kakaoService);

  List<FacilityModel> _results = [];
  List<FacilityModel> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> search(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 서울시 API와 카카오 API 결과를 병렬로 호출하여 합칩니다.
      final responses = await Future.wait([
        _facilityService.searchFacilities(query),
        _kakaoService.searchStudyCafes(query),
      ]);

      _results = [...responses[0], ...responses[1]];
    } catch (e) {
      print("검색 에러: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}