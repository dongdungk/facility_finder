// lib/qr/view/qr_scan_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/qr_viewmodel.dart';
import 'simple_scanner_screen.dart';

class QRScanScreen extends StatelessWidget {
  const QRScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QRViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[50], // 배경색 살짝 회색
      appBar: AppBar(
        title: const Text('QR 스캔', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, QRViewModel viewModel) {
    // 1. 입장 완료 상태 (오른쪽 이미지)
    if (viewModel.uiState == QRState.entryComplete) {
      return _buildEntryCompleteView(context, viewModel);
    }

    // 2. 스캔 전 대기 상태 (왼쪽/가운데 이미지)
    return Column(
      children: [
        const SizedBox(height: 40),
        // 메인 카드 영역
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QR 아이콘 (이미지 에셋 대신 아이콘으로 대체)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.qr_code_scanner, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 30),
                const Text(
                  "QR 코드를 스캔하세요",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "시설 입구의 QR 코드를 스캔하여\n입장을 기록할 수 있습니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 40),

                // ⭐️ 상태에 따른 버튼 분기 (왼쪽 vs 가운데)
                if (viewModel.uiState == QRState.permissionDenied)
                  _buildPermissionButton(viewModel), // 회색 권한 버튼
                if (viewModel.uiState == QRState.readyToScan)
                  _buildCameraButton(context),       // 파란색 카메라 열기 버튼
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        // 하단 경고 문구
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1), // 연한 노란색
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "QR 코드는 시설 입구에 부착되어 있습니다.\n입장 시 QR 코드를 스캔해주세요.",
                  style: TextStyle(fontSize: 12, color: Colors.brown),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // [State 1] 권한 필요 버튼 (왼쪽 이미지)
  Widget _buildPermissionButton(QRViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => viewModel.requestCameraPermission(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE3F2FD), // 연한 파란색 배경
          foregroundColor: Colors.blue,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.camera_alt, size: 20),
        label: const Text("카메라 권한이 필요합니다\n권한을 허용해주세요", textAlign: TextAlign.center),
      ),
    );
  }

  // [State 2] 카메라 열기 버튼 (가운데 이미지)
  Widget _buildCameraButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          // ⭐️ 카메라 스캔 화면으로 이동 (전체 화면 or 모달)
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SimpleScannerScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C6EF5), // 쨍한 파란색
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        label: const Text("카메라 열기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // [State 3] 입장 완료 화면 (오른쪽 이미지)
  Widget _buildEntryCompleteView(BuildContext context, QRViewModel viewModel) {
    final facility = viewModel.facilityData;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 카드 영역
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                // 체크 아이콘
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853), // 녹색
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.check, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text("입장 완료", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("현재 시설에 입장 중입니다", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),

                // 시설 정보 박스
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9), // 연한 녹색
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        facility?['facilityName'] ?? "시설 정보 없음",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        facility?['address'] ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 퇴장하기 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      viewModel.exitFacility();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63), // 핑크/레드
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text("퇴장하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          // 하단 팁
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lightbulb, size: 16, color: Colors.amber),
              SizedBox(width: 5),
              Text(
                "퇴장 버튼을 눌러 시설에서 퇴장할 수 있습니다.",
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}