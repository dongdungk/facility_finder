# 🏟️ FacilityFinder: 공공 체육 시설 정보 및 QR 기반 이용 플랫폼
 
FacilityFinder는 위치 기반 서비스와 QR 코드 인증을 결합하여 공공 체육 시설의 정보를 실시간으로 제공하고, 시설 이용 등록 및 통계 기능을 통해 사용자 편의를 극대화하는 **Flutter 기반의 모바일 애플리케이션**입니다.
 
## 🚀 프로젝트 개요 및 기술 스택
 
| 구분 | 내용 |
| :--- | :--- |
| **주요 목표** | 공공 체육 시설에 대한 정확한 위치 정보 제공, QR 코드 기반의 신속한 이용 등록, 개인 이용 통계 시각화. |
| **개발 언어** | Dart |
| **프론트엔드/프레임워크** | Flutter |
| **상태 관리/아키텍처** | Provider, MVVM (Model-View-ViewModel) |
| **핵심 백엔드/DB** | Firebase (Authentication, Firestore) |
| **주요 외부 API** | Google Maps API, 공공 체육 시설 API |
 
---
 
## 🛠️ 개발 환경 및 사용 도구
 
본 프로젝트 개발에 사용된 핵심 도구 및 플랫폼입니다.
 
* **IDE 및 환경:** **Android Studio**, **Figma**, **Flutter**, **Android SDK**, **Git**
* **백엔드/DB:** **Firebase** (Authentication, Firestore)
* **위치/지도:** **Google Maps API**
* **핵심 패키지:** **GoRouter**, **Provider**, **google_maps_flutter**, **mobile_scanner**, **fl_chart**, **http**
---
 
## 📁 프로젝트 구조
 
```
lib/
├── entry/              # 앱 진입 화면 (담당: 김태호)
├── login/              # 로그인 / 인증 (담당: 김동영)
├── home/               # 홈 화면 (담당: 김태호)
├── enroll/
│   └── view/           # 시설 등록 및 조회 (담당: 김태호)
├── map/                # 지도 / 위치 기능 (담당: 김동영)
├── qr/                 # QR 코드 스캔 / 인증 (담당: 김동영)
├── mypage/             # 마이페이지 (담당: 김태호)
├── stats/              # 이용 통계 시각화 (담당: 김태호)
├── firebase_options.dart   # Firebase 설정 (담당: 김동영)
├── main.dart           # 앱 진입점 (담당: 김동영)
└── router.dart         # GoRouter 라우팅 설정 (담당: 김동영)
```
 
---
 
## 💻 프로젝트 기능 상세 및 구현 내용
 
### 1. 라우팅, 아키텍처 및 네비게이션 구조 (담당: 김동영)
 
본 프로젝트는 **MVVM 패턴**과 **GoRouter**를 통합하여 효율적이고 유지보수가 용이한 구조를 구축했습니다.
 
* **MVVM 아키텍처:** 데이터(`Model`), 비즈니스 로직(`ViewModel`), UI(`View`)를 분리하여 각 계층의 책임을 명확히 하고 코드의 유지보수성을 극대화했습니다.
* **통합 라우팅 시스템:** 모든 화면 이동을 **`go_router`** 기반으로 관리하며, `router.dart`에서 중앙 집중식으로 경로를 정의했습니다.
* **Firebase 초기화:** `main.dart` 진입 시점에 **`firebase_options.dart`** 기반으로 Firebase를 안정적으로 초기화하는 로직을 구현했습니다.
| 주요 라우팅 경로 | 담당자 연관 | 연관 기능 및 데이터 흐름 |
| :--- | :--- | :--- |
| **`/entry`** | 김태호 | 앱 최초 진입 화면, 인증 상태에 따른 분기 처리. |
| **`/login`** | 김동영 | Firebase Auth 스트림 연동, 로그인/회원가입 화면 전환. |
| **`/home`** | 김태호 | 메인 대시보드, 주요 기능 진입점. |
| **`/map`** | 김동영 | Google Maps 기반 시설 위치 시각화. |
| **`/qr`** | 김동영 | QR 코드 스캔 화면. |
| **`/enroll`** | 김태호 | 시설 이용 등록 및 조회. |
| **`/mypage`** | 김태호 | 사용자 프로필 및 설정. |
| **`/stats`** | 김태호 | 이용 통계 시각화. |
 
