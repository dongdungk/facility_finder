import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodel/facility_review_viewmodel.dart';
import '../view/facility_review_edit_screen.dart'; // RatingInput 재사용

class ReviewWriteScreen extends StatefulWidget {
  final String facilityId;

  const ReviewWriteScreen({
    super.key,
    required this.facilityId,
  });

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _textController;
  double _currentRating = 5.0;

  @override
  void initState() {
    super.initState();

    // 💡 Provider를 initState에서 사용할 때는 listen: false가 필수입니다.
    final User? user = Provider.of<User?>(context, listen: false);
    final String defaultName = user?.displayName ?? '익명 사용자';

    _textController = TextEditingController();
    _nicknameController = TextEditingController(text: defaultName);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    final enteredNickname = _nicknameController.text.trim();
    final newText = _textController.text.trim();

    if (newText.isEmpty || _currentRating == 0.0 || enteredNickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임, 별점, 내용을 모두 입력해주세요.')),
      );
      return;
    }

    final User? user = Provider.of<User?>(context, listen: false);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final viewModel = Provider.of<FacilityReviewViewModel>(context, listen: false);

    try {
      await viewModel.addReview(
        facilityId: widget.facilityId,
        userId: user.uid,
        userName: enteredNickname,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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