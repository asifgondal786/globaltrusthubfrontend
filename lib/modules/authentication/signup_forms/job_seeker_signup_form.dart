import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';
import 'package:global_trust_hub/shared_widgets/custom_input.dart';
import 'package:global_trust_hub/shared_widgets/google_map_location_picker.dart';
import 'package:global_trust_hub/shared_widgets/id_card_upload_widget.dart';

/// Job Seeker Registration Form
/// Same fields as Student: Title, First/Last Name, Mobile, Email verification, ID Card, Address with Map
class JobSeekerSignupForm extends StatefulWidget {
  const JobSeekerSignupForm({super.key});

  @override
  State<JobSeekerSignupForm> createState() => _JobSeekerSignupFormState();
}

class _JobSeekerSignupFormState extends State<JobSeekerSignupForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Personal Info Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Password Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Dropdowns
  String? _selectedTitle;
  String? _selectedExperienceLevel;
  String? _selectedIndustry;
  
  // Verification States
  bool _emailVerified = false;
  bool _isVerifyingEmail = false;
  String _verificationCode = '';
  final _verificationCodeController = TextEditingController();
  bool _showVerificationInput = false;
  
  // Data
  IdCardData? _idCardData;
  LocationData? _locationData;
  
  bool _isLoading = false;

  final List<String> _titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.', 'Prof.'];
  
  final List<String> _experienceLevels = [
    'Entry Level (0-2 years)',
    'Mid Level (3-5 years)',
    'Senior Level (5-10 years)',
    'Expert Level (10+ years)',
  ];

  final List<String> _industries = [
    'Information Technology',
    'Healthcare',
    'Finance & Banking',
    'Education',
    'Engineering',
    'Sales & Marketing',
    'Manufacturing',
    'Hospitality',
    'Other',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isVerifyingEmail = true);
    await Future.delayed(const Duration(seconds: 2));
    _verificationCode = '123456';
    
    setState(() {
      _isVerifyingEmail = false;
      _showVerificationInput = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code sent to ${_emailController.text}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _verifyCode() {
    if (_verificationCodeController.text == _verificationCode) {
      setState(() {
        _emailVerified = true;
        _showVerificationInput = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid verification code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.red),
      );
      return;
    }

    if (!_emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your email address'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_idCardData == null || !_idCardData!.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both sides of your ID card'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_locationData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your location on the map'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted for verification'), backgroundColor: Colors.green),
      );
      context.go('/verification-status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Job Seeker Registration',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.work, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'FREE',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.indigo.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.work_outline, color: Colors.blue, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Your Job Seeker Profile',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get verified to access job opportunities',
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Personal Information
              _buildSectionHeader('Personal Information', Icons.person_outline),
              const SizedBox(height: 16),
              
              _buildDropdown(
                label: 'Title',
                value: _selectedTitle,
                items: _titles,
                hint: 'Select title',
                onChanged: (value) => setState(() => _selectedTitle = value),
                isRequired: false,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomInput(
                      controller: _firstNameController,
                      label: 'First Name',
                      hint: 'John',
                      prefixIcon: Icons.person_outline,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomInput(
                      controller: _lastNameController,
                      label: 'Last Name',
                      hint: 'Doe',
                      prefixIcon: Icons.person_outline,
                      isRequired: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              CustomInput(
                controller: _mobileController,
                label: 'Mobile Number',
                hint: '+92 300 1234567',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                isRequired: true,
              ),
              const SizedBox(height: 24),

              // Password Section
              _buildSectionHeader('Create Password', Icons.lock_outline),
              const SizedBox(height: 16),
              
              CustomInput(
                controller: _passwordController,
                label: 'Create Password',
                hint: 'Enter a strong password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                isRequired: true,
                suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomInput(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                isRequired: true,
                suffixIcon: _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                onSuffixTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Email Verification
              _buildSectionHeader('Email Verification', Icons.email_outlined),
              const SizedBox(height: 16),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomInput(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'your.email@example.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_emailVerified,
                      isRequired: true,
                      suffixIcon: _emailVerified ? Icons.verified : null,
                      suffixIconColor: _emailVerified ? AppColors.success : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _emailVerified || _isVerifyingEmail ? null : _sendVerificationCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _emailVerified ? AppColors.success : Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isVerifyingEmail
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(_emailVerified ? 'Verified' : 'Send Code', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
              
              if (_showVerificationInput) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        controller: _verificationCodeController,
                        label: 'Verification Code',
                        hint: 'Enter 6-digit code',
                        prefixIcon: Icons.lock_outline,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Verify'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // ID Card Upload
              _buildSectionHeader('Identity Verification', Icons.badge_outlined),
              const SizedBox(height: 16),
              IdCardUploadWidget(
                onCardUploaded: (data) => setState(() => _idCardData = data),
                initialData: _idCardData,
              ),
              const SizedBox(height: 24),

              // Location
              _buildSectionHeader('Location Verification', Icons.location_on_outlined),
              const SizedBox(height: 16),
              GoogleMapLocationPicker(
                onLocationSelected: (location) => setState(() => _locationData = location),
                initialLocation: _locationData,
                label: 'Your Current Address',
              ),
              const SizedBox(height: 24),

              // Professional Details
              _buildSectionHeader('Professional Details', Icons.work_history_outlined),
              const SizedBox(height: 16),
              
              _buildDropdown(
                label: 'Experience Level',
                value: _selectedExperienceLevel,
                items: _experienceLevels,
                hint: 'Select experience level',
                onChanged: (value) => setState(() => _selectedExperienceLevel = value),
                isRequired: true,
              ),
              const SizedBox(height: 16),
              
              _buildDropdown(
                label: 'Industry',
                value: _selectedIndustry,
                items: _industries,
                hint: 'Select your industry',
                onChanged: (value) => setState(() => _selectedIndustry = value),
                isRequired: true,
              ),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: 'Submit for Verification',
                isLoading: _isLoading,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Verification typically takes 24-48 hours. You will receive updates via email.',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
            if (isRequired) Text(' *', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint),
              isExpanded: true,
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
