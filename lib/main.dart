// lib/main.dart (최종 빌드 성공 버전)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

// ⭐️ Project-Relative Imports
import 'router.dart';

// Project Services & ViewModels
import 'map/viewmodel/facility_detail_viewmodel.dart';
import 'login/service/auth_service.dart';
import 'login/viewmodel/login_viewmodel.dart';
import 'map/service/facility_service.dart';
import 'login/view/login_view.dart';

// [Service Layer] - 별칭 사용
import 'map/service/facility_photo_service.dart' as Photo_Alias;
import 'map/service/facility_review_service.dart' as Review_Alias;

// [ViewModel Layer]
import 'map/viewmodel/search_viewmodel.dart';
import 'map/viewmodel/facility_review_viewmodel.dart';
import 'map/viewmodel/facility_photo_viewmodel.dart';

//커뮤니티 provider import


void main() async {
  // 1. Flutter 바인딩 초기화 및 main 함수를 비동기로 만듦
  WidgetsFlutterBinding.ensureInitialized();

  // 2. .env 파일 로드 (가장 먼저 수행)
  await dotenv.load(fileName: ".env");

  // 3. Firebase 초기화
  await Firebase.initializeApp();

  // 4. 초기화가 완료된 후, Firebase 인스턴스에 접근하는 서비스 객체 생성
  final FacilityService facilityService = FacilityService();
  final AuthService authService = AuthService();

  // 별칭을 사용하여 클래스를 명확히 생성
  // ⭐️ [FIX] Review_Alias 뒤에 FacilityReviewService를 붙여서 클래스명 오류 해결
  final Review_Alias.FacilityReviewService reviewService = Review_Alias.FacilityReviewService();
  final Photo_Alias.PhotoService photoService = Photo_Alias.PhotoService();

  runApp(
    MultiProvider(
      providers: [
        // 1. [Auth Stream]
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
          lazy: false,
        ),

        // 2. [Login VM]
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(authService),
        ),

        // ⭐️ [Facility Review VM] - 타입 명시 추가
        ChangeNotifierProvider<FacilityReviewViewModel>(
          create: (_) => FacilityReviewViewModel(reviewService),
        ),


        ChangeNotifierProvider(
          create: (_) => SearchViewModel(facilityService),
        ),


        ChangeNotifierProvider(
          create: (_) => FacilityPhotoViewModel(photoService),
        ),

        // 3. [Facility Detail VM]
        ChangeNotifierProvider(
          create: (_) => FacilityDetailViewModel(facilityService, photoService, reviewService),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // goRouter는 router.dart 파일에서 임포트됩니다.
    return MaterialApp.router(
      title: 'Facility Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}