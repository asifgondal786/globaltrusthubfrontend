import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:global_trust_hub/state_management/job_provider.dart';
import 'package:global_trust_hub/services/job_service.dart';

class FindJobsScreen extends StatefulWidget {
  const FindJobsScreen({super.key});

  @override
  State<FindJobsScreen> createState() => _FindJobsScreenState();
}

class _FindJobsScreenState extends State<FindJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _selectedCountry = 'All';
  bool _remoteOnly = false;

  // Trusted Job Resources
  final List<Map<String, dynamic>> _trustedResources = [
    {
      'name': 'LinkedIn',
      'icon': Icons.business_center,
      'color': const Color(0xFF0A66C2),
      'url': 'https://www.linkedin.com/jobs',
      'description': 'Global professional network with millions of job listings',
    },
    {
      'name': 'Indeed',
      'icon': Icons.work,
      'color': const Color(0xFF2164F3),
      'url': 'https://www.indeed.com',
      'description': 'World\'s largest job site with verified employers',
    },
    {
      'name': 'Glassdoor',
      'icon': Icons.star,
      'color': const Color(0xFF0CAA41),
      'url': 'https://www.glassdoor.com',
      'description': 'Company reviews, salaries, and job listings',
    },
    {
      'name': 'SEEK',
      'icon': Icons.search,
      'color': const Color(0xFF9B59B6),
      'url': 'https://www.seek.com.au',
      'description': 'Top job platform in Australia and New Zealand',
    },
    {
      'name': 'Monster',
      'icon': Icons.psychology,
      'color': const Color(0xFF6E2A8B),
      'url': 'https://www.monster.com',
      'description': 'Career resources and job matching services',
    },
    {
      'name': 'Workday',
      'icon': Icons.apartment,
      'color': const Color(0xFFF76800),
      'url': 'https://www.myworkday.com',
      'description': 'Enterprise jobs from Fortune 500 companies',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJobs();
    });
  }

  void _loadJobs() {
    context.read<JobProvider>().loadJobs(
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      country: _selectedCountry == 'All' ? null : _selectedCountry,
      remote: _remoteOnly ? true : null,
      refresh: true,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open $url')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Find Jobs'),
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
            Tab(text: 'Job Listings', icon: Icon(Icons.work_outline, size: 18)),
            Tab(text: 'Trusted Resources', icon: Icon(Icons.verified, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobListingsTab(),
          _buildTrustedResourcesTab(),
        ],
      ),
    );
  }

  Widget _buildJobListingsTab() {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, child) {
        return Column(
          children: [
            // Filters Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          'Category',
                          _selectedCategory,
                          ['All', 'Technology', 'Finance', 'Healthcare', 'Design', 'Marketing', 'Consulting', 'Engineering', 'Product', 'Data Science', 'Aviation'],
                          (value) {
                            setState(() => _selectedCategory = value!);
                            _loadJobs();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown(
                          'Country',
                          _selectedCountry,
                          ['All', 'USA', 'UK', 'Canada', 'Australia', 'Germany', 'UAE', 'Ireland'],
                          (value) {
                            setState(() => _selectedCountry = value!);
                            _loadJobs();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _remoteOnly,
                        onChanged: (value) {
                          setState(() => _remoteOnly = value!);
                          _loadJobs();
                        },
                        activeColor: AppColors.primary,
                      ),
                      const Text('Remote Only'),
                      const Spacer(),
                      Text(
                        '${jobProvider.total} jobs found',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Jobs List
            Expanded(
              child: _buildJobsList(jobProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJobsList(JobProvider jobProvider) {
    if (jobProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobProvider.status == JobStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              jobProvider.errorMessage ?? 'Failed to load jobs',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadJobs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (jobProvider.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No jobs match your filters',
              style: AppTypography.bodyLarge.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'All';
                  _selectedCountry = 'All';
                  _remoteOnly = false;
                });
                context.read<JobProvider>().clearFilters();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => jobProvider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobProvider.jobs.length,
        itemBuilder: (context, index) {
          final job = jobProvider.jobs[index];
          return _buildJobCard(job);
        },
      ),
    );
  }

  Widget _buildJobCard(Job job) {
    final categoryColor = _getCategoryColor(job.category);
    
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
          onTap: () => _showJobDetails(job),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sponsored & Remote tags
                if (job.isSponsored || job.remote)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        if (job.isSponsored)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 12, color: Colors.amber[700]),
                                const SizedBox(width: 4),
                                Text(
                                  'Sponsored',
                                  style: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (job.isSponsored && job.remote) const SizedBox(width: 8),
                        if (job.remote)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.home_work, size: 12, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Logo / Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: job.employer.verified
                          ? Stack(
                              children: [
                                Center(
                                  child: Text(
                                    job.employer.name.substring(0, 1).toUpperCase(),
                                    style: TextStyle(
                                      color: categoryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: Icon(
                                    Icons.verified,
                                    size: 14,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Text(
                                job.employer.name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: categoryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: AppTypography.h5,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                job.employer.name,
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                              if (job.employer.verified)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(Icons.verified, size: 14, color: Colors.blue[600]),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Location & Posted
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${job.location}, ${job.country}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      job.postedAgo,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Salary & Applicants
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        job.salaryDisplay,
                        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.people_outline, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${job.applicants} applicants',
                      style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology': return Colors.blue;
      case 'finance': return Colors.green;
      case 'healthcare': return Colors.red;
      case 'design': return Colors.purple;
      case 'marketing': return Colors.orange;
      case 'consulting': return Colors.teal;
      case 'engineering': return Colors.indigo;
      case 'product': return Colors.pink;
      case 'data science': return Colors.cyan;
      case 'aviation': return Colors.amber;
      default: return AppColors.primary;
    }
  }

  void _showJobDetails(Job job) {
    final categoryColor = _getCategoryColor(job.category);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              job.employer.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.title, style: AppTypography.h4),
                              Row(
                                children: [
                                  Text(
                                    job.employer.name,
                                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                                  ),
                                  if (job.employer.verified)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Icon(Icons.verified, size: 16, color: Colors.blue[600]),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Employer Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildEmployerRow(Icons.business, 'Industry', job.employer.industry),
                          _buildEmployerRow(Icons.people, 'Company Size', job.employer.companySize),
                          _buildEmployerRow(Icons.location_city, 'HQ Location', job.employer.location),
                          if (job.employer.rating != null)
                            _buildEmployerRow(
                              Icons.star,
                              'Rating',
                              '${job.employer.rating}/5 (${job.employer.reviewCount} reviews)',
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Job Details
                    _buildDetailRow(Icons.location_on, '${job.location}, ${job.country}'),
                    _buildDetailRow(Icons.work, job.jobType.toUpperCase()),
                    _buildDetailRow(Icons.attach_money, job.salaryDisplay),
                    _buildDetailRow(Icons.category, job.category),
                    _buildDetailRow(Icons.trending_up, '${job.experienceLevel.toUpperCase()} Level'),
                    const SizedBox(height: 24),
                    
                    // Description
                    Text('Description', style: AppTypography.h5),
                    const SizedBox(height: 8),
                    Text(job.description, style: AppTypography.bodyMedium),
                    const SizedBox(height: 24),
                    
                    // Requirements
                    Text('Requirements', style: AppTypography.h5),
                    const SizedBox(height: 8),
                    ...job.requirements.map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(req, style: AppTypography.bodyMedium)),
                        ],
                      ),
                    ),),
                    const SizedBox(height: 24),
                    
                    // Benefits
                    Text('Benefits', style: AppTypography.h5),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.benefits.map((benefit) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          benefit,
                          style: const TextStyle(color: Colors.green, fontSize: 13),
                        ),
                      ),).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(job.applyUrl),
                        icon: const Icon(Icons.open_in_new),
                        label: Text('Apply on ${job.source.toUpperCase()}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployerRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          Expanded(child: Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildTrustedResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.verified_user, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trusted Job Resources',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Verified platforms to find legitimate job opportunities worldwide',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Trusted Resources Grid
          Text('Global Job Portals', style: AppTypography.h5),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: _trustedResources.length,
            itemBuilder: (context, index) {
              final resource = _trustedResources[index];
              return _buildResourceCard(resource);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Tips Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Job Search Tips',
                      style: AppTypography.labelLarge.copyWith(color: Colors.amber[800]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTip('✓ Always verify employer legitimacy before applying'),
                _buildTip('✓ Never pay for job applications'),
                _buildTip('✓ Use official career pages of companies'),
                _buildTip('✓ Check employer reviews on Glassdoor'),
                _buildTip('✓ Be wary of unrealistic salary offers'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildResourceCard(Map<String, dynamic> resource) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
          onTap: () => _launchUrl(resource['url'] as String),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (resource['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        resource['icon'] as IconData,
                        color: resource['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  resource['name'] as String,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  resource['description'] as String,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(color: Colors.amber[900]),
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ),).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

