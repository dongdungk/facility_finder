import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore 전용 시설 모델
class FirestoreFacilityModel {
  final String id;           // 시설 고유 ID (카카오 ID 등)
  final String name;         // 시설 이름
  final String address;      // 주소
  final String phone;        // 전화번호
  final String category;     // 카테고리 (스터디카페 등)
  final double lat;          // 위도
  final double lng;          // 경도
  final String district;     // 행정구역 (구 단위)
  final List<String> images; // 이미지 URL 리스트

  // 상태 및 관리 필드
  final int currentOccupancy; // 현재 이용 인원
  final int maxCapacity;      // 최대 수용 인원
  final String status;        // 운영 상태 (영업중, 종료 등)
  final DateTime? updatedAt;  // 마지막 업데이트 시간

  FirestoreFacilityModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.category,
    required this.lat,
    required this.lng,
    this.district = '',
    this.images = const [],
    this.currentOccupancy = 0,
    this.maxCapacity = 0,
    this.status = '정보 없음',
    this.updatedAt,
  });

  // 1. 객체를 Firestore에 저장할 Map 형태로 변환 (To DB)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'category': category,
      'lat': lat,
      'lng': lng,
      'district': district,
      'images': images,
      'currentOccupancy': currentOccupancy,
      'maxCapacity': maxCapacity,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(), // 서버 시간 기준 저장
    };
  }

  // 2. Firestore DocumentSnapshot을 객체로 변환 (From DB)
  factory FirestoreFacilityModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FirestoreFacilityModel(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      category: data['category'] ?? '',
      lat: (data['lat'] ?? 0.0).toDouble(),
      lng: (data['lng'] ?? 0.0).toDouble(),
      district: data['district'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      currentOccupancy: data['currentOccupancy'] ?? 0,
      maxCapacity: data['maxCapacity'] ?? 0,
      status: data['status'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}