class TaskModel {
  final String id;
  final String title;
  final String details;
  final bool isCompleted;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.details,
    this.isCompleted = false,
    required this.userId,
  });

  factory TaskModel.fromJson(
      Map<String, dynamic> json, String id, String userId) {
    return TaskModel(
      id: id,
      title: json['title'] ?? '',
      details: json['details'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      userId: userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'details': details,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }
}
