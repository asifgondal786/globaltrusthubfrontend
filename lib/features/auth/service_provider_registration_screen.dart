import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ServiceProviderRegistrationScreen extends StatefulWidget {
  const ServiceProviderRegistrationScreen({super.key});

  @override
  State<ServiceProviderRegistrationScreen> createState() => _ServiceProviderRegistrationScreenState();
}

class _ServiceProviderRegistrationScreenState extends State<ServiceProviderRegistrationScreen> {
  int _currentStep = 0;
  final _formKeys = List.generate(5, (_) => GlobalKey<FormState>());
  final ImagePicker _picker = ImagePicker();

  // Step 1: Basic Info
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedTitle = 'Mr.';
  DateTime? _dateOfBirth;

  // Step 2: Business Info
  final _businessNameController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  String? _licenseImagePath;
  String _selectedServiceType = 'Education Agent';

  // Step 3: Address
  final _shopAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  String? _mapLocation;

  // Step 4: Identity Documents
  final _cnicController = TextEditingController();
  String? _cnicFrontPath;
  String? _cnicBackPath;
  String? _passportPath;
  String? _drivingLicensePath;

  // Step 5: Certificates
  final List<Map<String, String>> _certificates = [];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _licenseNumberController.dispose();
    _shopAddressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(Function(String) onPicked) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onPicked(image.path);
      setState(() {});
    }
  }

  void _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      helpText: 'Must be 18+ years old',
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _addCertificate() {
    final nameController = TextEditingController();
    final issuedByController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Certificate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Certificate Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: issuedByController,
              decoration: const InputDecoration(labelText: 'Issued By'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _certificates.add({
                    'name': nameController.text,
                    'issuedBy': issuedByController.text,
                    'date': DateTime.now().toString().split(' ')[0],
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green),
            ),
            const SizedBox(width: 12),
            const Text('Registration Submitted'),
          ],
        ),
        content: const Text(
          'Your service provider registration has been submitted successfully!\n\n'
          'Our team will verify your documents and license within 2-3 business days.\n\n'
          'You will receive an email notification once approved.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Service Provider Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: List.generate(5, (index) {
                final isActive = index <= _currentStep;
                final isComplete = index < _currentStep;
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isComplete
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      if (index < 4)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isComplete ? AppColors.primary : Colors.grey.shade300,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          // Step Labels
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepLabel('Personal', 0),
                _buildStepLabel('Business', 1),
                _buildStepLabel('Address', 2),
                _buildStepLabel('Documents', 3),
                _buildStepLabel('Certificates', 4),
              ],
            ),
          ),
          
          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStep(),
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep--),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < 4) {
                        setState(() => _currentStep++);
                      } else {
                        _submitForm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentStep < 4 ? 'Continue' : 'Submit Registration'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String label, int step) {
    final isActive = step == _currentStep;
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? AppColors.primary : Colors.grey,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildBusinessInfoStep();
      case 2:
        return _buildAddressStep();
      case 3:
        return _buildDocumentsStep();
      case 4:
        return _buildCertificatesStep();
      default:
        return Container();
    }
  }

  // Step 1: Personal Information
  Widget _buildPersonalInfoStep() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Information', style: AppTypography.h5),
          const SizedBox(height: 8),
          Text('Enter your personal details', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // Title
          DropdownButtonFormField<String>(
            initialValue: _selectedTitle,
            decoration: _inputDecoration('Title'),
            items: ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Prof.']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTitle = v!),
          ),
          const SizedBox(height: 16),

          // First Name
          TextFormField(
            controller: _firstNameController,
            decoration: _inputDecoration('First Name', Icons.person),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          // Last Name
          TextFormField(
            controller: _lastNameController,
            decoration: _inputDecoration('Last Name', Icons.person),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Email Address', Icons.email),
            validator: (v) => v!.contains('@') ? null : 'Enter valid email',
          ),
          const SizedBox(height: 16),

          // Phone
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('Phone Number', Icons.phone),
          ),
          const SizedBox(height: 16),

          // Date of Birth
          InkWell(
            onTap: _selectDateOfBirth,
            child: InputDecorator(
              decoration: _inputDecoration('Date of Birth (18+)', Icons.calendar_today),
              child: Text(
                _dateOfBirth != null
                    ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                    : 'Select Date',
                style: TextStyle(color: _dateOfBirth != null ? Colors.black : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Business Information
  Widget _buildBusinessInfoStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Business Information', style: AppTypography.h5),
          const SizedBox(height: 8),
          Text('Enter your business and license details', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // Business Name
          TextFormField(
            controller: _businessNameController,
            decoration: _inputDecoration('Business/Company Name', Icons.business),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          // Service Type
          DropdownButtonFormField<String>(
            initialValue: _selectedServiceType,
            decoration: _inputDecoration('Service Type'),
            items: [
              'Education Agent',
              'Visa Consultant',
              'Immigration Lawyer',
              'Housing Agent',
              'Job Recruiter',
              'Financial Advisor',
              'Travel Agent',
            ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _selectedServiceType = v!),
          ),
          const SizedBox(height: 16),

          // License Number
          TextFormField(
            controller: _licenseNumberController,
            decoration: _inputDecoration('Business License Number', Icons.badge),
            validator: (v) => v!.isEmpty ? 'License number is required' : null,
          ),
          const SizedBox(height: 16),

          // License Image Upload
          Text('Business License Image *', style: AppTypography.labelLarge),
          const SizedBox(height: 8),
          _buildImageUploader(
            _licenseImagePath,
            'Upload License Image',
            Icons.upload_file,
            () => _pickImage((path) => _licenseImagePath = path),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload a clear photo of your valid business license',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // Step 3: Address
  Widget _buildAddressStep() {
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Business Address', style: AppTypography.h5),
          const SizedBox(height: 8),
          Text('Enter your shop/office location', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // Shop Address
          TextFormField(
            controller: _shopAddressController,
            maxLines: 3,
            decoration: _inputDecoration('Shop/Office Address', Icons.location_on),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),

          // City
          TextFormField(
            controller: _cityController,
            decoration: _inputDecoration('City', Icons.location_city),
          ),
          const SizedBox(height: 16),

          // Country
          TextFormField(
            controller: _countryController,
            decoration: _inputDecoration('Country', Icons.flag),
          ),
          const SizedBox(height: 16),

          // Google Maps Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.map, color: Colors.blue, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pin Location on Map', style: AppTypography.labelLarge),
                      Text(
                        _mapLocation ?? 'Click to select your shop location',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _mapLocation = 'Location Selected ✓');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Map location saved!')),
                    );
                  },
                  icon: const Icon(Icons.add_location),
                  label: const Text('Select'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 4: Identity Documents
  Widget _buildDocumentsStep() {
    return Form(
      key: _formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Identity Documents', style: AppTypography.h5),
          const SizedBox(height: 8),
          Text('Upload required identity documents', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // CNIC Number
          TextFormField(
            controller: _cnicController,
            decoration: _inputDecoration('CNIC Number', Icons.credit_card),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'CNIC is required' : null,
          ),
          const SizedBox(height: 16),

          // CNIC Front
          Text('CNIC Front Image *', style: AppTypography.labelLarge),
          const SizedBox(height: 8),
          _buildImageUploader(
            _cnicFrontPath,
            'Upload CNIC Front',
            Icons.credit_card,
            () => _pickImage((path) => _cnicFrontPath = path),
          ),
          const SizedBox(height: 16),

          // CNIC Back
          Text('CNIC Back Image *', style: AppTypography.labelLarge),
          const SizedBox(height: 8),
          _buildImageUploader(
            _cnicBackPath,
            'Upload CNIC Back',
            Icons.credit_card,
            () => _pickImage((path) => _cnicBackPath = path),
          ),
          const SizedBox(height: 24),

          const Divider(),
          const SizedBox(height: 16),

          Text('Optional Documents', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),

          // Passport (Optional)
          Text('Passport (Optional)', style: AppTypography.labelMedium),
          const SizedBox(height: 8),
          _buildImageUploader(
            _passportPath,
            'Upload Passport',
            Icons.flight,
            () => _pickImage((path) => _passportPath = path),
            isOptional: true,
          ),
          const SizedBox(height: 16),

          // Driving License (Optional)
          Text('Driving License (Optional)', style: AppTypography.labelMedium),
          const SizedBox(height: 8),
          _buildImageUploader(
            _drivingLicensePath,
            'Upload Driving License',
            Icons.directions_car,
            () => _pickImage((path) => _drivingLicensePath = path),
            isOptional: true,
          ),
        ],
      ),
    );
  }

  // Step 5: Certificates
  Widget _buildCertificatesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Certificates & Credentials', style: AppTypography.h5),
        const SizedBox(height: 8),
        Text('Add your professional certifications and commendations', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 24),

        // Add Certificate Button
        OutlinedButton.icon(
          onPressed: _addCertificate,
          icon: const Icon(Icons.add),
          label: const Text('Add Certificate'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),

        // Certificates List
        if (_certificates.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.workspace_premium, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No certificates added yet',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add your certifications to build trust',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          )
        else
          ...List.generate(_certificates.length, (index) {
            final cert = _certificates[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.workspace_premium, color: Colors.amber),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cert['name']!, style: AppTypography.labelLarge),
                        Text('Issued by: ${cert['issuedBy']}', style: AppTypography.caption),
                        Text('Date: ${cert['date']}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _certificates.removeAt(index)),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 24),

        // Info Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Certificates help build trust with clients and improve your Trust Score. All documents will be verified by our team.',
                  style: AppTypography.caption.copyWith(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  InputDecoration _inputDecoration(String label, [IconData? icon]) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildImageUploader(String? path, String label, IconData icon, VoidCallback onTap, {bool isOptional = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: path != null ? Colors.green.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: path != null ? Colors.green : Colors.grey.shade300,
            style: path != null ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              path != null ? Icons.check_circle : icon,
              color: path != null ? Colors.green : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              path != null ? 'Image Uploaded ✓' : label,
              style: TextStyle(
                color: path != null ? Colors.green : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
