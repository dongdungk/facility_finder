// lib/qr/viewmodel/qr_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../service/qr_service.dart';

enum QRState { permissionDenied, readyToScan, scanning, entryComplete }

class QRViewModel extends ChangeNotifier {
  final QRService _qrService;

  QRState _uiState = QRState.readyToScan; // 초기 상태
  Map<String, dynamic>? _facilityData;
  bool _isLoading = false;

  QRViewModel(this._qrService) {
    _checkPermission();
  }

  QRState get uiState => _uiState;
  Map<String, dynamic>? get facilityData => _facilityData;
  bool get isLoading => _isLoading;

  // 1. 초기 권한 확인
  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      _uiState = QRState.readyToScan;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _uiState = QRState.permissionDenied;
    }
    notifyListeners();
  }

  // 2. 권한 요청 (버튼 클릭 시)
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _uiState = QRState.readyToScan;
    } else {
      _uiState = QRState.permissionDenied;
      // 설정 화면으로 유도하는 로직을 UI에서 처리하도록 할 수도 있음
      openAppSettings();
    }
    notifyListeners();
  }

  // 3. QR 스캔 처리
  Future<void> processQR(String qrData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _qrService.verifyQRCode(qrData);
      if (result['success'] == true) {
        _facilityData = result;
        _uiState = QRState.entryComplete; // 입장 완료 상태로 변경
      }
    } catch (e) {
      print("QR Error: $e");
      // 에러 처리 (스낵바 등)
    }

    _isLoading = false;
    notifyListeners();
  }

  // 4. 퇴장하기 (초기화)
  void exitFacility() {
    _facilityData = null;
    _uiState = QRState.readyToScan; // 다시 스캔 준비 상태로
    notifyListeners();
  }
}