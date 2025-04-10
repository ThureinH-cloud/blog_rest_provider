class MessageModel {
  final String result;

  MessageModel({required this.result});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(result: json['result']);
  }
}
