// ignore: file_names
class UserModelDesignCredit {
  String? name;
  String? sId;
  String? email;
  String? password;
  String? userType;
  String? rollNumber;
  String? branch;
  // String? createdAt;
  // String? updatedAt;
  // int? iV;

  UserModelDesignCredit({
    this.name,
    this.sId,
    this.email,
    this.password,
    this.userType,
    this.rollNumber,
    this.branch,
    // this.createdAt,
    // this.updatedAt,
    // this.iV
  });

  UserModelDesignCredit.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
    email = json['email'];
    password = json['password'];
    userType = json['userType'];
    rollNumber = json['rollNumber'];
    branch = json['branch'];
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    // iV = json['__v'];
  }
}
