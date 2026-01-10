import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ra7a/cubits/verification_cubit.dart';
import 'package:ra7a/cubits/verification_state.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<VerificationCubit>()..startVerification(),
      child: const _VerificationPageContent(),
    );
  }
}

class _VerificationPageContent extends StatelessWidget {
  const _VerificationPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerificationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is VerificationSubmitted) {
          return _buildSuccessScreen(context);
        }

        bool idUploaded = false;
        bool certUploaded = false;
        bool photoUploaded = false;
        bool isSubmitting = false;

        if (state is VerificationFormFilling) {
          idUploaded = state.uploadedDocuments.any(
            (doc) => doc.documentType == 'id',
          );
          certUploaded = state.uploadedDocuments.any(
            (doc) => doc.documentType == 'certificate',
          );
          photoUploaded = state.uploadedDocuments.any(
            (doc) => doc.documentType == 'photo',
          );
        } else if (state is SubmittingVerification) {
          isSubmitting = true;
          idUploaded = true;
          certUploaded = true;
          photoUploaded = true;
        }

        bool canSubmit =
            idUploaded && certUploaded && photoUploaded && !isSubmitting;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F8F8),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.verified,
                            color: Color(0xFF4CAF50),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Document Verification',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388E3C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload your documents for verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                // Documents List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      DocumentUploadCard(
                        icon: Icons.badge,
                        title: 'National ID / Passport',
                        subtitle: 'Required',
                        isUploaded: idUploaded,
                        onTap: () async {
                          // TODO: Implement file picker
                          // For now, using placeholder path
                          await context
                              .read<VerificationCubit>()
                              .uploadDocument('id', 'path/to/id');
                        },
                      ),
                      const SizedBox(height: 16),
                      DocumentUploadCard(
                        icon: Icons.school,
                        title: 'Professional Certificate',
                        subtitle: 'Required',
                        isUploaded: certUploaded,
                        onTap: () async {
                          // TODO: Implement file picker
                          await context
                              .read<VerificationCubit>()
                              .uploadDocument('certificate', 'path/to/cert');
                        },
                      ),
                      const SizedBox(height: 16),
                      DocumentUploadCard(
                        icon: Icons.account_circle,
                        title: 'Profile Picture',
                        subtitle: 'Clear headshot required',
                        isUploaded: photoUploaded,
                        onTap: () async {
                          // TODO: Implement file picker
                          await context
                              .read<VerificationCubit>()
                              .uploadDocument('photo', 'path/to/photo');
                        },
                      ),
                    ],
                  ),
                ),

                // Submit Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canSubmit
                          ? () {
                              context
                                  .read<VerificationCubit>()
                                  .submitVerification([]);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Submit for Review',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Application Submitted!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "We're reviewing your documents. You'll receive a notification within 2-3 business days.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<VerificationCubit>().resetState();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Verification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentUploadCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isUploaded;
  final VoidCallback onTap;

  const DocumentUploadCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF4CAF50), size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Upload Area
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isUploaded ? const Color(0xFFE8F5E9) : Colors.grey[50],
                border: Border.all(
                  color: isUploaded
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE8F5E9), // Fixed color
                  width: 2,
                  style: isUploaded ? BorderStyle.solid : BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    isUploaded ? Icons.check_circle : Icons.upload_file,
                    color: isUploaded
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF6B7280),
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isUploaded ? 'Document Uploaded' : 'Tap to Upload',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUploaded
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Accepted: JPG, PNG, PDF. Max size: 5MB',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
