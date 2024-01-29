class ChatRoomModel {
  final String chatRoomId;
  final String personA;
  final String personB;

  ChatRoomModel({
    required this.chatRoomId,
    required this.personA,
    required this.personB,
  });

  ChatRoomModel.fromJson(
    Map<String, dynamic> json,
  )   : chatRoomId = json["chatRoomId"],
        personA = json["personA"],
        personB = json["personB"];
}
