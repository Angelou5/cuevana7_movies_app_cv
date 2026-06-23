class Review {
  final String author;
  final String content;
  final double? rating; 
  final String? avatarPath;

  Review({
    required this.author,
    required this.content,
    this.rating,
    this.avatarPath,
  });
}