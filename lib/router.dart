import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Main App Models & Views
import 'map/model/facility_review_model.dart';

// 🔥 누락된 화면 파일 임포트 재추가 (클래스 찾기 오류 해결) 🔥
import 'map/view/facility_review_edit_screen.dart';
import 'map/view/facility_review_write_screen.dart';

import 'login/service/auth_service.dart';

// Main App Views
import 'login/view/login_view.dart';
import 'map/view/main_screen.dart';
import 'map/view/map_main_screen.dart';
import 'map/view/facility_detail_screen.dart';
import 'map/view/facility_review_screen.dart';
import 'map/view/facility_photo_screen.dart';
import 'map/view/favorite_screen.dart';
import 'map/view/search_screen.dart';

// ⭐️ [NEW] QR 관련 화면 임포트 (경로 확인 필수)
import 'qr/view/qr_scan_screen.dart';




// ------------------------------
// Navigation Keys
// ------------------------------
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'ShellHome');

// ⭐️ [RENAME] EditKey -> QrKey로 변경
final _shellNavigatorQrKey = GlobalKey<NavigatorState>(debugLabel: 'ShellQr');

final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'ShellProfile');

// ------------------------------
// GoRouter
// ------------------------------
final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,

  redirect: (BuildContext context, GoRouterState state) {
    final user = context.read<User?>();
    final isLoggedIn = user != null;
    final isLoggingIn = state.uri.toString() == '/login';

    if (isLoggedIn) {
      return isLoggingIn ? '/' : null;
    } else {
      return isLoggingIn ? null : '/login';
    }
  },

  routes: [
    // ------------------------------
    // 로그인 (Login)
    // ------------------------------
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // ------------------------------
    // 탭 구조 (StatefulShellRoute)
    // ------------------------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // ------------------------------
        // 탭 0: 홈 (Home)
        // ------------------------------
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const MapMainScreen(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (context, state) => const SearchScreen(),
                ),
                GoRoute(
                  path: 'favorites',
                  builder: (context, state) => const FavoritesScreen(),
                ),
              ],
            ),
          ],
        ),

        // ------------------------------
        // 탭 1: 통계 (Stats) - (필요시 추가)
        // ------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats', // 임시 경로
              builder: (context, state) => const Center(child: Text("통계 화면")),
            ),
          ],
        ),

        // ------------------------------
        // ⭐️ 탭 2: QR 스캔 (QR Scan) - [수정됨]
        // ------------------------------
        StatefulShellBranch(
          navigatorKey: _shellNavigatorQrKey, // 변경된 키 사용
          routes: [
            GoRoute(
              path: '/qr', // ⭐️ 경로를 /edit에서 /qr로 변경
              builder: (context, state) => const QRScanScreen(),
              // 💡 서브 라우트 제거:
              // QR 성공 화면은 QRScanScreen 내부에서 상태 변화(State)로 처리되므로
              // 별도의 URL 라우트가 필요하지 않습니다.
            ),
          ],
        ),

        // ------------------------------
        // 탭 3: 내 정보 (Profile)
        // ------------------------------
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Center(child: Text('내 정보 화면')),
            ),
          ],
        ),
      ],
    ),

    // ------------------------------
    // 시설 상세 상위 페이지 (Main Routes: 탭 구조 바깥)
    // ------------------------------
    GoRoute(
      path: '/facility/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FacilityDetailScreen(facilityId: id);
      },
      routes: [
        // 🔹 리뷰 경로
        GoRoute(
          path: 'reviews',
          name: 'facilityReviews',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return FacilityReviewScreen(facilityId: id);
          },
          routes: [
            // 🔹 리뷰 수정
            GoRoute(
              path: ':reviewId/edit',
              name: 'editReview',
              pageBuilder: (context, state) {
                final reviewId = state.pathParameters['reviewId']!;
                final reviewToEdit = state.extra as FacilityReviewModel?;

                if (reviewToEdit == null) {
                  return const MaterialPage(
                    child: Scaffold(
                      body: Center(child: Text('데이터 누락')),
                    ),
                  );
                }
                return MaterialPage(
                  child: ReviewEditScreen(
                    reviewId: reviewId,
                    reviewToEdit: reviewToEdit,
                  ),
                );
              },
            ),
            // 🔹 리뷰 작성
            GoRoute(
              path: 'write',
              name: 'writeReview',
              builder: (context, state) {
                final facilityId = state.pathParameters['id']!;
                return ReviewWriteScreen(facilityId: facilityId);
              },
            ),
          ],
        ),

        // 🔹 사진 경로
        GoRoute(
          path: 'photos',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return FacilityPhotoScreen(facilityId: id);
          },
        ),
      ],
    ),
  ],
);