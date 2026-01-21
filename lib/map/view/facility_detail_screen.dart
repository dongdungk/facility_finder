import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../model/facility_model.dart';
import '../viewmodel/facility_detail_viewmodel.dart';

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
    // 탭 3개: 정보, 리뷰, 사진
    _tabController = TabController(length: 3, vsync: this);

    // 화면이 그려진 직후 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityDetailViewModel>().loadFacility(widget.facilityId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Firebase Storage의 gs:// 경로를 실제 이미지 URL로 변환합니다.
  Future<String> getImageUrl(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      var url = await ref.getDownloadURL();
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Storage Image Error: $e");
      throw Exception("이미지 로드 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FacilityDetailViewModel>();
    final FacilityModel? facility = viewModel.facility;

    return Scaffold(
      appBar: AppBar(
        title: Text(facility?.name ?? '로딩 중...'),
        actions: [
          // ⭐️ 즐겨찾기 아이콘: 클릭 시 /favorites로 이동
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // router.dart에서 상향 조정한 /favorites 경로로 이동합니다.
              context.push('/favorites');
            },
          ),
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
          // 1. 상단 이미지 슬라이더 (실제 데이터 사용)
          _buildImageSlider(facility.images),

          // 2. 탭 바
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [_buildTab('정보'), _buildTab('리뷰'), _buildTab('사진')],
            onTap: (index) {
              if (index == 1) {
                // '리뷰' 탭 클릭 시 이동
                context.push('/facility/${widget.facilityId}/reviews');
              } else if (index == 2) {
                // '사진' 탭 클릭 시 이동
                context.push('/facility/${widget.facilityId}/photos');
              }
              // 상세 페이지로 돌아왔을 때 항상 '정보' 탭이 보이도록 고정
              _tabController.animateTo(0);
            },
          ),

          // 3. '정보' 탭 내용
          _buildInfoTabContent(facility),
        ],
      ),
    );
  }

  Widget _buildImageSlider(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.grey,
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length > 4 ? 4 : images.length, // 최대 4개까지만 그리드로 표시
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return FutureBuilder<String>(
            future: getImageUrl(images[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                );
              }
              return Image.network(snapshot.data!, fit: BoxFit.cover);
            },
          );
        },
      ),
    );
  }

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

  Widget _buildInfoTabContent(FacilityModel facility) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const Divider(height: 32),
          _buildInfoRow(Icons.location_on_outlined, '주소', facility.address),
          _buildInfoRow(Icons.access_time_outlined, '운영시간', facility.hours),
          _buildInfoRow(Icons.call_outlined, '전화번호', facility.phone),
          _buildInfoRow(
            Icons.info_outline,
            '시설정보',
            '${facility.category} / ${facility.price}',
          ),
          const SizedBox(height: 24),
          const Text(
            '시설 현황',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
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
                Text(
                  '약 ${facility.currentOccupancy}명 (${facility.maxCapacity}명 정원)',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}
