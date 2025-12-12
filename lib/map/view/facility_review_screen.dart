import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // User 객체 사용을 위해 추가
import 'package:go_router/go_router.dart'; // ⭐️ GoRouter 임포트 추가

import '../viewmodel/facility_review_viewmodel.dart';
import '../model/facility_review_model.dart';
import '../view/facility_review_edit_screen.dart'; // 수정 화면 임포트
import '../view/facility_review_write_screen.dart'; // 작성 화면 임포트

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacilityReviewViewModel>().loadReviews(widget.facilityId);
    });
  }

  // ⭐️ 새 리뷰 작성 화면으로 GoRouter를 이용해 이동하는 함수
  void _navigateToWriteReview(BuildContext context) {
    // router.dart에 정의된 'writeReview' 경로를 사용
    context.pushNamed(
      'writeReview',
      pathParameters: {
        'id': widget.facilityId, // Facility ID를 부모 경로 파라미터로 전달
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⭐️ 현재 로그인한 사용자 정보 가져오기 (main.dart의 StreamProvider 활용)
    final User? currentUser = context.watch<User?>();
    final String? currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facilityId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<FacilityReviewViewModel>(
        builder: (context, reviewVM, child) {
          if (reviewVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reviewVM.reviews.isEmpty) {
            return const Center(child: Text('등록된 리뷰가 없습니다. 첫 리뷰를 작성해보세요!'));
          }

          // 평균 별점 계산
          double averageRating = reviewVM.reviews.fold(0.0, (sum, item) => sum + item.rating) / reviewVM.reviews.length;
          // 각 별점 개수 계산
          Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
          for (var review in reviewVM.reviews) {
            ratingCounts[review.rating.toInt()] = (ratingCounts[review.rating.toInt()] ?? 0) + 1;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.facilityId,
                        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            averageRating.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: Colors.amber, size: 30),
                        ],
                      ),
                      Text(
                        '${reviewVM.reviews.length}개 리뷰',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      // 별점 통계 바
                      ...List.generate(5, (index) {
                        int star = 5 - index;
                        int count = ratingCounts[star] ?? 0;
                        double percentage = reviewVM.reviews.isEmpty ? 0 : count / reviewVM.reviews.length;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 25,
                                child: Text('$star', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: percentage,
                                  backgroundColor: Colors.grey[200],
                                  color: Colors.amber,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 35,
                                child: Text(
                                  '${(percentage * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '$count',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviewVM.reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviewVM.reviews[index];
                    return ReviewListItem(
                      review: review,
                      currentUserId: currentUserId,
                      viewModel: reviewVM, // 삭제 기능을 위해 VM 전달
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      // ⭐️ 리뷰 작성 버튼 (로그인 사용자만)
      floatingActionButton: currentUserId != null
          ? FloatingActionButton.extended(
        onPressed: () => _navigateToWriteReview(context), // GoRouter로 이동
        label: const Text('리뷰 작성'),
        icon: const Icon(Icons.edit_note),
      )
          : null,
    );
  }
}

// 리뷰 목록 아이템 위젯
class ReviewListItem extends StatelessWidget {
  final FacilityReviewModel review;
  final String? currentUserId; // 현재 로그인된 사용자 ID
  final FacilityReviewViewModel viewModel; // 삭제/수정을 위해 ViewModel 참조

  const ReviewListItem({
    super.key,
    required this.review,
    this.currentUserId,
    required this.viewModel,
  });

  // ⭐️ 수정 화면으로 GoRouter를 이용해 이동하는 함수
  void _navigateToEditScreen(BuildContext context) {
    context.pushNamed(
      'editReview', // router.dart에 정의된 name
      pathParameters: {
        'id': review.facilityId, // 부모 경로 (/facility/:id)의 파라미터
        'reviewId': review.id, // 현재 경로의 파라미터
      },
      extra: review, // FacilityReviewModel 객체 전체를 전달
    );
  }

  // ⭐️ 리뷰 삭제 함수
  void _deleteReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰 삭제'),
        content: const Text('정말로 이 리뷰를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // 다이얼로그 닫기
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
    // 리뷰 작성자가 현재 사용자인지 확인
    final bool isUserReview = currentUserId == review.userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 프로필 이미지 (임시)
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueGrey,
                child: Text(
                  // ⭐️ [FIX 1] RangeError 방어: userName이 비어있으면 '?' 표시
                  review.userName.isNotEmpty ? review.userName.substring(0, 1) : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),

                        // ⭐️ 수정/삭제 메뉴 (작성자에게만 표시)
                        if (isUserReview)
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _navigateToEditScreen(context);
                              } else if (value == 'delete') {
                                _deleteReview(context);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('수정'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('삭제'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                          )
                        else
                        // 우측 상단의 댓글/대화 아이콘 (작성자가 아닐 경우)
                          const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
                      ],
                    ),
                    Text(
                      // ⭐️ [FIX 2] RangeError 방어: 문자열 길이가 10자 미만이면 전체 출력
                      review.date.toString().length >= 10
                          ? review.date.toString().substring(0, 10)
                          : review.date.toString(),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 별점
          Row(
            children: List.generate(review.rating.toInt(), (i) => const Icon(Icons.star, color: Colors.amber, size: 16)),
          ),
          const SizedBox(height: 4),
          Text(
            review.text,
            style: const TextStyle(fontSize: 16, height: 1.4), // 가독성 향상
          ),
          const SizedBox(height: 10),
          // 좋아요/댓글 섹션
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text('도움돼요 ${review.likes}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(width: 16),
              const Icon(Icons.comment_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text('댓글 ${review.comments}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
        ],
      ),
    );
  }
}