import 'package:my_lawyer/view/Lawyer/CaseDetailScreen.dart';

class CaseDetailModel {
  int caseId;
  int userId;
  String clientName;
  String clientProfile;
  String caseType;
  String description;
  List<dynamic> attachment;

  CaseDetailModel(
      {this.caseId,
this.userId,
      this.clientName,
      this.clientProfile,
      this.caseType,
      this.description,
      this.attachment});

  factory CaseDetailModel.fromJson(Map<String, dynamic> data) {
    return CaseDetailModel(
        caseId: data['caseId'],
        userId: data['userId'],
        clientName: data['clientName'],
        clientProfile: data['clientProfile'],
        caseType: data['caseTypeName'],
        description: data['description'],
        attachment: ((data['attachment'] as List<dynamic>) == null) || (data['attachment'] as List<dynamic>).first == '' ? [] : data['attachment']);
  }
}
