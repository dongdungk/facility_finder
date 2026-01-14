import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // ⭐️ 구글 맵 임포트
import 'package:provider/provider.dart';
import '../../login/viewmodel/login_viewmodel.dart';

class MapMainScreen extends StatefulWidget {
  const MapMainScreen({super.key});

  @override
  State<MapMainScreen> createState() => _MapMainScreenState();
}

class _MapMainScreenState extends State<MapMainScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.5665, 126.9780); // 서울 시청

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // 그리드뷰에 표시될 시설 리스트
  final List<Map<String, String>> facilities = [
    {
      "id": "월곡배드민턴장",
      "name": "월곡배드민턴장",
      "location": "성북구",
      "imageUrl": "assets/AKR20240416124700060_01_i_P4.jpg",
    },
    {
      "id": "매봉산실내배드민턴장",
      "name": "매봉산실내배드민턴장",
      "location": "강남구",
      "imageUrl": "assets/badminton_img0302.jpg",
    },
    {
      "id": "마곡레포츠센터 실내배드민턴장",
      "name": "마곡레포츠센터 실내배드민턴장",
      "location": "강서구",
      "imageUrl": "assets/cts5395_img07.jpg",
    },
    {
      "id": "금화배드민턴장",
      "name": "금화배드민턴장",
      "location": "서대문구",
      "imageUrl": "assets/img_yongwang.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: '장소를 검색해 보세요',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<LoginViewModel>().signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ⭐️ 구글 지도 위젯
            SizedBox(
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('gangnam_center'),
                    position: const LatLng(37.4936, 127.0623),
                    infoWindow: const InfoWindow(title: '강남스포츠센터'),
                    onTap: () => context.push('/facility/강남스포츠센터'),
                  ),
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '각 구별 인기 있는 시설들',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                final item = facilities[index];
                return _buildCard(context, item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> item) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/facility/${item['id']}'),
        child: Column(
          children: [
            Image.asset(
              item['imageUrl']!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Text(
              item['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(item['location']!),
          ],
        ),
      ),
    );
  }
}
