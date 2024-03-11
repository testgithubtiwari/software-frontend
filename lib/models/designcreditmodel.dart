class DesignCreditModel {
  String? sId;
  String? projectName;
  List<String>? eligibleBranches;
  String? professorName;
  String? offeredBy;
  String? description;

  DesignCreditModel({
    this.sId,
    this.projectName,
    this.eligibleBranches,
    this.professorName,
    this.offeredBy,
    this.description,
  });

  DesignCreditModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    projectName = json['projectName'];
    eligibleBranches = json['eligibleBranches'].cast<String>();
    professorName = json['professorName'];
    offeredBy = json['offeredBy'];
    description = json['description'];
  }
}
