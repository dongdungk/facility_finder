import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodel/facility_review_viewmodel.dart';
import '../view/facility_review_edit_screen.dart'; // RatingInput 재사용을 위해 임포트

// ----------------------------------------------------------------------
// ⭐️ 리뷰 작성 메인 화면 위젯 (ReviewWriteScreen)
// ----------------------------------------------------------------------
class ReviewWriteScreen extends StatefulWidget {
  final String facilityId; // 어떤 시설에 리뷰를 작성할지 ID를 전달받음

  const ReviewWriteScreen({
    super.key,
    required this.facilityId,
  });

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  // ⭐️ [추가] 닉네임 입력을 위한 컨트롤러
  late TextEditingController _nicknameController;
  late TextEditingController _textController;
  double _currentRating = 5.0;

  @override
  void initState() {
    super.initState();
    // 💡 Provider를 사용하여 현재 로그인 사용자의 정보를 읽어옵니다.
    final User? user = context.read<User?>();
    final String defaultName = user?.displayName ?? '익명 사용자';

    _textController = TextEditingController();
    // ⭐️ [추가] 닉네임 컨트롤러 초기화 시 Firebase displayName을 기본값으로 설정
    _nicknameController = TextEditingController(text: defaultName);
  }

  @override
  void dispose() {
    _nicknameController.dispose(); // ⭐️ [추가] 컨트롤러 dispose
    _textController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    final enteredNickname = _nicknameController.text.trim();
    final newText = _textController.text.trim();

    // 유효성 검사
    if (newText.isEmpty || _currentRating == 0.0 || enteredNickname.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임, 별점, 내용을 모두 입력해주세요.')),
      );
      return;
    }

    final User? user = Provider.of<User?>(context, listen: false);
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final viewModel = Provider.of<FacilityReviewViewModel>(context, listen: false);

    try {
      // ⭐️ addReview 함수 호출 시 사용자가 입력한 닉네임을 전달
      await viewModel.addReview(
        facilityId: widget.facilityId,
        userId: user.uid,
        userName: enteredNickname, // ⭐️ 사용자가 입력한 닉네임 사용
        rating: _currentRating,
        content: newText,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      debugPrint('리뷰 작성 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰 작성 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 작성'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ⭐️ [추가] 닉네임 입력 필드
            const Text(
              '닉네임',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              maxLength: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '리뷰에 사용할 닉네임을 입력하세요.',
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '별점 평가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 1. 별점 입력 위젯
            RatingInput(
              initialRating: _currentRating,
              onRatingChanged: (newRating) {
                setState(() {
                  _currentRating = newRating > 0 ? newRating : 0.1;
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              '리뷰 내용',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 2. 텍스트 입력 필드
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '시설에 대한 솔직한 경험을 공유해주세요.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 30),

            // 3. 버튼 섹션
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('리뷰 등록', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}