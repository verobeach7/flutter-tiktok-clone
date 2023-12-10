class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
  });

  // 유저가 앱을 처음 실행하여 가입하는 경우. 즉, 계정이 없는 경우
  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "";

  // UserProfileModel을 json으로 만드는 메서드
  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
    };
  }

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"];
}