### 2. 진입(Entry) 화면 (담당: 김태호)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| Flutter, GoRouter | 앱 실행 시 가장 먼저 표시되는 진입 화면 구현. |
| Firebase Auth | 인증 상태를 확인하여 로그인 화면 또는 홈 화면으로 자동 라우팅. |
 
### 3. 인증 및 계정 관리 (담당: 김동영)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| Firebase Authentication | 이메일/비밀번호 기반 표준 회원가입 및 로그인 기능 구현. |
| GoRouter, StreamProvider | 로그인 상태 변화를 스트림으로 감지하여 화면 전환을 안정적으로 처리. |
| Provider, MVVM | 로그인 ViewModel에 비동기 로직을 분리하여 UI와 비즈니스 로직 디커플링. |
 
### 4. 홈 화면 (담당: 김태호)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| Flutter, Provider | 메인 대시보드 구성 및 주요 기능(지도, QR, 등록, 통계)으로의 진입점 제공. |
| Firebase Firestore | 사용자 데이터 및 최근 이용 기록을 실시간으로 가져와 홈 화면에 표시. |
 
### 5. 시설 등록 및 조회 (담당: 김태호)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| Firebase Firestore | 시설 이용 정보의 등록(Create), 조회(Read), 수정(Update), 삭제(Delete) 기능 구현. |
| Provider, MVVM | `enroll/view` 하위 화면에서 등록 폼과 조회 리스트를 ViewModel로 상태 관리. |
 
### 6. 지도 및 위치 기능 (담당: 김동영)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| Google Maps API | 사용자 위치를 실시간으로 지도에 표시하고, 주변 공공 체육 시설의 마커를 렌더링. |
| Geolocator | 사용자의 현재 GPS 좌표를 가져와 지도 중심을 동기화하고 위치 권한을 처리. |
| Provider | 지도 상태(카메라 위치, 마커 리스트 등)를 ViewModel에서 관리하여 효율적인 리렌더링 구현. |
| GCP | Google Maps API 키 발급 및 **릴리즈 SHA-1 지문**을 GCP에 등록하여 배포 환경 안정화. |
 
### 7. QR 코드 스캔 기능 (담당: 김동영)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| mobile_scanner | 카메라 기반 QR 코드 실시간 스캔 기능 구현. |
| Firebase Firestore | 스캔된 QR 코드 값을 Firestore와 연동하여 시설 이용 등록 및 인증 처리. |
| Provider, GoRouter | 스캔 결과에 따라 적절한 화면으로 라우팅하고, 처리 상태를 ViewModel에서 관리. |
 
### 8. 마이페이지 (담당: 김태호)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| Firebase Auth, Firestore | 사용자 프로필 정보 조회 및 수정 기능 구현. |
| Provider | 로그아웃, 회원 정보 변경 등 사용자 계정 관련 기능 상태 관리. |
 
### 9. 통계 (담당: 김태호)
 
| 기술 스택 | 구현 내용 |
| :--- | :--- |
| fl_chart | **fl_chart** 라이브러리를 활용하여 사용자의 시설 이용 기록을 그래프로 시각화. |
| Firebase Firestore | 사용자별 이용 기록 데이터를 집계하여 통계 화면에 반영. |
| Provider, MVVM | 통계 데이터 가공 및 차트 렌더링 로직을 ViewModel에 분리. |
 
---
 
## 👥 담당 영역 요약
 
| 담당자 | 담당 모듈 |
| :--- | :--- |
| **김동영** | 라우팅 및 앱 초기화 (`router.dart`, `main.dart`, `firebase_options.dart`), 로그인/인증 (`login`), 지도 및 위치 기능 (`map`), QR 코드 스캔 (`qr`) |
| **김태호** | 진입 화면 (`entry`), 홈 (`home`), 시설 등록/조회 (`enroll/view`), 마이페이지 (`mypage`), 통계 (`stats`) |
 
---
 
## 🔧 실행 방법
 
```bash
# 1. 저장소 클론
git clone https://github.com/dongdungk/facility_finder.git
 
# 2. 디렉토리 이동
cd facility_finder
 
# 3. 패키지 설치
flutter pub get
 
# 4. 앱 실행
flutter run
```
 
> ⚠️ Firebase 및 Google Maps API 키 설정이 필요합니다.
> - `firebase_options.dart` 는 `flutterfire configure` 명령어를 통해 생성합니다.
> - `android/app/src/main/AndroidManifest.xml` 에 Google Maps API 키를 등록해야 합니다.
