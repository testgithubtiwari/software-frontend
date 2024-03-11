class AllApplicationUserModel {
  String? sId;
  String? userId;
  String? resumeLink;
  DesignCreditId? designCreditId;
  // String? createdAt;
  // String? updatedAt;
  // int? iV;

  AllApplicationUserModel({
    this.sId,
    this.userId,
    this.resumeLink,
    this.designCreditId,
    // this.createdAt,
    // this.updatedAt,
    // this.iV,
  });

  AllApplicationUserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    resumeLink = json['resumeLink'];
    designCreditId = json['designCreditId'] != null
        ? DesignCreditId.fromJson(json['designCreditId'])
        : null;
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    // iV = json['__v'];
  }
}

class DesignCreditId {
  String? sId;
  String? projectName;
  String? description;

  DesignCreditId({this.sId, this.projectName, this.description});

  DesignCreditId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    projectName = json['projectName'];
    description = json['description'];
  }
}
