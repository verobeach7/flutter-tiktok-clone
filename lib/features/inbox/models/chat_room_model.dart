class ChatRoomModel {
  final String chatRoomId;
  final String personA;
  final String personB;
  final int lastStamp;
  final String lastText;

  ChatRoomModel({
    required this.chatRoomId,
    required this.personA,
    required this.personB,
    required this.lastStamp,
    required this.lastText,
  });

  ChatRoomModel.fromJson(
    Map<String, dynamic> json,
  )   : chatRoomId = json["chatRoomId"],
        personA = json["personA"],
        personB = json["personB"],
        lastStamp = json["lastStamp"],
        lastText = json["lastText"];
}
