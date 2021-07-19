
class AdListModel {
  List<AdDataModel> data;

  AdListModel({this.data});

  AdListModel.fromJson(dynamic json) {
    data = [];

    List<dynamic> jsonList = json['data'];
    jsonList.forEach((item) {
      data.add(AdDataModel.fromJson(item));
    });
  }
}

class AdDataModel {
  int adId;
  String adImg;

  AdDataModel(this.adId, this.adImg);

  factory AdDataModel.fromJson(Map<String, dynamic> json) {
    return AdDataModel(int.parse(json['adId']), json['adImg']);
  }
}