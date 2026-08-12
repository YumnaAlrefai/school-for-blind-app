class UserModel {

  final int id;
  final String name;
  final String phone;


  UserModel({
    required this.id,
    required this.name,
    required this.phone,
  });



  factory UserModel.fromJson(
      Map<String,dynamic> json
  ){

    return UserModel(

      id: json["id"] ?? 0,

      name: json["name"] ?? "",

      phone: json["phone"] ?? "",

    );

  }

}