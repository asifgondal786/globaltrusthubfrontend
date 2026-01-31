import 'dart:io';
import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRegistrationScreen extends StatefulWidget {
  const ProfileRegistrationScreen({super.key});

  @override
  State<ProfileRegistrationScreen> createState() => _ProfileRegistrationScreenState();
}

class _ProfileRegistrationScreenState extends State<ProfileRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _addressController = TextEditingController();
  
  String _selectedTitle = 'Mr.';
  String _registerAs = 'Student';
  String _selectedService = 'Education Consultant';
  DateTime? _dateOfBirth;
  XFile? _cnicFront;
  XFile? _cnicBack;
  
  final List<String> _titles = ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Prof.'];
  final List<String> _registerOptions = ['Student', 'Employee'];
  final List<String> _services = [
    'Education Consultant',
    'Immigration Agent',
    'Job Recruiter',
    'Financial Advisor',
    'Housing Agent',
    'Visa Consultant',
  ];

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Complete Registration'),
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
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(_currentStep == 3 ? 'Submit' : 'Continue'),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Personal Information
            Step(
              title: const Text('Personal Information'),
              subtitle: const Text('Basic details'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  // Title Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedTitle,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _titles.map((title) => DropdownMenuItem(
                      value: title,
                      child: Text(title),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedTitle = value!),
                  ),
                  const SizedBox(height: 16),
                  
                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Enter your first name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => value?.isEmpty == true ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Second Name
                  TextFormField(
                    controller: _secondNameController,
                    decoration: InputDecoration(
                      labelText: 'Second Name / Last Name',
                      hintText: 'Enter your last name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Father's Name
                  TextFormField(
                    controller: _fatherNameController,
                    decoration: InputDecoration(
                      labelText: 'Father\'s Name',
                      hintText: 'Enter your father\'s name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Father\'s name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Date of Birth
                  InkWell(
                    onTap: _pickDateOfBirth,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _dateOfBirth != null
                            ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                            : 'Select your date of birth',
                        style: TextStyle(
                          color: _dateOfBirth != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (_dateOfBirth != null && !_isOver18())
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'You must be at least 18 years old to register.',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            
            // Step 2: Identity Verification (CNIC)
            Step(
              title: const Text('Identity Verification'),
              subtitle: const Text('CNIC Upload'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload CNIC Images', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Please upload clear images of your CNIC (front and back)',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  
                  // CNIC Front
                  _buildImageUploader(
                    'CNIC Front Side',
                    _cnicFront,
                    () => _pickImage(true),
                  ),
                  const SizedBox(height: 16),
                  
                  // CNIC Back
                  _buildImageUploader(
                    'CNIC Back Side',
                    _cnicBack,
                    () => _pickImage(false),
                  ),
                ],
              ),
            ),
            
            // Step 3: Address & Registration Type
            Step(
              title: const Text('Address & Type'),
              subtitle: const Text('Location and role'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  // Address
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Full Address',
                      hintText: 'Enter your complete address',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: _openMapPicker,
                      ),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Address is required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _openMapPicker,
                    icon: const Icon(Icons.map),
                    label: const Text('Pick from Google Maps'),
                  ),
                  const SizedBox(height: 16),
                  
                  // Register As
                  DropdownButtonFormField<String>(
                    value: _registerAs,
                    decoration: InputDecoration(
                      labelText: 'Register As',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _registerOptions.map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    )).toList(),
                    onChanged: (value) => setState(() => _registerAs = value!),
                  ),
                ],
              ),
            ),
            
            // Step 4: Service Provider Selection
            Step(
              title: const Text('Service Connection'),
              subtitle: const Text('Connect to providers'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select a Service Provider Type', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the type of service you need help with',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  
                  // Service Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedService,
                    decoration: InputDecoration(
                      labelText: 'Service Type',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _services.map((service) => DropdownMenuItem(
                      value: service,
                      child: Text(service),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedService = value!),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick Chat Option
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Chat with Providers', style: AppTypography.labelLarge),
                              Text(
                                'After registration, you can chat directly with service providers',
                                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader(String label, XFile? image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: image != null ? Colors.green : Colors.grey.shade300,
            width: 2,
            style: image != null ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: image != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 32, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
                  Text('Tap to upload', style: AppTypography.caption.copyWith(color: Colors.grey)),
                ],
              ),
      ),
    );
  }

  void _onStepContinue() {
    // Validate current step
    if (_currentStep == 0) {
      if (!_validatePersonalInfo()) return;
    } else if (_currentStep == 1) {
      if (!_validateCnic()) return;
    } else if (_currentStep == 2) {
      if (!_validateAddress()) return;
    } else if (_currentStep == 3) {
      _submitForm();
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  bool _validatePersonalInfo() {
    if (_firstNameController.text.isEmpty ||
        _secondNameController.text.isEmpty ||
        _fatherNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
      return false;
    }
    
    if (!_isOver18()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be at least 18 years old to register'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }

  bool _validateCnic() {
    if (_cnicFront == null || _cnicBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both CNIC images')),
      );
      return false;
    }
    return true;
  }

  bool _validateAddress() {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your address')),
      );
      return false;
    }
    return true;
  }

  bool _isOver18() {
    if (_dateOfBirth == null) return false;
    final now = DateTime.now();
    final age = now.year - _dateOfBirth!.year;
    if (now.month < _dateOfBirth!.month ||
        (now.month == _dateOfBirth!.month && now.day < _dateOfBirth!.day)) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          if (isFront) {
            _cnicFront = image;
          } else {
            _cnicBack = image;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _openMapPicker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Maps integration coming soon!')),
    );
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            const Text('Registration Complete!'),
          ],
        ),
        content: const Text(
          'Your profile has been submitted for verification. You will receive a notification once your account is verified.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }
}
