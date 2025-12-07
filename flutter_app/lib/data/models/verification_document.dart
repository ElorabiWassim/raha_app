class VerificationDocument {
  final String? documentId;
  final String documentType;
  final String? documentUrl;
  final String? localPath;
  final String status;
  final DateTime? uploadedAt;

  VerificationDocument({
    this.documentId,
    required this.documentType,
    this.documentUrl,
    this.localPath,
    this.status = 'pending',
    this.uploadedAt,
  });

  factory VerificationDocument.fromJson(Map<String, dynamic> json) {
    return VerificationDocument(
      documentId: json['document_id'],
      documentType: json['document_type'] ?? '',
      documentUrl: json['document_url'],
      status: json['status'] ?? 'pending',
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_url': documentUrl,
      'status': status,
    };
  }
}

class VerificationData {
  final String userId;
  final List<String> services;
  final String experienceYears;
  final String description;
  final List<VerificationDocument> documents;
  final String? certifications;

  VerificationData({
    required this.userId,
    required this.services,
    required this.experienceYears,
    required this.description,
    required this.documents,
    this.certifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'services': services,
      'experience_years': experienceYears,
      'description': description,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'certifications': certifications,
    };
  }
}
