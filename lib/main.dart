import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

// Project Imports
import 'router.dart';
import 'map/viewmodel/facility_detail_viewmodel.dart';
import 'login/service/auth_service.dart';
import 'login/viewmodel/login_viewmodel.dart';
import 'map/service/facility_service.dart';
import 'map/service/kakao_service.dart';
import 'map/service/facility_photo_service.dart'; // Alias 제거
import 'map/service/facility_review_service.dart'; // Alias 제거
import 'qr/service/qr_firestoreservice.dart';
import 'qr/viewmodel/qr_viewmodel.dart';
import 'map/viewmodel/search_viewmodel.dart';
import 'map/viewmodel/facility_review_viewmodel.dart';
import 'map/viewmodel/facility_photo_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 서비스 인스턴스 생성 (의존성 주입 준비)
  // 특별한 이름 충돌이 없다면 Alias 없이 클래스명 그대로 사용합니다.
  final authService = AuthService();
  final facilityService = FacilityService();
  final kakaoService = KakaoService();
  final reviewService = FacilityReviewService();
  final photoService = PhotoService();
  final qrService = QRFirestoreService();

  runApp(
    MultiProvider(
      providers: [
        /// [User?] 주입의 이유:
        /// 앱 전체에서 `context.watch<User?>()`를 통해 로그인 상태를 실시간 감지하기 위함입니다.
        /// 예: 유저가 null이면 로그인 페이지로, 유저 정보가 있으면 홈으로 분기 처리가 쉬워집니다.
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
        ),

        // ViewModels 주입
        ChangeNotifierProvider(create: (_) => LoginViewModel(authService)),

        ChangeNotifierProvider(
          create: (_) => FacilityDetailViewModel(
            facilityService,
            kakaoService,
            photoService,
            reviewService,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => SearchViewModel(facilityService, kakaoService),
        ),

        ChangeNotifierProvider(
          create: (_) => FacilityReviewViewModel(reviewService),
        ),

        ChangeNotifierProvider(
          create: (_) => FacilityPhotoViewModel(photoService),
        ),

        ChangeNotifierProvider(create: (_) => QRViewModel(qrService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Facility Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true, // 최신 Flutter 스타일 적용
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
