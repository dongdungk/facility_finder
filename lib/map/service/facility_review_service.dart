import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/facility_review_model.dart';

class FacilityReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. 리뷰 생성 (Create)
  Future<void> createReview({
    required String facilityId,
    required String userId,
    required String userName,
    required double rating,
    required String content,
  }) async {
    final reviewRef = _firestore.collection('reviews');
    await reviewRef.add({
      'facilityId': facilityId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'content': content,
      'createdAt': Timestamp.now(),
      'updatedAt': null,
    });
  }

  // 2. 특정 시설의 리뷰 목록 조회 (Read)
  Stream<List<FacilityReviewModel>> getReviewsByFacilityId(String facilityId) {
    return _firestore
        .collection('reviews')
        .where('facilityId', isEqualTo: facilityId)
        .orderBy('createdAt', descending: true) // 최신 리뷰가 위로 오도록 정렬
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FacilityReviewModel.fromFirestore(doc))
        .toList());
  }

  // 3. 리뷰 수정 (Update)
  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String content,
  }) async {
    final reviewRef = _firestore.collection('reviews').doc(reviewId);
    await reviewRef.update({
      'rating': rating,
      'content': content,
      'updatedAt': Timestamp.now(),
    });
  }

  // 4. 리뷰 삭제 (Delete)
  Future<void> deleteReview(String reviewId) async {
    final reviewRef = _firestore.collection('reviews').doc(reviewId);
    await reviewRef.delete();
  }
}