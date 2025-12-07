import 'package:equatable/equatable.dart';
import '../data/models/verification_document.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

class VerificationInitial extends VerificationState {}

class VerificationFormFilling extends VerificationState {
  final List<VerificationDocument> uploadedDocuments;
  final Map<String, String> formData;

  const VerificationFormFilling({
    this.uploadedDocuments = const [],
    this.formData = const {},
  });

  @override
  List<Object?> get props => [uploadedDocuments, formData];

  VerificationFormFilling copyWith({
    List<VerificationDocument>? uploadedDocuments,
    Map<String, String>? formData,
  }) {
    return VerificationFormFilling(
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      formData: formData ?? this.formData,
    );
  }
}

class DocumentUploading extends VerificationState {
  final String documentType;

  const DocumentUploading(this.documentType);

  @override
  List<Object?> get props => [documentType];
}

class DocumentUploaded extends VerificationState {
  final VerificationDocument document;

  const DocumentUploaded(this.document);

  @override
  List<Object?> get props => [document];
}

class SubmittingVerification extends VerificationState {}

class VerificationSubmitted extends VerificationState {
  final String message;

  const VerificationSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class VerificationStatusLoaded extends VerificationState {
  final Map<String, dynamic> statusData;

  const VerificationStatusLoaded(this.statusData);

  @override
  List<Object?> get props => [statusData];
}

class VerificationError extends VerificationState {
  final String message;

  const VerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
