import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';
import 'package:global_trust_hub/shared_widgets/custom_input.dart';

class InstitutionSignupForm extends StatefulWidget {
  const InstitutionSignupForm({super.key});

  @override
  State<InstitutionSignupForm> createState() => _InstitutionSignupFormState();
}

class _InstitutionSignupFormState extends State<InstitutionSignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _institutionNameController = TextEditingController();
  final _registrationController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Password Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedInstitutionType;
  String? _selectedCountry;
  bool _isLoading = false;

  final List<String> _institutionTypes = [
    'University',
    'College',
    'Bank',
    'Money Transfer Service',
    'Financial Institution',
    'Training Institute',
  ];

  final List<String> _countries = [
    'Pakistan',
    'United Kingdom',
    'United States',
    'Canada',
    'Australia',
    'Germany',
    'Other',
  ];

  @override
  void dispose() {
    _institutionNameController.dispose();
    _registrationController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Institution registration submitted')),
        );
      }
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
          'Institution Registration',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with subscription info
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Register Your Institution',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$10/mo',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Universities, Banks & Financial Institutions',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Institution Details
              _buildSectionHeader('Institution Details'),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Institution Type',
                value: _selectedInstitutionType,
                items: _institutionTypes,
                onChanged: (value) => setState(() => _selectedInstitutionType = value),
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: _institutionNameController,
                label: 'Institution Name',
                hint: 'Official registered name',
                prefixIcon: Icons.account_balance,
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: _registrationController,
                label: 'Registration/License Number',
                hint: 'Government registration number',
                prefixIcon: Icons.verified,
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Country',
                value: _selectedCountry,
                items: _countries,
                onChanged: (value) => setState(() => _selectedCountry = value),
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: _websiteController,
                label: 'Official Website',
                hint: 'https://www.example.com',
                prefixIcon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),

              // Contact Person
              _buildSectionHeader('Primary Contact'),
              const SizedBox(height: 16),

              CustomInput(
                controller: _contactPersonController,
                label: 'Contact Person Name',
                hint: 'Authorized representative',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: _emailController,
                label: 'Official Email',
                hint: 'admissions@university.edu',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: _phoneController,
                label: 'Contact Number',
                hint: '+1 XXX XXX XXXX',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: _addressController,
                label: 'Official Address',
                hint: 'Complete institutional address',
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Password Section
              _buildSectionHeader('Create Password'),
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
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: 'Submit for Verification',
                isLoading: _isLoading,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16),

              // Info Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Verification Process',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Document verification (3-5 business days)\n'
                      '• Website and registration cross-check\n'
                      '• Contact verification call',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
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
              hint: Text('Select $label'),
              isExpanded: true,
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
