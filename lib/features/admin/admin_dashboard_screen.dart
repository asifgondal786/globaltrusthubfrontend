import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data stores
  final List<Map<String, dynamic>> _universities = [
    {'id': '1', 'name': 'Harvard University', 'country': 'USA', 'ranking': 1, 'status': 'Verified', 'programs': 50},
    {'id': '2', 'name': 'University of Oxford', 'country': 'UK', 'ranking': 2, 'status': 'Verified', 'programs': 45},
    {'id': '3', 'name': 'University of Toronto', 'country': 'Canada', 'ranking': 18, 'status': 'Pending', 'programs': 38},
  ];

  final List<Map<String, dynamic>> _serviceProviders = [
    {'id': '1', 'name': 'Ali Travel Consultants', 'type': 'Education Agent', 'trustScore': 850, 'status': 'Verified', 'clients': 150},
    {'id': '2', 'name': 'Global Visa Services', 'type': 'Visa Consultant', 'trustScore': 780, 'status': 'Verified', 'clients': 230},
    {'id': '3', 'name': 'StudentStay Housing', 'type': 'Housing Agent', 'trustScore': 720, 'status': 'Pending', 'clients': 89},
  ];

  final List<Map<String, dynamic>> _jobs = [
    {'id': '1', 'title': 'Software Engineer', 'company': 'Tech Corp', 'location': 'USA', 'status': 'Active', 'applications': 45},
    {'id': '2', 'title': 'Marketing Manager', 'company': 'Global Brands', 'location': 'UK', 'status': 'Active', 'applications': 23},
  ];

  final List<Map<String, dynamic>> _users = [
    {'id': '1', 'name': 'Ahmed Khan', 'email': 'ahmed@example.com', 'role': 'Student', 'status': 'Active', 'joined': '2024-01-15'},
    {'id': '2', 'name': 'Sarah Ali', 'email': 'sarah@example.com', 'role': 'Service Provider', 'status': 'Active', 'joined': '2024-02-20'},
    {'id': '3', 'name': 'Muhammad Usman', 'email': 'usman@example.com', 'role': 'Student', 'status': 'Suspended', 'joined': '2024-03-10'},
    {'id': '4', 'name': 'Fatima Zahra', 'email': 'fatima@example.com', 'role': 'Service Provider', 'status': 'Pending', 'joined': '2024-03-25'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Admin Dashboard'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/login');
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.school), text: 'Universities'),
            Tab(icon: Icon(Icons.business), text: 'Providers'),
            Tab(icon: Icon(Icons.work), text: 'Jobs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUsersTab(),
          _buildUniversitiesTab(),
          _buildProvidersTab(),
          _buildJobsTab(),
        ],
      ),
    );
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Total Users', '${_users.length}', Icons.people, Colors.purple, '+45 this week'),
              _buildStatCard('Universities', '${_universities.length}', Icons.school, Colors.blue, '+2 this week'),
              _buildStatCard('Providers', '${_serviceProviders.length}', Icons.business, Colors.green, '+5 this week'),
              _buildStatCard('Active Jobs', '${_jobs.length}', Icons.work, Colors.orange, '+12 this week'),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Activity
          Text('Recent Activity', style: AppTypography.h5),
          const SizedBox(height: 12),
          _buildActivityItem('New user registered: Fatima Z.', '1 hour ago', Icons.person_add, Colors.purple),
          _buildActivityItem('University verified: MIT', '2 hours ago', Icons.verified, Colors.blue),
          _buildActivityItem('Provider approved: Career Plus', '4 hours ago', Icons.check_circle, Colors.green),
          _buildActivityItem('Job posted: Data Scientist', '6 hours ago', Icons.work, Colors.orange),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          Text('Quick Actions', style: AppTypography.h5),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildQuickActionButton('Add User', Icons.person_add, Colors.purple, () => _showAddUserDialog())),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickActionButton('Add University', Icons.school, Colors.blue, () => _showAddUniversityDialog())),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildQuickActionButton('Add Provider', Icons.business, Colors.green, () => _showAddProviderDialog())),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickActionButton('Post Job', Icons.work, Colors.orange, () => _showAddJobDialog())),
            ],
          ),
        ],
      ),
    );
  }

  // Users Tab
  Widget _buildUsersTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        // User Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildUserStatChip('Total: ${_users.length}', Colors.grey),
              const SizedBox(width: 8),
              _buildUserStatChip('Active: ${_users.where((u) => u['status'] == 'Active').length}', Colors.green),
              const SizedBox(width: 8),
              _buildUserStatChip('Pending: ${_users.where((u) => u['status'] == 'Pending').length}', Colors.orange),
              const SizedBox(width: 8),
              _buildUserStatChip('Suspended: ${_users.where((u) => u['status'] == 'Suspended').length}', Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return _buildUserCard(user, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserStatChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int index) {
    Color statusColor = user['status'] == 'Active' ? Colors.green 
        : user['status'] == 'Pending' ? Colors.orange : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple.withOpacity(0.1),
            child: Text(user['name'][0], style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'], style: AppTypography.labelLarge),
                Text(user['email'], style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(user['role'], style: const TextStyle(fontSize: 10, color: Colors.blue)),
                    ),
                    const SizedBox(width: 8),
                    Text('Joined: ${user['joined']}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(user['status'], style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500)),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')])),
              const PopupMenuItem(value: 'activate', child: Row(children: [Icon(Icons.check_circle, size: 18, color: Colors.green), SizedBox(width: 8), Text('Activate')])),
              const PopupMenuItem(value: 'suspend', child: Row(children: [Icon(Icons.block, size: 18, color: Colors.orange), SizedBox(width: 8), Text('Suspend')])),
              const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete')])),
            ],
            onSelected: (value) => _handleUserAction(value, index),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, int index) {
    if (action == 'delete') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${_users[index]['name']}? This action cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() => _users.removeAt(index));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted successfully'), backgroundColor: Colors.red));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    } else if (action == 'activate') {
      setState(() => _users[index]['status'] = 'Active');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User activated'), backgroundColor: Colors.green));
    } else if (action == 'suspend') {
      setState(() => _users[index]['status'] = 'Suspended');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User suspended'), backgroundColor: Colors.orange));
    }
  }

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'Student';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 12),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: ['Student', 'Service Provider', 'Admin']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => selectedRole = v!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                setState(() {
                  _users.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text,
                    'email': emailController.text,
                    'role': selectedRole,
                    'status': 'Active',
                    'joined': DateTime.now().toString().split(' ')[0],
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User added successfully!'), backgroundColor: Colors.green));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  // Universities Tab
  Widget _buildUniversitiesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search universities...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddUniversityDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _universities.length,
            itemBuilder: (context, index) {
              final uni = _universities[index];
              return _buildUniversityCard(uni, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUniversityCard(Map<String, dynamic> uni, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text('#${uni['ranking']}', style: AppTypography.labelLarge.copyWith(color: AppColors.primary))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(uni['name'], style: AppTypography.labelLarge),
                Text('${uni['country']} • ${uni['programs']} Programs', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: uni['status'] == 'Verified' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(uni['status'], style: AppTypography.caption.copyWith(
              color: uni['status'] == 'Verified' ? Colors.green : Colors.orange,
            )),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'verify', child: Text('Verify')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete('University', uni['name'], () => setState(() => _universities.removeAt(index)));
              } else if (value == 'verify') {
                setState(() => _universities[index]['status'] = 'Verified');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('University verified')));
              }
            },
          ),
        ],
      ),
    );
  }

  // Providers Tab
  Widget _buildProvidersTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search providers...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddProviderDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _serviceProviders.length,
            itemBuilder: (context, index) {
              final provider = _serviceProviders[index];
              return _buildProviderCard(provider, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.business, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider['name'], style: AppTypography.labelLarge),
                Text('${provider['type']} • ${provider['clients']} Clients', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('Trust Score: ${provider['trustScore']}', style: AppTypography.caption),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: provider['status'] == 'Verified' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(provider['status'], style: AppTypography.caption.copyWith(
              color: provider['status'] == 'Verified' ? Colors.green : Colors.orange,
            )),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'verify', child: Text('Verify')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete('Provider', provider['name'], () => setState(() => _serviceProviders.removeAt(index)));
              } else if (value == 'verify') {
                setState(() => _serviceProviders[index]['status'] = 'Verified');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Provider verified')));
              }
            },
          ),
        ],
      ),
    );
  }

  // Jobs Tab
  Widget _buildJobsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search jobs...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddJobDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _jobs.length,
            itemBuilder: (context, index) {
              final job = _jobs[index];
              return _buildJobCard(job, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.work, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job['title'], style: AppTypography.labelLarge),
                Text('${job['company']} • ${job['location']}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('${job['applications']} Applications', style: AppTypography.caption.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(job['status'], style: AppTypography.caption.copyWith(color: Colors.green)),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'close', child: Text('Close')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete('Job', job['title'], () => setState(() => _jobs.removeAt(index)));
              }
            },
          ),
        ],
      ),
    );
  }

  // Confirm Delete Dialog
  void _confirmDelete(String type, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete $type'),
        content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type deleted'), backgroundColor: Colors.red));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(value, style: AppTypography.h4.copyWith(color: color)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelMedium),
              Text(change, style: AppTypography.caption.copyWith(color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTypography.bodyMedium)),
          Text(time, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(label, style: AppTypography.labelMedium.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  // Dialogs
  void _showAddUniversityDialog() {
    final nameController = TextEditingController();
    final countryController = TextEditingController();
    final rankingController = TextEditingController();
    final programsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add University'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'University Name')),
              const SizedBox(height: 12),
              TextField(controller: countryController, decoration: const InputDecoration(labelText: 'Country')),
              const SizedBox(height: 12),
              TextField(controller: rankingController, decoration: const InputDecoration(labelText: 'World Ranking'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: programsController, decoration: const InputDecoration(labelText: 'Number of Programs'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _universities.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text,
                    'country': countryController.text,
                    'ranking': int.tryParse(rankingController.text) ?? 100,
                    'programs': int.tryParse(programsController.text) ?? 0,
                    'status': 'Pending',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('University added successfully!')));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddProviderDialog() {
    final nameController = TextEditingController();
    String selectedType = 'Education Agent';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Service Provider'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Provider Name')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Education Agent', 'Visa Consultant', 'Housing Agent', 'Job Recruiter', 'Financial Advisor']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => selectedType = v!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _serviceProviders.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text,
                    'type': selectedType,
                    'trustScore': 500,
                    'clients': 0,
                    'status': 'Pending',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Provider added successfully!')));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddJobDialog() {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post New Job'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Job Title')),
              const SizedBox(height: 12),
              TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Company Name')),
              const SizedBox(height: 12),
              TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _jobs.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'title': titleController.text,
                    'company': companyController.text,
                    'location': locationController.text,
                    'applications': 0,
                    'status': 'Active',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted successfully!')));
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
