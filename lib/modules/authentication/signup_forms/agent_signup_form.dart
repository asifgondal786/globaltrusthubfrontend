import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';
import 'package:global_trust_hub/shared_widgets/custom_input.dart';
import 'package:global_trust_hub/shared_widgets/google_map_location_picker.dart';
import 'package:global_trust_hub/shared_widgets/id_card_upload_widget.dart';

/// Agent Registration Form
/// Basic fields + License Title and License Number
class AgentSignupForm extends StatefulWidget {
  const AgentSignupForm({super.key});

  @override
  State<AgentSignupForm> createState() => _AgentSignupFormState();
}

class _AgentSignupFormState extends State<AgentSignupForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Personal Info Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  
  // License Info Controllers (Agent-specific)
  final _licenseTitleController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _businessNameController = TextEditingController();
  
  // Password Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Dropdowns
  String? _selectedTitle;
  final List<String> _selectedServices = [];
  
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
  
  final List<String> _availableServices = [
    'Visa Consultation',
    'IELTS/PTE Preparation',
    'University Admissions',
    'Travel Arrangements',
    'Document Processing',
    'Study Abroad Counseling',
    'Job Placement',
    'Immigration Services',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _licenseTitleController.dispose();
    _licenseNumberController.dispose();
    _businessNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address'), backgroundColor: Colors.red),
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
        SnackBar(content: Text('Verification code sent to ${_emailController.text}'), backgroundColor: AppColors.success),
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
        const SnackBar(content: Text('Email verified successfully!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification code'), backgroundColor: Colors.red),
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

    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agent registration submitted for review'), backgroundColor: Colors.green),
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
          'Agent Registration',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 16, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  '\$10/month',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
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
              // Header with premium badge
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.15),
                      Colors.amber.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: AppColors.secondary.withValues(alpha: 0.2), blurRadius: 8, spreadRadius: 1),
                        ],
                      ),
                      child: const Icon(Icons.support_agent, color: AppColors.secondary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Become a Verified Agent',
                                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, size: 20, color: AppColors.secondary),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get public trust score and verified badge',
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

              // Business Information
              _buildSectionHeader('Business Information', Icons.business_outlined),
              const SizedBox(height: 16),
              
              CustomInput(
                controller: _businessNameController,
                label: 'Business/Agency Name',
                hint: 'Your registered business name',
                prefixIcon: Icons.business,
                isRequired: true,
              ),
              const SizedBox(height: 24),

              // License Information (Agent-specific)
              _buildSectionHeader('License Information', Icons.verified_user_outlined),
              const SizedBox(height: 16),
              
              CustomInput(
                controller: _licenseTitleController,
                label: 'License Title',
                hint: 'e.g., Immigration Consultant, Education Agent',
                prefixIcon: Icons.badge_outlined,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              
              CustomInput(
                controller: _licenseNumberController,
                label: 'License Number',
                hint: 'Government-issued license number',
                prefixIcon: Icons.confirmation_number_outlined,
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
                      label: 'Business Email',
                      hint: 'contact@youragency.com',
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
                          backgroundColor: _emailVerified ? AppColors.success : AppColors.secondary,
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
                            backgroundColor: AppColors.primary,
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

              // Location with Google Maps
              _buildSectionHeader('Office Location Verification', Icons.location_on_outlined),
              const SizedBox(height: 16),
              GoogleMapLocationPicker(
                onLocationSelected: (location) => setState(() => _locationData = location),
                initialLocation: _locationData,
                label: 'Office Address',
              ),
              const SizedBox(height: 24),

              // Services Offered
              _buildSectionHeader('Services Offered', Icons.handshake_outlined),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableServices.map((service) {
                  final isSelected = _selectedServices.contains(service);
                  return FilterChip(
                    label: Text(service),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedServices.add(service);
                        } else {
                          _selectedServices.remove(service);
                        }
                      });
                    },
                    selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.secondary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.secondary : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: 'Submit for Verification',
                isLoading: _isLoading,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16),
              
              // Warning note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_outlined, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your trust score will be publicly visible. Misconduct leads to automatic demotion.',
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
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.secondary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
