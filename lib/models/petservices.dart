class PetService {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  String? imagePaths;
  String? lat;
  String? lng;
  String? createdAt;

  // Optional: user details (from JOIN)
  String? userName;
  String? userEmail;
  String? userPhone;
  // REMOVED: String? userRegDate;

  PetService({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.category,
    this.description,
    this.imagePaths,
    this.lat,
    this.lng,
    this.createdAt,
    this.userName,
    this.userEmail,
    this.userPhone,
    // REMOVED: this.userRegDate,
  });

  PetService.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    category = json['category'];
    description = json['description'];
    imagePaths = json['image_paths'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['created_at'];

    // JOINED user data
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    // REMOVED: userRegDate = json['user_regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['category'] = category;
    data['description'] = description;
    data['image_paths'] = imagePaths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;

    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    // REMOVED: data['user_regdate'] = userRegDate;

    return data;
  }
}