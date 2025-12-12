// lib/map/view/favorite_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// ⭐️ [수정] LoginViewModel 경로: lib/map/view/ 에서 '../../login/viewmodel/'로 이동
import '../../login/viewmodel/login_viewmodel.dart';


// ... (나머지 코드는 그대로)


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  // ⭐️ [최종 Mock 데이터] 실내 배드민턴장 위주로 구성
  final List<Map<String, dynamic>> favoriteList = [
    {
      "id": "마곡레포츠센터 실내배드민턴장",
      "name": "마곡레포츠센터 실내배드민턴장",
      "distance": "2.3km",
      "rating": 4.9,
      "congestion": 42.0,
      "maxCapacity": 80.0
    },
    {
      "id": "초안산 실내배드민턴장",
      "name": "초안산 실내배드민턴장",
      "distance": "5.1km",
      "rating": 4.8,
      "congestion": 15.0,
      "maxCapacity": 50.0
    },
    {
      "id": "오동근린공원 실내배드민턴장",
      "name": "오동근린공원 실내배드민턴장",
      "distance": "3.5km",
      "rating": 4.7,
      "congestion": 60.0,
      "maxCapacity": 100.0
    },
    {
      "id": "금화배드민턴장",
      "name": "금화배드민턴장",
      "distance": "1.8km",
      "rating": 4.5,
      "congestion": 20.0,
      "maxCapacity": 40.0
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: '검색창 : ',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey[400]),
          ),
          onTap: () {
            context.push('/search');
          },
        ),
        actions: [
          // ⭐️ [로그아웃 버튼]
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await context.read<LoginViewModel>().signOut();
              if (!context.mounted) return; // 위젯이 마운트된 상태인지 확인
              context.go('/login');
            },
          ),
          // 기존 별표 아이콘
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: () {
              // 즐겨찾기 목록이므로 여기서 할 일은 없음
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              '즐겨찾기 목록',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: favoriteList.isEmpty
                ? const Center(
              child: Text(
                '즐겨찾기한 시설이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final item = favoriteList[index];
                return InkWell(
                  onTap: () {
                    // ID(시설명)을 상세 페이지로 전달
                    context.push('/facility/${item['id']}');
                  },
                  child: _buildFavoriteCard(
                    name: item['name'],
                    distance: item['distance'],
                    rating: item['rating'],
                    congestion: item['congestion'],
                    maxCapacity: item['maxCapacity'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- 헬퍼 함수 및 커스텀 클래스 (const 오류 해결됨) ---
  Widget _buildFavoriteCard({
    required String name,
    required String distance,
    required double rating,
    required double congestion,
    required double maxCapacity,
  }) {
    final Color congestionColor = _getCongestionColor(congestion, maxCapacity);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  distance,
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ..._buildStarRating(rating),
                const SizedBox(width: 8),
                Text(rating.toString(), style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6.0,
                trackShape: const _GradientTrackShape(), // ⭐️ const 문제 해결됨
                thumbShape: _ChipThumbShape( // ⭐️ const 문제 해결됨
                  congestion: congestion.toInt(),
                  color: congestionColor,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: congestion,
                min: 0,
                max: maxCapacity,
                onChanged: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('쾌적', style: TextStyle(color: Colors.green.shade700)),
                  Text('혼잡', style: TextStyle(color: Colors.red.shade700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStarRating(double rating, {double size = 20}) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double halfStar = rating - fullStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: size));
    }
    if (halfStar >= 0.1) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: size));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: size));
    }
    return stars;
  }

  Color _getCongestionColor(double congestion, double maxCapacity) {
    double ratio = congestion / maxCapacity;
    if (ratio < 0.33) {
      return Colors.green.shade600;
    } else if (ratio < 0.66) {
      return Colors.yellow.shade700;
    } else {
      return Colors.red.shade600;
    }
  }

  String _getCongestionStatus(double congestion, double maxCapacity) {
    double ratio = congestion / maxCapacity;
    if (ratio < 0.33) {
      return '쾌적';
    } else if (ratio < 0.66) {
      return '보통';
    } else {
      return '혼잡';
    }
  }
}

class _GradientTrackShape extends SliderTrackShape {
  const _GradientTrackShape(); // ⭐️ const 생성자
  static const LinearGradient gradient = LinearGradient(
    colors: [Colors.green, Colors.yellow, Colors.red],
  );

  @override
  Rect getPreferredRect({
    required RenderBox parentBox, Offset offset = Offset.zero, required SliderThemeData sliderTheme,
    bool isEnabled = false, bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context, Offset offset, {
        required RenderBox parentBox, required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation, required TextDirection textDirection,
        required Offset thumbCenter, Offset? secondaryOffset, bool isEnabled = false,
        bool isDiscrete = false,
      }) {
    final Rect trackRect = getPreferredRect(parentBox: parentBox, offset: offset, sliderTheme: sliderTheme);
    final Paint paint = Paint()..shader = gradient.createShader(trackRect);
    final RRect trackRRect = RRect.fromRectAndRadius(trackRect, Radius.circular(sliderTheme.trackHeight! / 2));
    context.canvas.drawRRect(trackRRect, paint);
  }
}

class _ChipThumbShape extends SliderComponentShape {
  final int congestion;
  final Color color;

  const _ChipThumbShape({required this.congestion, required this.color}); // ⭐️ const 생성자

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(48, 28);
  }

  @override
  void paint(
      PaintingContext context, Offset center, {
        required Animation<double> activationAnimation, required Animation<double> enableAnimation,
        required bool isDiscrete, required TextPainter labelPainter, required RenderBox parentBox,
        required SliderThemeData sliderTheme, required TextDirection textDirection,
        required double value, required double textScaleFactor, required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..color = color;
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center.translate(0, -10), width: 44, height: 24),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, paint);
    final Paint borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);
    final TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      text: '${congestion}명',
    );
    final TextPainter tp = TextPainter(
      text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr,
    );
    tp.layout();
    final Offset textOffset = center.translate(-tp.width / 2, -10 - tp.height / 2);
    tp.paint(canvas, textOffset);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }
}