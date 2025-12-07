import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/verification_repository.dart';
import '../data/models/verification_document.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepository repository;
  final List<VerificationDocument> _uploadedDocuments = [];
  final Map<String, String> _formData = {};

  VerificationCubit({required this.repository}) : super(VerificationInitial());

  void startVerification() {
    _uploadedDocuments.clear();
    _formData.clear();
    emit(
      VerificationFormFilling(
        uploadedDocuments: List.from(_uploadedDocuments),
        formData: Map.from(_formData),
      ),
    );
  }

  void updateFormField(String field, String value) {
    _formData[field] = value;
    emit(
      VerificationFormFilling(
        uploadedDocuments: List.from(_uploadedDocuments),
        formData: Map.from(_formData),
      ),
    );
  }

  Future<void> uploadDocument(String documentType, String filePath) async {
    emit(DocumentUploading(documentType));

    final response = await repository.uploadDocument(documentType, filePath);

    if (response.success && response.data != null) {
      final document = VerificationDocument(
        documentType: documentType,
        documentUrl: response.data,
        localPath: filePath,
        status: 'uploaded',
        uploadedAt: DateTime.now(),
      );

      _uploadedDocuments.add(document);

      emit(DocumentUploaded(document));
      emit(
        VerificationFormFilling(
          uploadedDocuments: List.from(_uploadedDocuments),
          formData: Map.from(_formData),
        ),
      );
    } else {
      emit(VerificationError(response.error ?? 'Failed to upload document'));
      emit(
        VerificationFormFilling(
          uploadedDocuments: List.from(_uploadedDocuments),
          formData: Map.from(_formData),
        ),
      );
    }
  }

  void removeDocument(String documentType) {
    _uploadedDocuments.removeWhere((doc) => doc.documentType == documentType);
    emit(
      VerificationFormFilling(
        uploadedDocuments: List.from(_uploadedDocuments),
        formData: Map.from(_formData),
      ),
    );
  }

  Future<void> submitVerification(String userId, List<String> services) async {
    // Validate form
    if (_uploadedDocuments.isEmpty) {
      emit(VerificationError('Please upload at least one document'));
      return;
    }

    if (!_formData.containsKey('experience_years') ||
        _formData['experience_years']!.isEmpty) {
      emit(VerificationError('Please enter your years of experience'));
      return;
    }

    if (!_formData.containsKey('description') ||
        _formData['description']!.isEmpty) {
      emit(VerificationError('Please provide a description'));
      return;
    }

    emit(SubmittingVerification());

    final verificationData = VerificationData(
      userId: userId,
      services: services,
      experienceYears: _formData['experience_years']!,
      description: _formData['description']!,
      documents: _uploadedDocuments,
      certifications: _formData['certifications'],
    );

    final response = await repository.submitVerification(verificationData);

    if (response.success) {
      emit(
        VerificationSubmitted(
          'Verification submitted successfully. We will review your application.',
        ),
      );
      _clearForm();
    } else {
      emit(
        VerificationError(response.error ?? 'Failed to submit verification'),
      );
      emit(
        VerificationFormFilling(
          uploadedDocuments: List.from(_uploadedDocuments),
          formData: Map.from(_formData),
        ),
      );
    }
  }

  Future<void> checkVerificationStatus(String userId) async {
    final response = await repository.getVerificationStatus(userId);

    if (response.success && response.data != null) {
      emit(VerificationStatusLoaded(response.data!));
    } else {
      emit(
        VerificationError(
          response.error ?? 'Failed to get verification status',
        ),
      );
    }
  }

  void _clearForm() {
    _uploadedDocuments.clear();
    _formData.clear();
  }

  void resetState() {
    _clearForm();
    emit(VerificationInitial());
  }
}
