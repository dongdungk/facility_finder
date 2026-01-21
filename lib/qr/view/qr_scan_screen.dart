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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'QR 스캔',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, QRViewModel viewModel) {
    if (viewModel.uiState == QRState.entryComplete) {
      return _EntryCompleteView(viewModel: viewModel); // 분리된 위젯 호출
    }

    return Column(
      children: [
        const SizedBox(height: 40),
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
                _buildQRHomeIcon(),
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

                // ⭐️ 수정된 부분: 함수 대신 위젯 클래스 사용
                if (viewModel.uiState == QRState.permissionDenied)
                  const PermissionRequestButton(),
                if (viewModel.uiState == QRState.readyToScan)
                  const OpenCameraButton(),
              ],
            ),
          ),
        ),
        _buildBottomWarning(),
        const SizedBox(height: 40),
      ],
    );
  }

  // 아이콘 영역 분리
  Widget _buildQRHomeIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.qr_code_scanner, size: 60, color: Colors.white),
    );
  }

  // 하단 경고창 분리
  Widget _buildBottomWarning() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
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
    );
  }
}

// ⭐️ [리팩토링] 권한 요청 버튼 위젯
class PermissionRequestButton extends StatelessWidget {
  const PermissionRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => context.read<QRViewModel>().requestCameraPermission(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE3F2FD),
          foregroundColor: Colors.blue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.camera_alt, size: 20),
        label: const Text(
          "카메라 권한이 필요합니다\n권한을 허용해주세요",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ⭐️ [리팩토링] 카메라 열기 버튼 위젯
class OpenCameraButton extends StatelessWidget {
  const OpenCameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SimpleScannerScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C6EF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        label: const Text(
          "카메라 열기",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ⭐️ [리팩토링] 입장 완료 뷰 위젯
class _EntryCompleteView extends StatelessWidget {
  final QRViewModel viewModel;
  const _EntryCompleteView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final facility = viewModel.facilityData; // 이제 모델 객체임

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                _buildSuccessIcon(),
                const SizedBox(height: 20),
                const Text(
                  "입장 완료",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildInfoBox(facility),
                const SizedBox(height: 30),
                _buildExitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF00C853),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.check, size: 50, color: Colors.white),
    );
  }

  Widget _buildInfoBox(facility) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Column(
        children: [
          Text(
            facility?.name ?? "정보 없음",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            facility?.address ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildExitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => viewModel.exitFacility(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.exit_to_app, color: Colors.white),
        label: const Text(
          "퇴장하기",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
