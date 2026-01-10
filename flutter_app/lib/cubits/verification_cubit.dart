import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<String?> _getPendingUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingId = prefs.getString('pending_user_id');
    if (pendingId != null && pendingId.isNotEmpty) return pendingId;
    final userId = prefs.getString('user_id');
    if (userId != null && userId.isNotEmpty) return userId;
    return null;
  }

  Future<void> uploadDocument(String documentType, String filePath) async {
    emit(DocumentUploading(documentType));

    final userId = await _getPendingUserId();
    if (userId == null) {
      emit(VerificationError('Missing user info. Please sign up again.'));
      emit(
        VerificationFormFilling(
          uploadedDocuments: List.from(_uploadedDocuments),
          formData: Map.from(_formData),
        ),
      );
      return;
    }

    final response = await repository.uploadDocument(
      userId,
      documentType,
      filePath,
    );

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

  Future<void> submitVerification(List<String> services) async {
    // Validate form
    if (_uploadedDocuments.isEmpty) {
      emit(VerificationError('Please upload at least one document'));
      return;
    }

    final userId = await _getPendingUserId();
    if (userId == null) {
      emit(VerificationError('Missing user info. Please sign up again.'));
      return;
    }

    emit(SubmittingVerification());

    final verificationData = VerificationData(
      userId: userId,
      services: services,
      experienceYears: _formData['experience_years'] ?? '0',
      description: _formData['description'] ?? '',
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
