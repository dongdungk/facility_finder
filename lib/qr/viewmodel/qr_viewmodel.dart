// lib/qr/viewmodel/qr_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../service/qr_firestoreservice.dart';
import '../../map/model/firestore_facility_model.dart';

/// QR 스캔 및 입장 상태를 관리하는 Enum
enum QRState { permissionDenied, readyToScan, scanning, entryComplete, error }

class QRViewModel extends ChangeNotifier {
  final QRFirestoreService _qrService;

  // 상태 관리 변수들
  QRState _uiState = QRState.readyToScan;
  FirestoreFacilityModel? _facilityData; // 이제 명확히 모델 타입을 가집니다.
  bool _isLoading = false;
  String? _errorMessage;

  /// 생성자: 서비스 주입 및 초기 권한 확인
  QRViewModel(this._qrService) {
    _checkPermission();
  }

  // Getter 영역
  QRState get uiState => _uiState;
  FirestoreFacilityModel? get facilityData => _facilityData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. 초기 권한 확인 로직
  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      _uiState = QRState.readyToScan;
    } else {
      // 거부되었거나 아직 요청 전인 경우
      _uiState = QRState.permissionDenied;
    }
    notifyListeners();
  }

  // 2. 카메라 권한 직접 요청 (UI 버튼 클릭 시)
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _uiState = QRState.readyToScan;
    } else if (status.isPermanentlyDenied) {
      // 사용자가 완전히 거부한 경우 설정창으로 유도
      await openAppSettings();
    } else {
      _uiState = QRState.permissionDenied;
    }
    notifyListeners();
  }

  // 3. QR 데이터 처리 (Firestore 연동)
  Future<void> processQR(String qrData) async {
    // 로딩 시작 및 에러 초기화
    _isLoading = true;
    _errorMessage = null;
    _uiState = QRState.scanning; // 스캔 중 상태로 변경
    notifyListeners();

    try {
      // 서비스로부터 모델 객체를 직접 받아옴
      final facility = await _qrService.getFacilityById(qrData);

      if (facility != null) {
        _facilityData = facility;
        _uiState = QRState.entryComplete; // 데이터가 있으면 입장 완료
      } else {
        _errorMessage = "시설 정보를 찾을 수 없습니다. (ID: $qrData)";
        _uiState = QRState.error;
      }
    } catch (e) {
      // 서비스 내부에서 발생한 에러 처리
      print("QR Processing Error: $e");
      _errorMessage = "데이터베이스 서버와의 통신에 실패했습니다.";
      _uiState = QRState.error;
    } finally {
      // 성공/실패 여부와 상관없이 로딩 종료
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. 퇴장 처리 및 상태 초기화
  void exitFacility() {
    _facilityData = null;
    _errorMessage = null;
    _uiState = QRState.readyToScan; // 다시 스캔 가능 상태로 되돌림
    notifyListeners();
  }

  // 5. 에러 발생 시 다시 시도하기 위한 초기화
  void resetState() {
    _uiState = QRState.readyToScan;
    _errorMessage = null;
    notifyListeners();
  }
}
