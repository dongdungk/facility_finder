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

// 1. TickerProviderStateMixin 추가
class _SimpleScannerScreenState extends State<SimpleScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanned = false;

  // 2. AnimationController 선언
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // 3. AnimationController 초기화 (2초 동안 반복)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    // 4. Controller 해제
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 태깅'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center, // 자식들을 중앙에 배치
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _isScanned = true;
                  context.read<QRViewModel>().processQR(barcode.rawValue!);
                  Navigator.of(context).pop();
                  break;
                }
              }
            },
          ),

          // 5. 스캔 영역 및 애니메이션 UI
          SizedBox(
            width: 250,
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // 스캔 영역 테두리
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // 움직이는 스캐너 라인
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      // controller.value가 0.0 -> 1.0 으로 변함
                      // 이를 이용해 라인의 top 위치를 계산 (높이 - 라인높이)
                      final topPosition = _animationController.value * (250 - 4);

                      return Positioned(
                        top: topPosition,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.greenAccent,
                                blurRadius: 10.0,
                                spreadRadius: 3.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 하단 안내 문구
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
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