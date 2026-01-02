// lib/qr/view/simple_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../viewmodel/qr_viewmodel.dart';

class SimpleScannerScreen extends StatefulWidget {
  const SimpleScannerScreen({super.key});

  @override
  State<SimpleScannerScreen> createState() => _SimpleScannerScreenState();
}

class _SimpleScannerScreenState extends State<SimpleScannerScreen> {
  // 중복 스캔 방지용 플래그
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 태깅'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        // 카메라 화면 위에 AppBar를 겹치게 하려면 extendBodyBehindAppBar 사용 가능
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            // QR이 감지되었을 때 콜백
            onDetect: (capture) {
              if (_isScanned) return; // 이미 스캔되었다면 무시

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _isScanned = true; // 플래그 설정

                  // ViewModel에 스캔된 데이터 전달
                  context.read<QRViewModel>().processQR(barcode.rawValue!);

                  // 스캔 화면 닫기
                  Navigator.of(context).pop();
                  break;
                }
              }
            },
          ),
          // 스캔 가이드라인 (선택사항)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // 하단 안내 문구
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: const Text(
              "QR 코드를 사각형 안에 비춰주세요",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}