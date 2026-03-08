class Capsule {
  final String id;
  final String userId;
  final String message;
  final DateTime openAt;
  final DateTime createdAt;

  bool get isOpened => DateTime.now().isAfter(openAt);

  const Capsule({
    required this.id,
    required this.userId,
    required this.message,
    required this.openAt,
    required this.createdAt,
  });

  factory Capsule.fromJson(Map<String, dynamic> json) => Capsule(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        message: json['message'] as String,
        openAt: DateTime.parse(json['open_at'] as String).toLocal(),
        createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      );
}
