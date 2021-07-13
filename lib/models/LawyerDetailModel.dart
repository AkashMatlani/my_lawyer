import 'package:my_lawyer/models/LawyerListModel.dart';

class LawyerDetailModel {
  LawyerDataModel data;
  LawyerMetaModel meta;

  LawyerDetailModel(this.data, this.meta);

  factory LawyerDetailModel.fromJson(Map<String, dynamic> json) {
    return LawyerDetailModel(LawyerDataModel.fromJson(json['data']),
        LawyerMetaModel.fromJson(json['meta']));
  }
}

class LawyerMetaModel {
  int status;

  LawyerMetaModel(this.status);

  factory LawyerMetaModel.fromJson(Map<String, dynamic> meta) {
    return LawyerMetaModel(meta['status']);
  }
}
