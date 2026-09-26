class ProductReview {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final bool isVerified;
  final List<String> images;

  const ProductReview({
    required this.id,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.comment,
    required this.date,
    this.isVerified = true,
    this.images = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'isVerified': isVerified,
      'images': images,
    };
  }

  factory ProductReview.fromMap(Map<String, dynamic> map) {
    return ProductReview(
      id: map['id'] ?? '',
      userName: map['userName'] ?? 'Customer',
      userAvatar: map['userAvatar'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      comment: map['comment'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      isVerified: map['isVerified'] ?? true,
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
