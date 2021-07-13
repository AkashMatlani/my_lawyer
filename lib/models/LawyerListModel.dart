class LawyerListModel {
  List<LawyerDataModel> data;
  LawyerMetaModel meta;

  LawyerListModel({this.data, this.meta});

  LawyerListModel.fromJson(dynamic json) {
    data = [];

    List<dynamic> jsonList = json['data'];
    jsonList.forEach((item) {
      data.add(LawyerDataModel.fromJson(item));
    });

    meta = LawyerMetaModel.fromJson(json['meta']);
  }
}

class LawyerDataModel {
  int caseId;
  int lawyerId;
  String lawyerName;
  String userProfile;
  String about;
  String bidAmount;
  bool isLike;
  bool isFav;
  int likeCount;
  String email;

  LawyerDataModel(
      {this.caseId,
      this.lawyerId,
      this.lawyerName,
      this.userProfile,
      this.about,
      this.bidAmount,
      this.isLike,
      this.isFav,
      this.likeCount,
      this.email});

  factory LawyerDataModel.fromJson(Map<String, dynamic> data) {
    return LawyerDataModel(
      caseId: data['caseId'],
      lawyerId: data['lawyerId'],
      lawyerName: data['lawyerName'],
      userProfile: data['lawyerProfile'],
      about: data['about'],
      bidAmount: data['bidAmount'],
      isLike: data['isLike'],
      isFav: data['isFav'],
      likeCount: data['likeCount'],
      email: data['email']
    );
  }
}

class LawyerMetaModel {
  int count;
  int status;

  LawyerMetaModel({this.count, this.status});

  factory LawyerMetaModel.fromJson(Map<String, dynamic> meta) {
    return LawyerMetaModel(count: meta['count'], status: meta['status']);
  }
}
