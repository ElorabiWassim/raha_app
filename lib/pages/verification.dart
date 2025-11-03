import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool idUploaded = false;
  bool certUploaded = false;
  bool photoUploaded = false;
  bool showSuccess = false;

  bool get canSubmit => idUploaded && photoUploaded;

  @override
  Widget build(BuildContext context) {
    if (showSuccess) {
      return _buildSuccessScreen();
    }

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
                      Icon(Icons.verified, color: Color(0xFF4CAF50), size: 28),
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
                    subtitle: 'Required for verification',
                    isUploaded: idUploaded,
                    onTap: () {
                      setState(() {
                        idUploaded = !idUploaded;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DocumentUploadCard(
                    icon: Icons.school,
                    title: 'Professional Certificate',
                    subtitle: 'Optional',
                    isUploaded: certUploaded,
                    onTap: () {
                      setState(() {
                        certUploaded = !certUploaded;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DocumentUploadCard(
                    icon: Icons.account_circle,
                    title: 'Profile Picture',
                    subtitle: 'Clear headshot required',
                    isUploaded: photoUploaded,
                    onTap: () {
                      setState(() {
                        photoUploaded = !photoUploaded;
                      });
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
                          setState(() {
                            showSuccess = true;
                          });
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
                  child: const Text(
                    'Submit for Review',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
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
                      setState(() {
                        showSuccess = false;
                        idUploaded = false;
                        certUploaded = false;
                        photoUploaded = false;
                      });
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
                      : const Color(0xFFE5E7EB),
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
