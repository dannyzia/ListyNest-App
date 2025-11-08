import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Review by ${review.reviewerId}'),
        subtitle: Text(review.comment),
        trailing: Text('${review.rating}/5'),
      ),
    );
  }
}
