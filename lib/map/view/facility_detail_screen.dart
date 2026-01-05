// lib/map/view/facility_detail_screen.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// (이하 import는 동일)
import '/map/model/facility_model.dart';
import '/map/viewmodel/facility_detail_viewmodel.dart';

class FacilityDetailScreen extends StatefulWidget {
  final String facilityId;

  const FacilityDetailScreen({super.key, required this.facilityId});

  @override
  State<FacilityDetailScreen> createState() => _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends State<FacilityDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityDetailViewModel>().loadFacility(widget.facilityId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<String> getImageUrl(String path) async {
    // gs:// 경로를 사용하여 참조(Reference)를 만듭니다.
    print(path);
    final ref = FirebaseStorage.instance.refFromURL(
      "gs://badminfinder-84d4d.firebasestorage.app/$path",
    );

    // 실제 네트워크에서 사용 가능한 https:// 주소를 가져옵니다.
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FacilityDetailViewModel>();
    final FacilityModel? facility = viewModel.facility;

    return Scaffold(
      appBar: AppBar(
        title: Text(facility?.name ?? '로딩 중...'),
        actions: [
          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : facility == null
          ? const Center(child: Text('시설 정보를 불러오는 데 실패했습니다.'))
          : _buildContentLoaded(context, facility),
    );
  }

  Widget _buildContentLoaded(BuildContext context, FacilityModel facility) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ⭐️ [수정] 1. "진짜" 이미지 목록(facility.images)을 사용
          _buildImageSlider(facility.images),

          // 2. 탭 바 (동일)
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [_buildTab('정보'), _buildTab('리뷰'), _buildTab('사진')],
            onTap: (index) {
              if (index == 1) {
                // '리뷰' 탭
                context.push('/facility/${widget.facilityId}/reviews');
              } else if (index == 2) {
                // '사진' 탭
                context.push('/facility/${widget.facilityId}/photos');
              }
              _tabController.animateTo(0);
            },
          ),

          // 3. '정보' 탭 컨텐츠
          _buildInfoTabContent(facility),
        ],
      ),
    );
  }

  // ⭐️ 1. [수정] "가짜" tempImages 삭제
  Widget _buildImageSlider(List<String> images) {
    // (final List<String> tempImages = [...] <-- "가짜" 데이터 삭제!)

    // 이미지가 하나도 없을 경우 빈 회색 상자를 표시
    if (images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey[400],
          size: 50,
        ),
      );
    }

    return Container(
      height: 250,
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          // itemBuilder 내부에서 직접 await 하지 말고 FutureBuilder를 반환합니다.
          return FutureBuilder<String>(
            future: getImageUrl(images[index]), // URL을 가져오는 비동기 함수
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // URL을 로딩 중일 때 표시할 위젯
                return Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                // URL 로드 실패 시
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error_outline, color: Colors.grey),
                );
              }

              // URL 로드 성공 시 이미지 표시
              return Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error_outline, color: Colors.grey),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // 탭 위젯 (이전과 동일)
  Widget _buildTab(String title) {
    return Tab(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ⭐️ 2. [수정] "가짜" 인원 수 텍스트를 "진짜" Model 데이터로 교체
  Widget _buildInfoTabContent(FacilityModel facility) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (이름, 평점, 주소 등은 모두 동일)
          Text(
            facility.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                facility.rating.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${facility.reviewCount} 리뷰)',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.location_on_outlined,
            '주소',
            facility.address,
            trailingWidget: TextButton(
              child: const Text('복사'),
              onPressed: () {
                /* TODO */
              },
            ),
          ),
          _buildInfoRow(Icons.access_time_outlined, '운영시간', facility.hours),
          _buildInfoRow(
            Icons.call_outlined,
            '전화번호',
            facility.phone,
            trailingWidget: TextButton(
              child: const Text('전화'),
              onPressed: () {
                /* TODO */
              },
            ),
          ),
          _buildInfoRow(
            Icons.info_outline,
            '시설정보',
            '${facility.category}입니다. ${facility.price}. 현재 ${facility.status}이며, ${facility.reservation} 상태입니다.',
          ),
          const SizedBox(height: 24),
          const Text(
            '시설 현황',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '현재 "${facility.status}"입니다.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: facility.status == '운영중'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),

                // ⭐️ 2. [수정 완료] "가짜" 텍스트를 "진짜" Model 데이터로 교체
                // (1단계에서 Model에 추가한 필드를 사용합니다)
                Text(
                  '약 ${facility.currentOccupancy}명 (${facility.maxCapacity}명 정원)',
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 헬퍼 Row (이전과 동일)
  Widget _buildInfoRow(
    IconData icon,
    String title,
    String content, {
    Widget? trailingWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(content, style: const TextStyle(fontSize: 16))),
          if (trailingWidget != null) trailingWidget,
        ],
      ),
    );
  }
}
