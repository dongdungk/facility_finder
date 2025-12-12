// lib/map/view/search_screen.dart

// lib/map/view/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// ⭐️ [수정 1] LoginViewModel 경로: lib/map/view/ 에서 '../../login/viewmodel/'로 이동
import '../../login/viewmodel/login_viewmodel.dart';
// ⭐️ [수정 2] FacilityModel 경로: lib/map/view/ 에서 '../model/'로 이동
import '../model/facility_model.dart';
// ⭐️ [수정 3] SearchViewModel 경로: lib/map/view/ 에서 '../viewmodel/'로 이동
import '../viewmodel/search_viewmodel.dart';

// ... (나머지 코드는 그대로)


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            // ⭐️ [수정] 영어 검색만 유도
            hintText: '시설 검색 (예: songpa, guro, gangnam)',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
          ),
          onSubmitted: (String query) {
            context.read<SearchViewModel>().searchFacilities(query);
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
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.black),
            onPressed: () {
              context.push('/favorites');
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
              '특정시설 검색 목록',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, viewModel, child) {

                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.facilities.isEmpty) {
                  return const Center(
                    child: Text(
                      '검색 결과가 없습니다. (예: songpa, guro)',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: viewModel.facilities.length,
                  itemBuilder: (context, index) {
                    final facility = viewModel.facilities[index];
                    return _buildFacilityResultCard(context, facility);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityResultCard(
      BuildContext context, FacilityModel facility) {

    Color statusColor;
    switch (facility.status) {
      case '운영': statusColor = Colors.green; break;
      case '휴관': statusColor = Colors.orange; break;
      default: statusColor = Colors.red;
    }

    Color reservationColor;
    switch (facility.reservation) {
      case '가능': reservationColor = Colors.blue; break;
      case '불가능': reservationColor = Colors.grey; break;
      default: reservationColor = Colors.purple;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // ID(시설명)을 상세 화면으로 전달
          context.push('/facility/${facility.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 이름 / 거리
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      facility.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    facility.distance, // 👈 Mock Data (e.g., 2.5km)
                    style: const TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 2. 주소
              Text(
                facility.address,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // 3. 운영시간 / 전화번호
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(facility.hours, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(facility.price, style: const TextStyle(fontSize: 14)), // 👈 Mock Data (e.g., 무료)
                  const SizedBox(width: 12),
                  const Icon(Icons.call_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(facility.phone, style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),

              // 4. 예약 가능 / 운영 상태 (칩)
              Row(
                children: [
                  Chip(
                    label: Text(facility.reservation),
                    backgroundColor: reservationColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: reservationColor, fontSize: 13),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(facility.status),
                    backgroundColor: statusColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: statusColor, fontSize: 13),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}