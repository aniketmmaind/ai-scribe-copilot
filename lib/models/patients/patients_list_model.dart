class PatientListModel {
  PatientListModel({required this.patients});

  final List<Patient> patients;

  PatientListModel copyWith({List<Patient>? patients}) {
    return PatientListModel(patients: patients ?? this.patients);
  }

  factory PatientListModel.fromJson(Map<String, dynamic> json) {
    return PatientListModel(
      patients:
          json["patients"] == null
              ? []
              : List<Patient>.from(
                json["patients"]!.map((x) => Patient.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "patients": patients.map((x) => x.toJson()).toList(),
  };
}

class Patient {
  Patient({required this.id, required this.name, required this.email});

  final String? id;
  final String? name;
  final String? email;

  Patient copyWith({String? id, String? name, String? email}) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(id: json["id"], name: json["name"], email: json["email"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
