// lib/qr/service/qr_firestoreservice.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../map/model/firestore_facility_model.dart';

class QRFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// facilityId로 Firestore에서 시설 정보를 가져와 FirestoreFacilityModel 객체로 반환합니다.
  ///
  /// 문서를 찾지 못하면 null을 반환하고, Firestore 조회 중 오류가 발생하면 예외를 다시 던집니다.
  Future<FirestoreFacilityModel?> getFacilityById(String facilityId) async {
    try {
      final docSnapshot =
          await _firestore.collection('facilities').doc(facilityId).get();

      if (docSnapshot.exists) {
        // 문서가 존재하면 FirestoreFacilityModel로 변환하여 반환
        return FirestoreFacilityModel.fromFirestore(docSnapshot);
      } else {
        // 문서가 존재하지 않으면 null 반환
        return null;
      }
    } catch (e) {
      // Firestore 조회 중 에러 발생 시, 예외를 다시 던져 상위 레이어에서 처리하도록 함
      print('Error getting facility by ID: $e');
      rethrow;
    }
  }
}
