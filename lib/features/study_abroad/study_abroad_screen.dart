import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class StudyAbroadScreen extends StatefulWidget {
  const StudyAbroadScreen({super.key});

  @override
  State<StudyAbroadScreen> createState() => _StudyAbroadScreenState();
}

class _StudyAbroadScreenState extends State<StudyAbroadScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _countries = [
    {
      'name': 'United States',
      'flag': '🇺🇸',
      'universities': 4500,
      'avgTuition': '\$35,000/year',
      'visaType': 'F-1 Student Visa',
      'processingTime': '2-4 months',
      'color': const Color(0xFF1E40AF),
    },
    {
      'name': 'United Kingdom',
      'flag': '🇬🇧',
      'universities': 160,
      'avgTuition': '£15,000/year',
      'visaType': 'Tier 4 Student Visa',
      'processingTime': '3-4 weeks',
      'color': const Color(0xFF991B1B),
    },
    {
      'name': 'Canada',
      'flag': '🇨🇦',
      'universities': 200,
      'avgTuition': 'CAD 25,000/year',
      'visaType': 'Study Permit',
      'processingTime': '8-12 weeks',
      'color': const Color(0xFFDC2626),
    },
    {
      'name': 'Australia',
      'flag': '🇦🇺',
      'universities': 43,
      'avgTuition': 'AUD 30,000/year',
      'visaType': 'Subclass 500',
      'processingTime': '4-6 weeks',
      'color': const Color(0xFF0369A1),
    },
    {
      'name': 'Germany',
      'flag': '🇩🇪',
      'universities': 400,
      'avgTuition': '€500/semester',
      'visaType': 'Student Visa',
      'processingTime': '6-12 weeks',
      'color': const Color(0xFFEAB308),
    },
  ];

  final List<Map<String, dynamic>> _universities = [
    {'name': 'Harvard University', 'country': 'USA', 'ranking': 1, 'programs': 'Law, Business, Medicine'},
    {'name': 'University of Oxford', 'country': 'UK', 'ranking': 2, 'programs': 'Arts, Sciences, Engineering'},
    {'name': 'University of Toronto', 'country': 'Canada', 'ranking': 18, 'programs': 'Engineering, CS, Business'},
    {'name': 'University of Melbourne', 'country': 'Australia', 'ranking': 33, 'programs': 'Medicine, Arts, Law'},
    {'name': 'TU Munich', 'country': 'Germany', 'ranking': 50, 'programs': 'Engineering, CS, Physics'},
  ];

  final List<Map<String, dynamic>> _scholarships = [
    {'name': 'Fulbright Scholarship', 'country': 'USA', 'amount': 'Full Tuition', 'deadline': 'Oct 2026'},
    {'name': 'Chevening Scholarship', 'country': 'UK', 'amount': 'Full Funding', 'deadline': 'Nov 2026'},
    {'name': 'DAAD Scholarship', 'country': 'Germany', 'amount': '€861/month', 'deadline': 'Sep 2026'},
    {'name': 'Australia Awards', 'country': 'Australia', 'amount': 'Full Funding', 'deadline': 'Apr 2026'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Study Abroad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Countries'),
            Tab(text: 'Universities'),
            Tab(text: 'Scholarships'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCountriesTab(),
          _buildUniversitiesTab(),
          _buildScholarshipsTab(),
        ],
      ),
    );
  }

  Widget _buildCountriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _countries.length,
      itemBuilder: (context, index) {
        final country = _countries[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showCountryDetails(country),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: (country['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(country['flag'], style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(country['name'], style: AppTypography.h5),
                          const SizedBox(height: 4),
                          Text(
                            '${country['universities']} Universities',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(country['avgTuition'], style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                        Text('Avg. Tuition', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUniversitiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _universities.length,
      itemBuilder: (context, index) {
        final uni = _universities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('#${uni['ranking']}', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(uni['name'], style: AppTypography.labelLarge),
                    Text('${uni['country']} • ${uni['programs']}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScholarshipsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scholarships.length,
      itemBuilder: (context, index) {
        final scholarship = _scholarships[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(scholarship['name'], style: AppTypography.labelLarge),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${scholarship['country']} • ${scholarship['amount']}', style: AppTypography.bodySmall),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Deadline: ${scholarship['deadline']}', style: AppTypography.caption.copyWith(color: Colors.orange)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCountryDetails(Map<String, dynamic> country) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(country['flag'], style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Text(country['name'], style: AppTypography.h4),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Universities', '${country['universities']}'),
            _buildInfoRow('Avg. Tuition', country['avgTuition']),
            _buildInfoRow('Visa Type', country['visaType']),
            _buildInfoRow('Processing Time', country['processingTime']),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Explore Universities'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTypography.labelMedium),
        ],
      ),
    );
  }
}
