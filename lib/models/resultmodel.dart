class ResultModel {
  String? sId;
  DesignCreditId? designCreditId;
  String? status;
  UserId? userId;
  // String? createdAt;
  // String? updatedAt;
  // int? iV;

  ResultModel({
    this.sId,
    this.designCreditId,
    this.status,
    this.userId,
    // this.createdAt,
    // this.updatedAt,
    // this.iV,
  });

  ResultModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    designCreditId = json['designCreditId'] != null
        ? new DesignCreditId.fromJson(json['designCreditId'])
        : null;
    status = json['status'];
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    // iV = json['__v'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['_id'] = this.sId;
  //   if (this.designCreditId != null) {
  //     data['designCreditId'] = this.designCreditId!.toJson();
  //   }
  //   data['status'] = this.status;
  //   if (this.userId != null) {
  //     data['userId'] = this.userId!.toJson();
  //   }
  //   data['createdAt'] = this.createdAt;
  //   data['updatedAt'] = this.updatedAt;
  //   data['__v'] = this.iV;
  //   return data;
  // }
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

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['_id'] = this.sId;
  //   data['projectName'] = this.projectName;
  //   data['description'] = this.description;
  //   return data;
  // }
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

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['_id'] = this.sId;
  //   data['name'] = this.name;
  //   data['email'] = this.email;
  //   data['rollNumber'] = this.rollNumber;
  //   return data;
  // }
}
