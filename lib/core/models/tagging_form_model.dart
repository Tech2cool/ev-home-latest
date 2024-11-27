class TaggingForm {
  final String startDate;
  final String validTillDate;
  final String clientName;
  final String clientPhoneNumber;
  final String? clientAltPhoneNumber;
  final String clientEmail;
  final List<String> selectedProjects;
  final List<String> requirement;
  final String remark;
  final String teamLeader;
  final String dataAnalyser;
  final String cpRefrenceId;
  final String dataAnalyserRefId;
  final String tlRefId;
  final String cpName;
  final String cpFirmName;
  final String taggingStatus;
  final bool readByDataAnalyser;
  final bool readByTeamLeader;
  final List<String>? readHistory;

  TaggingForm({
    required this.startDate,
    required this.validTillDate,
    required this.clientName,
    required this.clientPhoneNumber,
    this.clientAltPhoneNumber,
    required this.clientEmail,
    required this.selectedProjects,
    required this.requirement,
    required this.remark,
    required this.teamLeader,
    required this.dataAnalyser,
    required this.cpRefrenceId,
    required this.cpName,
    required this.cpFirmName,
    required this.taggingStatus,
    required this.tlRefId,
    required this.dataAnalyserRefId,
    this.readByDataAnalyser = false,
    this.readByTeamLeader = false,
    this.readHistory,
  });

  factory TaggingForm.fromJson(Map<String, dynamic> json) {
    return TaggingForm(
      startDate: (json["startDate"]),
      validTillDate: (json["validTillDate"]),
      clientName: json["clientName"] ?? '',
      clientPhoneNumber: json["clientPhoneNumber"] ?? '',
      clientAltPhoneNumber: json["clientAltPhoneNumber"],
      clientEmail: json["clientEmail"] ?? '',
      selectedProjects: List<String>.from(json["selectedProjects"] ?? []),
      requirement: List<String>.from(json["requirement"] ?? []),
      remark: json["remark"] ?? '',
      teamLeader: json["teamLeader"] ?? '',
      dataAnalyser: json["dataAnalyser"] ?? '',
      cpRefrenceId: json["cpRefrenceId"],
      cpName: json["cpName"] ?? '',
      cpFirmName: json["cpFirmName"] ?? '',
      taggingStatus: json["taggingStatus"] ?? '',
      tlRefId: json["tlRefId"] ?? '',
      dataAnalyserRefId: json["dataAnalyserRefId"] ?? '',
      readByDataAnalyser: json["readByDataAnalyser"] ?? false,
      readByTeamLeader: json["readByTeamLeader"] ?? false,
      readHistory: List<String>.from(json["readHistory"] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "startDate": startDate,
      "validTillDate": validTillDate,
      "clientName": clientName,
      "clientPhoneNumber": clientPhoneNumber,
      "clientAltPhoneNumber": clientAltPhoneNumber,
      "clientEmail": clientEmail,
      "selectedProjects": selectedProjects.toList(),
      "requirement": requirement.toList(),
      "remark": remark,
      "teamLeader": teamLeader,
      "dataAnalyser": dataAnalyser,
      "cpRefrenceId": cpRefrenceId,
      "cpName": cpName,
      "cpFirmName": cpFirmName,
      "taggingStatus": taggingStatus,
      "tlRefId": tlRefId,
      "dataAnalyserRefId": dataAnalyserRefId,
      "readByTeamLeader": readByTeamLeader,
      "readByDataAnalyser": readByDataAnalyser,
      "readHistory": readHistory?.toList() ?? [],
    };
  }
}
