// lib/map/model/facility_review_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

// ⭐️ [FIX] ReviewModel 대신 FacilityReviewModel 사용 (서비스 파일과 통일)
class FacilityReviewModel {
  final String id;
  final String facilityId;
  final String userId;
  final String userName;
  final double rating;
  final String text; // 서비스 파일의 content 필드와 매핑
  final Timestamp date;

  // ⭐️ facility_review_screen.dart에서 사용했던 필드 추가 (더미 데이터 혹은 실제 필드)
  final int likes;
  final int comments;

  FacilityReviewModel({
    required this.id,
    required this.facilityId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.text,
    required this.date,
    this.likes = 0, // 기본값 설정
    this.comments = 0, // 기본값 설정
  });

  factory FacilityReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FacilityReviewModel(
      id: doc.id,
      facilityId: data['facilityId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '익명',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      text: data['content'] ?? '', // 서비스의 'content' 필드와 매핑
      date: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      // 'likes'와 'comments'는 Firestore에 필드가 없다고 가정하고 기본값 사용
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
    );
  }
}