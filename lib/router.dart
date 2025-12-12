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

// Static Status Views
import '/static/view/local_status.dart';
import '/static/view/search_gym.dart';
import '/static/view/facilities_status.dart';
import '/static/view/compare_status.dart';

// Main App Views
import 'login/view/login_view.dart';
import 'map/view/main_screen.dart';
import 'map/view/map_main_screen.dart';
import 'map/view/facility_detail_screen.dart';
import 'map/view/facility_review_screen.dart';
import 'map/view/facility_photo_screen.dart';
import 'map/view/favorite_screen.dart';
import 'map/view/search_screen.dart';

// Tagging Views
import 'tagging/view/tagging_main_screen.dart';
import 'tagging/view/tagging_success_screen.dart';

// ------------------------------
// Navigation Keys
// ------------------------------
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'ShellHome');
final _shellNavigatorStatsKey = GlobalKey<NavigatorState>(debugLabel: 'ShellStats');
final _shellNavigatorEditKey = GlobalKey<NavigatorState>(debugLabel: 'ShellEdit');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'ShellProfile');

// ------------------------------
// GoRouter
// ------------------------------
final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,

  redirect: (BuildContext context, GoRouterState state) {
    // User 타입이 provider를 통해 제공된다고 가정
    final user = context.read<User?>();
    final isLoggedIn = user != null;
    final isLoggingIn = state.uri.toString() == '/login';

    if (isLoggedIn) {
      // 로그인 상태라면, 로그인 페이지 접근 시 / 로 리다이렉트
      return isLoggingIn ? '/' : null;
    } else {
      // 비로그인 상태라면, /login 페이지가 아닐 경우 /login으로 리다이렉트
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
        // 탭 1: 통계 (Stats)
        // ------------------------------
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStatsKey,
          routes: [
            GoRoute(
              path: '/static',
              builder: (context, state) => const GymCompareStatPage(),
              routes: [
                GoRoute(
                  path: 'compare',
                  builder: (context, state) => const GymCompareStatPage(),
                ),
                GoRoute(
                  path: 'facilities',
                  builder: (context, state) => const FacilitiesStatusPage(),
                ),
                GoRoute(
                  path: 'LocalStat',
                  builder: (context, state) => const LocalStatusPage(),
                ),
                GoRoute(
                  path: 'SearchGym',
                  builder: (context, state) => const SearchGymPage(),
                ),
              ],
            ),
          ],
        ),

        // ------------------------------
        // 탭 2: 입출입 (Tagging/Edit)
        // ------------------------------
        StatefulShellBranch(
          navigatorKey: _shellNavigatorEditKey,
          routes: [
            GoRoute(
              path: '/edit',
              builder: (context, state) => const TaggingMainScreen(),
              routes: [
                GoRoute(
                  path: 'tagging_success',
                  builder: (context, state) => const TaggingSuccessScreen(),
                ),
              ],
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
            final id = state.pathParameters['id']!; // facility ID
            return FacilityReviewScreen(facilityId: id);
          },
          routes: [
            // 🔹 리뷰 수정 경로
            GoRoute(
              path: ':reviewId/edit', // 예: /facility/123/reviews/456/edit
              name: 'editReview',
              pageBuilder: (context, state) {
                final reviewId = state.pathParameters['reviewId']!;
                // state.extra로 FacilityReviewModel 객체를 넘겨 받았다고 가정
                final reviewToEdit = state.extra as FacilityReviewModel?;

                if (reviewToEdit == null) {
                  return const MaterialPage(
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(56.0),
                        child: Text('오류'),
                      ),
                      body: Center(child: Text('수정할 리뷰 정보를 찾을 수 없습니다. (데이터 누락)')),
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
            // 🔹 리뷰 작성 경로
            GoRoute(
              path: 'write', // 예: /facility/123/reviews/write
              name: 'writeReview',
              builder: (context, state) {
                final facilityId = state.pathParameters['id']!; // 부모 경로에서 facility ID 가져옴
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
      ], // end of facility/:id sub-routes
    ),
  ],
);