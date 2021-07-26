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
  String caseType;

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
      this.email,
      this.caseType});

  factory LawyerDataModel.fromJson(Map<String, dynamic> data) {
    return LawyerDataModel(
        caseId: data['caseId'],
        lawyerId: data['lawyerId'],
        lawyerName: data['lawyerName'],
        userProfile: data['lawyerProfile'],
        about: (data['about'] == null) ? '' : data['about'],
        bidAmount: data['bidAmount'],
        isLike: (data['isLike'] == null) ? false : data['isLike'],
        isFav: (data['isFav'] == null) ? false : data['isFav'],
        likeCount: data['likeCount'],
        email: data['email'],
        caseType: data['caseType']);
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
