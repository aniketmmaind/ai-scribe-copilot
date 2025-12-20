class PresignedModel {
    PresignedModel({
        required this.url,
        required this.gcsPath,
        required this.publicUrl,
    });

    final String? url;
    final String? gcsPath;
    final String? publicUrl;

    PresignedModel copyWith({
        String? url,
        String? gcsPath,
        String? publicUrl,
    }) {
        return PresignedModel(
            url: url ?? this.url,
            gcsPath: gcsPath ?? this.gcsPath,
            publicUrl: publicUrl ?? this.publicUrl,
        );
    }

    factory PresignedModel.fromJson(Map<String, dynamic> json){ 
        return PresignedModel(
            url: json["url"],
            gcsPath: json["gcsPath"],
            publicUrl: json["publicUrl"],
        );
    }

    Map<String, dynamic> toJson() => {
        "url": url,
        "gcsPath": gcsPath,
        "publicUrl": publicUrl,
    };

}
