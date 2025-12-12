// lib/map/viewmodel/facility_review_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/facility_review_service.dart';
import '../model/facility_review_model.dart';

class FacilityReviewViewModel extends ChangeNotifier {
  final FacilityReviewService _reviewService;

  List<FacilityReviewModel> _reviews = [];
  bool _isLoading = false;

  // ⭐️ 상태 Getter
  List<FacilityReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;

  // 생성자
  FacilityReviewViewModel(this._reviewService);

  // ⭐️ 리뷰 목록 로드 (Stream 구독)
  // facility_review_screen.dart의 initState에서 이 함수를 호출합니다.
  void loadReviews(String facilityId) {
    _isLoading = true;
    notifyListeners();

    // Service의 Stream을 구독합니다. 데이터가 업데이트될 때마다 View가 갱신됩니다.
    _reviewService.getReviewsByFacilityId(facilityId).listen((newReviews) {
      _reviews = newReviews;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      // 에러 처리
      debugPrint('Error loading reviews: $error');
      _isLoading = false;
      notifyListeners();
    });
    // 💡 참고: 실제 앱에서는 StreamSubscription을 관리하여 dispose 시 구독을 취소해야 메모리 누수를 방지합니다.
  }

  // ⭐️ 리뷰 추가 함수 (화면에서 사용 가능)
  Future<void> addReview({
    required String facilityId,
    required String userId,
    required String userName,
    required double rating,
    required String content,
  }) async {
    try {
      await _reviewService.createReview(
        facilityId: facilityId,
        userId: userId,
        userName: userName,
        rating: rating,
        content: content,
      );
    } catch (e) {
      debugPrint('Failed to add review: $e');
      // 에러 발생 시 사용자에게 알림
    }
  }

  // ⭐️ 리뷰 삭제 함수
  Future<void> deleteReview(String reviewId) async {
    try {
      await _reviewService.deleteReview(reviewId);
    } catch (e) {
      debugPrint('Failed to delete review: $e');
    }
  }

  // ⭐️ 리뷰 수정 함수 (필요 시)
  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String content,
  }) async {
    try {
      await _reviewService.updateReview(
        reviewId: reviewId,
        rating: rating,
        content: content,
      );
    } catch (e) {
      debugPrint('Failed to update review: $e');
    }
  }
}