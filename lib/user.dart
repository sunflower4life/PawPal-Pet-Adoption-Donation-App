class User {
  String? user_id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? regDate;

  User({
    this.user_id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.regDate,
  });

  User.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    regDate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'reg_date': regDate,
    };
  }
}
