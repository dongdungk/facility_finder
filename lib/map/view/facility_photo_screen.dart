// lib/map/view/facility_photo_screen.dart (최종 완성본)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/facility_photo_viewmodel.dart';

class FacilityPhotoScreen extends StatefulWidget {
  final String facilityId;

  const FacilityPhotoScreen({super.key, required this.facilityId});

  @override
  State<FacilityPhotoScreen> createState() => _FacilityPhotoScreenState();
}

class _FacilityPhotoScreenState extends State<FacilityPhotoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['전체', '클럽', '방문자', '블로그', '인스타'];

  // ⭐️ [FIX 1] 데이터 로딩이 한 번만 실행되도록 플래그 추가 (가장 중요)
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // ❌ initState에서 Provider 호출 로직 제거 (Build에서 수행)
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // ⭐️⭐️⭐️ [FIX 2] Provider가 확실히 유효할 때, 로딩을 단 한 번만 실행합니다. ⭐️⭐️⭐️
    if (!_dataLoaded) {
      // BuildContext가 완전히 유효할 때만 Provider에 접근합니다.
      context.read<FacilityPhotoViewModel>().loadPhotos(widget.facilityId);
      _dataLoaded = true;
    }
    // ⭐️⭐️⭐️ ----------------------------------------------------------- ⭐️⭐️⭐️

    return Scaffold(
      appBar: AppBar(
        title: const Text('시설 사진', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<FacilityPhotoViewModel>(
        builder: (context, photoVM, child) {
          if (photoVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ... (나머지 UI 로직은 동일) ...

          if (photoVM.photoUrls.isEmpty) {
            return const Center(child: Text('등록된 사진이 없습니다. 첫 사진을 올려보세요!'));
          }

          return Column(
            children: [
              // 1. 사진 개수 및 업로드 버튼 섹션 (전체 UI는 그대로 유지)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () { /* 사진 보기 기능 */ },
                        icon: const Icon(Icons.photo_library_outlined, color: Colors.black54, size: 20),
                        label: Text(
                          '사진 ${photoVM.photoUrls.length}장',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () { /* 사진 업로드 기능 */ },
                      icon: const Icon(Icons.upload_file, size: 20, color: Colors.white),
                      label: const Text('사진 올리기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              // 2. 탭 바
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blueAccent,
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
              const Divider(height: 1, thickness: 1),
              // 3. 사진 그리드 뷰
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((tab) {
                    if (tab == '전체') {
                      return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: photoVM.photoUrls.length,
                        itemBuilder: (context, index) {
                          final String imageUrl = photoVM.photoUrls[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('$tab 사진 (준비 중)'));
                    }
                  }).toList(),
                ),
              ),
              // 4. 사진 더보기 버튼
              if (photoVM.photoUrls.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () { /* '사진 더보기' 기능 */ },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        '사진 더보기 (${photoVM.photoUrls.length}장)',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}