import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'map/model/facility_review_model.dart';
import 'map/view/facility_review_edit_screen.dart';
import 'map/view/facility_review_write_screen.dart';
import 'login/view/login_view.dart';
import 'map/view/main_screen.dart';
import 'map/view/map_main_screen.dart';
import 'map/view/facility_detail_screen.dart';
import 'map/view/facility_review_screen.dart';
import 'map/view/facility_photo_screen.dart';
import 'map/view/favorite_screen.dart'; // 클래스명 FavoritesScreen인지 확인 필수
import 'map/view/search_screen.dart';
import 'qr/view/qr_scan_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellHome',
);
final _shellNavigatorQrKey = GlobalKey<NavigatorState>(debugLabel: 'ShellQr');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellProfile',
);

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
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
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
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const Center(child: Text("통계 화면")),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorQrKey,
          routes: [
            GoRoute(
              path: '/qr',
              builder: (context, state) => const QRScanScreen(),
            ),
          ],
        ),
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
    // ⭐️ 즐겨찾기 화면을 별도 경로로 분리
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    // 시설 상세 (탭 외부)
    GoRoute(
      path: '/facility/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FacilityDetailScreen(facilityId: id);
      },
      routes: [
        GoRoute(
          path: 'reviews',
          name: 'facilityReviews',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return FacilityReviewScreen(facilityId: id);
          },
          routes: [
            GoRoute(
              path: ':reviewId/edit',
              name: 'editReview',
              pageBuilder: (context, state) {
                final reviewId = state.pathParameters['reviewId']!;
                final reviewToEdit = state.extra as FacilityReviewModel?;
                if (reviewToEdit == null) {
                  return const MaterialPage(
                    child: Scaffold(body: Center(child: Text('데이터 누락'))),
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
