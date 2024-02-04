class MessageModel {
  final String textId;
  final String text;
  final String userId;
  final int createdAt;
  final bool isDeleted;

  MessageModel({
    required this.textId,
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.isDeleted,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : textId = json["textId"],
        text = json["text"],
        userId = json["userId"],
        createdAt = json["createdAt"],
        isDeleted = json["isDeleted"];

  Map<String, dynamic> toJson() {
    return {
      "textId": textId,
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
      "isDeleted": isDeleted,
    };
  }
}
