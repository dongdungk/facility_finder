// lib/map/viewmodel/facility_photo_viewmodel.dart (새로 생성)

import 'package:flutter/material.dart';
import '../service/facility_photo_service.dart';

class FacilityPhotoViewModel extends ChangeNotifier {

  final PhotoService _photoService;

  List<String> _photoUrls = [];
  bool _isLoading = false;

  List<String> get photoUrls => _photoUrls;
  bool get isLoading => _isLoading;

  FacilityPhotoViewModel(this._photoService);

  Future<void> loadPhotos(String facilityId) async {

    _isLoading = true;
    notifyListeners();

    try {
      _photoUrls = await _photoService.getPhotos(facilityId);
    } catch (e) {
      print("PhotoViewModel Load Error: $e");
      _photoUrls = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}