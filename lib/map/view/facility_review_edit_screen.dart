// lib/map/view/review_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/facility_review_model.dart';
import '../viewmodel/facility_review_viewmodel.dart';

// ----------------------------------------------------------------------
// ⭐️ 별점 선택을 위한 위젯 (RatingInput)
// ----------------------------------------------------------------------
class RatingInput extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  const RatingInput({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber),
        Expanded( // Slider가 Row 내에서 공간을 효율적으로 사용하도록 Expanded 사용
          child: Slider(
            value: initialRating,
            min: 0,
            max: 5,
            divisions: 10,
            onChanged: onRatingChanged,
          ),
        ),
        SizedBox(
          width: 30, // 텍스트 너비 고정
          child: Text(
            initialRating.toStringAsFixed(1),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// ⭐️ 리뷰 수정 메인 화면 위젯 (ReviewEditScreen)
// ----------------------------------------------------------------------
class ReviewEditScreen extends StatefulWidget {
  // 💡 참고: reviewId는 라우팅에 사용될 수 있으나, 수정 시에는 reviewToEdit 객체의 ID를 사용합니다.
  final String reviewId;
  final FacilityReviewModel reviewToEdit; // 🚨 모델명 FacilityReviewModel로 가정하고 수정

  const ReviewEditScreen({
    super.key,
    required this.reviewId,
    required this.reviewToEdit, // FacilityReviewModel 객체
  });

  @override
  State<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {
  late TextEditingController _textController;
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    // 초기 값 설정
    _textController = TextEditingController(text: widget.reviewToEdit.text);
    _currentRating = widget.reviewToEdit.rating;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final newText = _textController.text.trim();

    if (newText.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요.')),
      );
      return;
    }

    // ViewModel 인스턴스 가져오기 (listen: false)
    final viewModel = Provider.of<FacilityReviewViewModel>(context, listen: false);

    // 💡 [주의] updateReview 함수의 시그니처가 다음과 같다고 가정하고 호출
    // Future<void> updateReview(String reviewId, String content, double rating)
    await viewModel.updateReview(
      reviewId: widget.reviewToEdit.id, // 모델 내부의 실제 ID 필드를 사용해야 함 (id 또는 reviewId)
      content: newText,
      rating: _currentRating,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 수정'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch, // 너비 가득 채우기
          children: [
            // 1. 별점 입력 위젯
            RatingInput(
              initialRating: _currentRating,
              onRatingChanged: (newRating) {
                setState(() {
                  _currentRating = newRating;
                });
              },
            ),
            const SizedBox(height: 16),

            // 2. 텍스트 입력 필드
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '리뷰 내용을 수정하세요.',
                alignLabelWithHint: true, // 힌트 텍스트가 상단에 정렬되도록
              ),
            ),
            const SizedBox(height: 20),

            // 3. 버튼 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('저장', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}