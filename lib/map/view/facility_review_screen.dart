import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../viewmodel/facility_review_viewmodel.dart';
import '../model/facility_review_model.dart';

class FacilityReviewScreen extends StatefulWidget {
  final String facilityId;

  const FacilityReviewScreen({super.key, required this.facilityId});

  @override
  State<FacilityReviewScreen> createState() => _FacilityReviewScreenState();
}

class _FacilityReviewScreenState extends State<FacilityReviewScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 로드될 때 해당 시설의 리뷰를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityReviewViewModel>().loadReviews(widget.facilityId);
    });
  }

  void _navigateToWriteReview(BuildContext context) {
    context.pushNamed(
      'writeReview',
      pathParameters: {
        'id': widget.facilityId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 (좋아요/삭제 권한 확인용)
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facilityId,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<FacilityReviewViewModel>(
        builder: (context, reviewVM, child) {
          if (reviewVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reviewVM.reviews.isEmpty) {
            return const Center(child: Text('등록된 리뷰가 없습니다.\n첫 리뷰를 작성해보세요!', textAlign: TextAlign.center));
          }

          // 통계 데이터 계산
          double averageRating = reviewVM.reviews.isEmpty
              ? 0.0
              : reviewVM.reviews.fold(0.0, (sum, item) => sum + item.rating) / reviewVM.reviews.length;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 요약 섹션 ---
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, color: Colors.amber, size: 36),
                        ],
                      ),
                      Text(
                        '총 ${reviewVM.reviews.length}개의 리뷰',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

                // --- 리뷰 리스트 섹션 ---
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviewVM.reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviewVM.reviews[index];
                    return ReviewListItem(
                      review: review,
                      currentUserId: currentUserId,
                      viewModel: reviewVM,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: currentUserId != null
          ? FloatingActionButton.extended(
        onPressed: () => _navigateToWriteReview(context),
        label: const Text('리뷰 작성'),
        icon: const Icon(Icons.edit),
      )
          : null,
    );
  }
}

class ReviewListItem extends StatelessWidget {
  final FacilityReviewModel review;
  final String? currentUserId;
  final FacilityReviewViewModel viewModel;

  const ReviewListItem({
    super.key,
    required this.review,
    this.currentUserId,
    required this.viewModel,
  });

  void _deleteReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰 삭제'),
        content: const Text('이 리뷰를 삭제할까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.deleteReview(review.id);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isUserReview = currentUserId == review.userId;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueGrey[100],
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0] : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      review.date.toString().substring(0, 10),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isUserReview)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                  onPressed: () => _deleteReview(context),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(review.text, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}