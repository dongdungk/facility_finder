import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';// 추가
import 'firebase_options.dart';




// Project Imports
import 'router.dart';
import 'map/viewmodel/facility_detail_viewmodel.dart';
import 'login/service/auth_service.dart';
import 'login/viewmodel/login_viewmodel.dart';
import 'map/service/facility_service.dart';
import 'map/service/kakao_service.dart';
import 'map/service/facility_photo_service.dart' as Photo_Alias;
import 'map/service/facility_review_service.dart' as Review_Alias;
import 'qr/service/qr_service.dart';
import 'qr/viewmodel/qr_viewmodel.dart';
import 'map/viewmodel/search_viewmodel.dart';
import 'map/viewmodel/facility_review_viewmodel.dart';
import 'map/viewmodel/facility_photo_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");


  // ⭐️ [필수] 카카오 맵 SDK 초기화 (네이티브 앱 키 사용)
  // AndroidManifest.xml에 넣었던 것과 동일한 키를 넣으세요.


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final facilityService = FacilityService();
  final kakaoService = KakaoService();
  final authService = AuthService();
  final reviewService = Review_Alias.FacilityReviewService();
  final photoService = Photo_Alias.PhotoService();
  final qrService = QRService();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => LoginViewModel(authService)),
        ChangeNotifierProvider(
          create: (_) => FacilityDetailViewModel(facilityService, kakaoService, photoService, reviewService),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(facilityService, kakaoService),
        ),
        ChangeNotifierProvider(create: (_) => FacilityReviewViewModel(reviewService)),
        ChangeNotifierProvider(create: (_) => FacilityPhotoViewModel(photoService)),
        ChangeNotifierProvider(create: (_) => QRViewModel(qrService)),
      ],
      child: const MyApp(),
    ),
  );
}

// ⭐️ [에러 해결] MyApp 클래스 정의 추가
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Facility Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}