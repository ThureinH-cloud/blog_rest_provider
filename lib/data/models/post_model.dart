class PostModel {
  final int? id;
  final String? title;
  final String? body;
  String? photo;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.photo,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      photo: json['photo'],
    );
  }
}
