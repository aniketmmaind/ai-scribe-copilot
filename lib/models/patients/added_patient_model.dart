class AddedPatientModel {
    AddedPatientModel({
        required this.patient,
    });

    final Patient? patient;

    AddedPatientModel copyWith({
        Patient? patient,
    }) {
        return AddedPatientModel(
            patient: patient ?? this.patient,
        );
    }

    factory AddedPatientModel.fromJson(Map<String, dynamic> json){ 
        return AddedPatientModel(
            patient: json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "patient": patient?.toJson(),
    };

}

class Patient {
    Patient({
        required this.id,
        required this.name,
        required this.userId,
        required this.pronouns,
    });

    final String? id;
    final String? name;
    final String? userId;
    final String? pronouns;

    Patient copyWith({
        String? id,
        String? name,
        String? userId,
        String? pronouns,
    }) {
        return Patient(
            id: id ?? this.id,
            name: name ?? this.name,
            userId: userId ?? this.userId,
            pronouns: pronouns ?? this.pronouns,
        );
    }

    factory Patient.fromJson(Map<String, dynamic> json){ 
        return Patient(
            id: json["id"],
            name: json["name"],
            userId: json["user_id"],
            pronouns: json["pronouns"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "pronouns": pronouns,
    };

}
