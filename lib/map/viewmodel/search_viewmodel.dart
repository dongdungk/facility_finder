// lib/map/viewmodel/search_viewmodel.dart
import 'package:flutter/material.dart';

// ⭐️ "package:..." 대신 상대 경로 사용
import '../model/facility_model.dart';
import '../service/facility_service.dart';

class SearchViewModel extends ChangeNotifier {
  final FacilityService _facilityService;
  SearchViewModel(this._facilityService);

  List<FacilityModel> _facilities = [];
  List<FacilityModel> get facilities => _facilities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchFacilities(String query) async {
    _isLoading = true;
    notifyListeners(); // 1. 로딩 시작 알림

    // ⭐️⭐️⭐️ [최종 수정] ⭐️⭐️⭐️
    // 1. Service에게 "배드민턴만 + 지역구 필터링된" 목록을 요청합니다.
    List<FacilityModel> finalFilteredList = await _facilityService.searchFacilities(query);

    // 2. ViewModel은 받은 목록을 그대로 사용합니다. (중복 필터 제거)
    _facilities = finalFilteredList;

    _isLoading = false;
    notifyListeners(); // 3. 최종 목록으로 화면 갱신 알림
  }
}