// lib/map/model/facility_model.dart

class FacilityModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String category;

  // UI에서 사용되는 임시 필드
  final String distance;
  final String hours;
  final String price;
  final String reservation;
  final String status;
  final double rating;
  final int reviewCount;
  final List<String> images;

  // 필터링 및 현황판용 필드
  final int currentOccupancy;
  final int maxCapacity;
  final String district; // AR_CD_NAME (자치구명)

  FacilityModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.category,

    this.distance = 'N/A',
    this.hours = '정보 없음',
    this.price = '무료',
    this.reservation = '문의 필요',
    this.status = '정보 없음',
    this.rating = 4.2,
    this.reviewCount = 8,
    this.images = const [],
    this.currentOccupancy = 0,
    this.maxCapacity = 0,
    required this.district, // district는 이제 필수
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    // 1. 이름
    String name = json['ft_title'] as String? ??
        json['FT_TITLE'] as String? ??
        '이름 없음';

    // 2. 주소
    String address = json['ft_addr'] as String? ??
        json['FT_ADDR'] as String? ??
        '주소 정보 없음';

    // 3. 전화번호
    String phone = json['ft_phone'] as String? ??
        json['FT_PHONE'] as String? ??
        json['TELNO'] as String? ??
        '전화번호 없음';

    // 4. 카테고리
    String category = json['ft_kind_name'] as String? ??
        json['FT_KIND_NAME'] as String? ??
        '기타';

    // ⭐️ 5. 자치구 (AR_CD_NAME) - 공백 및 특수문자 완벽 제거 후 저장
    String rawDistrict = json['ar_cd_name'] as String? ?? json['AR_CD_NAME'] as String? ?? '';
    String district = rawDistrict.replaceAll(RegExp(r'\s+'), '').trim();

    // 6. 운영시간
    String wdTime = json['ft_wd_time'] as String? ?? json['FT_WD_TIME'] as String? ?? '';
    String weTime = json['ft_we_time'] as String? ?? json['FT_WE_TIME'] as String? ?? '';
    String hoursInfo = (wdTime.isEmpty && weTime.isEmpty) ? '정보 없음' : '평일: $wdTime 주말: $weTime';

    // 7. 가격, 상태 등
    String priceInfo = json['ft_money'] as String? ?? json['FT_MONEY'] as String? ?? '요금 정보 없음';
    String opStatus = json['ft_operation_name'] as String? ??
        json['FT_OPERATION_NAME'] as String? ??
        '정보 없음';

    // 8. 이미지
    List<String> imageList = [];
    if (json['IMGURL'] != null && json['IMGURL'].toString().isNotEmpty) {
      imageList.add(json['IMGURL'].toString());
    }

    return FacilityModel(
      id: name,
      name: name,
      address: address,
      phone: phone,
      category: category,
      hours: hoursInfo,
      price: priceInfo,
      status: opStatus,
      reservation: opStatus,
      district: district, // 클리닝된 자치구명
      images: imageList,

      // (나머지 임시값은 기본값 사용)
    );
  }
}