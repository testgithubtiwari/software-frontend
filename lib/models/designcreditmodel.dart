class DesignCreditModel {
  String? sId;
  String? projectName;
  List<String>? eligibleBranches;
  String? professorName;
  String? offeredBy;
  String? description;
  UserId? userId;

  DesignCreditModel({
    this.sId,
    this.projectName,
    this.eligibleBranches,
    this.userId,
    this.professorName,
    this.offeredBy,
    this.description,
  });

  DesignCreditModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    projectName = json['projectName'];
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    eligibleBranches = json['eligibleBranches'].cast<String>();
    professorName = json['professorName'];
    offeredBy = json['offeredBy'];
    description = json['description'];
  }
}

class UserId {
  String? sId;
  String? name;
  String? email;

  UserId({this.sId, this.name, this.email});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
  }
}
