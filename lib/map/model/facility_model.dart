class FacilityModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String category;
  final double lat; // 추가
  final double lng; // 추가
  final String district;
  final List<String> images;

  // UI용 필드들
  final String hours;
  final String price;
  final String status;
  final String reservation;
  final String distance;
  final double rating;
  final int reviewCount;
  final int currentOccupancy;
  final int maxCapacity;

  FacilityModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.category,
    this.lat = 0.0,
    this.lng = 0.0,
    this.district = '',
    this.images = const [],
    this.hours = '정보 없음',
    this.price = '무료',
    this.status = '정보 없음',
    this.reservation = '문의 필요',
    this.distance = 'N/A',
    this.rating = 4.2,
    this.reviewCount = 8,
    this.currentOccupancy = 0,
    this.maxCapacity = 0,
  });

  // 서울시 API용 팩토리 (기존 유지 + 좌표 추가)
  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    String name = json['ft_title'] ?? json['FT_TITLE'] ?? '이름 없음';
    String rawDistrict = json['ar_cd_name'] ?? json['AR_CD_NAME'] ?? '';

    return FacilityModel(
      id: name,
      name: name,
      address: json['ft_addr'] ?? json['FT_ADDR'] ?? '주소 정보 없음',
      phone: json['ft_phone'] ?? json['FT_PHONE'] ?? '전화번호 없음',
      category: json['ft_kind_name'] ?? json['FT_KIND_NAME'] ?? '기타',
      district: rawDistrict.replaceAll(RegExp(r'\s+'), '').trim(),
      // 서울시 API 좌표 필드가 있다면 추가 (예: json['X_KOTI'])
      lat: double.tryParse(json['LAT']?.toString() ?? '0.0') ?? 0.0,
      lng: double.tryParse(json['LNG']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  // ⭐️ 카카오 API용 팩토리 추가
  factory FacilityModel.fromKakao(Map<String, dynamic> doc) {
    return FacilityModel(
      id: doc['id'],
      name: doc['place_name'],
      address: doc['address_name'],
      phone: doc['phone'] ?? '',
      category: '스터디카페',
      lat: double.parse(doc['y']),
      lng: double.parse(doc['x']),
      district: doc['address_name'].split(' ')[1], // "서울 강남구..."에서 구 추출
      reservation: '카카오 예약 가능',
    );
  }
}