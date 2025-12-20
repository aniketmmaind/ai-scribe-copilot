class PatientDetailModel {
  final String? name;
  final String? userId;
  final String? patientId;
  final String? pronoun;
  final String? email;
  final String? background;
  final String? mediHist;
  final String? familyHist;
  final String? socialHist;
  final String? prevHist;

  PatientDetailModel({
    this.name,
    this.userId,
    this.patientId,
    this.pronoun,
    this.email,
    this.background,
    this.mediHist,
    this.familyHist,
    this.socialHist,
    this.prevHist,
  });

  PatientDetailModel copyWith({
    String? name,
    String? userId,
    String? patientId,
    String? pronoun,
    String? email,
    String? background,
    String? mediHist,
    String? familyHist,
    String? socialHist,
    String? prevHist,
  }) {
    return PatientDetailModel(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      patientId: patientId ?? this.patientId,
      pronoun: pronoun ?? this.pronoun,
      email: email ?? this.email,
      background: background ?? this.background,
      mediHist: mediHist ?? this.mediHist,
      familyHist: familyHist ?? this.familyHist,
      socialHist: socialHist ?? this.socialHist,
      prevHist: prevHist ?? this.prevHist,
    );
  }

  factory PatientDetailModel.fromJson(Map<String, dynamic> json) {
    return PatientDetailModel(
      name: json["name"],
      userId: json["userId"],
      patientId: json["id"],
      pronoun: json["pronouns"],
      email: json["email"],
      background: json["background"],
      mediHist: json["medical_history"],
      familyHist: json["family_history"],
      socialHist: json["social_history"],
      prevHist: json["previous_treatment"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "userId": userId,
      "pronoun": pronoun,
      "email": email,
      "background": background,
      "mediHist": mediHist,
      "familyHist": familyHist,
      "socialHist": socialHist,
      "prevHist": prevHist,
    };
  }
}
