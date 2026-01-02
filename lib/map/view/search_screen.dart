// lib/map/view/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/search_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();// Consumer Widegt 으로 제공

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: '지역구 또는 시설명 검색 (예: 강남, 스터디카페)',
            border: InputBorder.none,
          ),
          onSubmitted: (value) => viewModel.search(value),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => viewModel.search(_controller.text),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: viewModel.results.length,
        itemBuilder: (context, index) {
          final facility = viewModel.results[index];
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: Text(facility.name),
            subtitle: Text(facility.address),
            trailing: Text(facility.category,
                style: TextStyle(color: facility.category == '스터디카페' ? Colors.orange : Colors.green)),
            onTap: () {
              // 상세 페이지로 이동 시 카카오 시설 여부 전달
              bool isKakao = facility.category == '스터디카페';
              context.push('/facility/${facility.id}', extra: {'isKakao': isKakao});
            },
          );
        },
      ),
    );
  }
}