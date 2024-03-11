class AllApplicationDesignCreditModel {
  String? sId;
  UserId? userId;
  String? resumeLink;
  String? designCreditId;

  AllApplicationDesignCreditModel({
    this.sId,
    this.userId,
    this.resumeLink,
    this.designCreditId,
  });

  AllApplicationDesignCreditModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    resumeLink = json['resumeLink'];
    designCreditId = json['designCreditId'];
  }
}

class UserId {
  String? sId;
  String? name;
  String? email;
  String? rollNumber;

  UserId({this.sId, this.name, this.email, this.rollNumber});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    rollNumber = json['rollNumber'];
  }
}
