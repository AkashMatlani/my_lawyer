class CaseModel {
  String id;
  String name;

  CaseModel(this.id, this.name);

  factory CaseModel.fromJson(Map<String, dynamic> data) {
    return CaseModel(data['id'], data['name']);
  }
}


class CaseListModel {
  List<CaseModel> caseList;

  CaseListModel({this.caseList});

  CaseListModel.fromJson(Map<String, dynamic> json) {

    List<dynamic> jsonList = json['data'];
    caseList = [];

    jsonList.forEach((item) {
      caseList.add(CaseModel.fromJson(item));
    });
  }
}