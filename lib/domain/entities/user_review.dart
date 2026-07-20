class UserReview {
  final String id;
  final String userId;
  final int movieId;
  final int? rating;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserReview({
    required this.id,
    required this.userId,
    required this.movieId,
    this.rating,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'movieId': movieId,
        'rating': rating,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
        id: json['id'] as String,
        userId: json['userId'] as String,
        movieId: json['movieId'] as int,
        rating: json['rating'] as int?,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
