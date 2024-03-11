class AllApplicationsModel {
  String? sId;
  UserId? userId;
  String? resumeLink;
  DesignCreditId? designCreditId;
  // String? createdAt;
  // String? updatedAt;
  // int? iV;

  AllApplicationsModel({
    this.sId,
    this.userId,
    this.resumeLink,
    this.designCreditId,
    // this.createdAt,
    // this.updatedAt,
    // this.iV,
  });

  AllApplicationsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
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

  DesignCreditId({
    this.sId,
    this.projectName,
    this.description,
  });

  DesignCreditId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    projectName = json['projectName'];
    description = json['description'];
  }
}

class UserId {
  String? sId;
  String? name;
  String? email;

  UserId({
    this.sId,
    this.name,
    this.email,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
  }
}
