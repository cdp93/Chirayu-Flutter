class ResponseData {
  final List<DataArr> data;

  ResponseData._({this.data});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    //print(list.runtimeType);
    List<DataArr> imagesList = list.map((i) => DataArr.fromJson(i)).toList();

    return new ResponseData._(data: imagesList);
  }
}

class DataArr {
  int id;
  String email;
  String first_name;
  String last_name;
  String avatar;

  DataArr.put(
      {this.id, this.email, this.first_name, this.last_name, this.avatar});

  factory DataArr.fromJson(Map<String, dynamic> json) {
    return new DataArr.put(
      id: json['id'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      avatar: json['avatar'],
    );
  }

  factory DataArr.fromMap(Map<String, dynamic> json) => new DataArr.put(
        id: json["id"],
        email: json["email"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "first_name": first_name,
        "last_name": last_name,
        "avatar": avatar,
      };
}
