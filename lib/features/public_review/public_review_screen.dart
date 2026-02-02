import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicReviewScreen extends StatelessWidget {
  const PublicReviewScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final contentPadding = isMobile ? 24.0 : 32.0; // Reduced padding for mobile
          final horizontalPadding = isMobile ? 16.0 : 24.0; 

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: isMobile ? 48 : 64, // Smaller icon on mobile
                    color: const Color(0xFF1A73E8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'GlobalTrustHub',
                    style: GoogleFonts.outfit(
                      fontSize: isMobile ? 24 : 32, // Smaller title on mobile
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber[300]!),
                    ),
                    child: Text(
                      'Public MVP Review',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[900],
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 48),

                  // The Main Card
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    width: double.infinity, // Take available width up to max
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome Reviewers 👋',
                            style: GoogleFonts.outfit(
                              fontSize: isMobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This is an early architecture-stage demo of GlobalTrustHub. We welcome technical and product feedback to help us build a trusted ecosystem.',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 14 : 16,
                              height: 1.5,
                              color: const Color(0xFF64748B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Links Section
                          _buildreviewLink(
                            icon: Icons.rocket_launch_rounded,
                            color: const Color(0xFF10B981),
                            title: 'Live App Demo',
                            subtitle: 'Experience the user journey',
                            onTap: () => _launchUrl('https://globaltrusthub-60e73.web.app'),
                            isMobile: isMobile,
                          ),
                          const SizedBox(height: 16),
                          _buildreviewLink(
                            icon: FontAwesomeIcons.github,
                            color: const Color(0xFF24292F),
                            title: 'Frontend Repository',
                            subtitle: 'Flutter Web Architecture',
                            onTap: () => _launchUrl('https://github.com/asifgondal786/globaltrusthubfrontend'),
                            isMobile: isMobile,
                          ),
                          const SizedBox(height: 16),
                          _buildreviewLink(
                            icon: FontAwesomeIcons.server,
                            color: const Color(0xFF0EA5E9),
                            title: 'Backend Repository',
                            subtitle: 'FastAPI + ML Services',
                            onTap: () => _launchUrl('https://github.com/asifgondal786/globaltrusthubbackend'),
                            isMobile: isMobile,
                          ),
                           const SizedBox(height: 16),
                          _buildreviewLink(
                            icon: Icons.feedback_outlined,
                            color: const Color(0xFF8B5CF6), // Violet 500
                            title: 'Submit Feedback',
                            subtitle: 'Share your thoughts',
                             // TODO: User to replace with actual form link
                            onTap: () => _launchUrl('https://forms.gle/your-form-id'),
                            isPrimary: true,
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Footer/Disclaimer
                   Text(
                    '© 2024 GlobalTrustHub • Early Architecture Build',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildreviewLink({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isMobile = false,
  }) {
    return Material(
      color: isPrimary ? color.withValues(alpha: 0.05) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: color.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 16, 
            horizontal: isMobile ? 16 : 20,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isPrimary ? color : const Color(0xFFE2E8F0),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isMobile ? 20 : 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    if (!isMobile) // Optional: hide subtitle on very small screens if needed, but keeping for now
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isMobile)
                     Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
