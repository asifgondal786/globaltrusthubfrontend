import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:global_trust_hub/state_management/user_provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Payment method details
  final Map<String, dynamic> _jazzCash = {
    'name': 'JazzCash',
    'number': '+923143310064',
    'color': const Color(0xFFE30613),
    'icon': Icons.phone_android,
    'description': 'Send payment via JazzCash mobile wallet',
  };

  final Map<String, dynamic> _easyPaisa = {
    'name': 'EasyPaisa',
    'number': '+923143310064',
    'color': const Color(0xFF00A651),
    'icon': Icons.phone_android,
    'description': 'Send payment via EasyPaisa mobile wallet',
  };

  final Map<String, dynamic> _bankAccount = {
    'bankName': 'UBL (United Bank Limited)',
    'branchName': 'Shaheen Branch',
    'branchAddress': 'PAF Base Sargodha, Pakistan',
    'accountTitle': 'GlobalTrustHub Services',
    'accountNumber': '0123-4567890-001',
    'iban': 'PK36UNIL0109000123456789',
    'swiftCode': 'UNABORKA',
    'color': const Color(0xFF003366),
  };

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$label copied to clipboard'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Check if user is a service provider or agent
        final isProvider = userProvider.isServiceProvider;
        
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text('Payment Methods'),
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
          body: isProvider 
            ? _buildProviderPaymentView()
            : _buildUserInfoView(),
        );
      },
    );
  }

  /// Build the restricted view for regular users
  Widget _buildUserInfoView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Lock Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Payment Information',
            style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            'Payment details are only visible to service providers and agents when making subscription payments.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'For Service Providers',
                      style: AppTypography.labelLarge.copyWith(color: Colors.blue[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'If you are a service provider or agent and need to make a payment for your subscription or listing fee, please log in with your provider account to see payment details.',
                  style: AppTypography.bodySmall.copyWith(color: Colors.blue[900]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Become a Provider CTA
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.1), AppColors.accent.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.business_center, size: 40, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Become a Service Provider',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register as an agent or service provider to offer your services on GlobalTrustHub.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/service-provider-registration'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Register as Provider'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the full payment view for providers
  Widget _buildProviderPaymentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.payment, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Secure Payment Options',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose your preferred payment method',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
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

          // Local Payment Methods Section
          Text(
            'Local Payment Methods',
            style: AppTypography.h5.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Pay using Pakistani mobile wallets',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // JazzCash Card
          _buildMobileWalletCard(_jazzCash),
          const SizedBox(height: 16),

          // EasyPaisa Card
          _buildMobileWalletCard(_easyPaisa),
          const SizedBox(height: 32),

          // Bank Transfer Section
          Text(
            'Bank Transfer',
            style: AppTypography.h5.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Direct bank transfer to our account',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Bank Account Card
          _buildBankAccountCard(),
          const SizedBox(height: 32),

          // International Section (Coming Soon)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.language, color: Colors.grey[600], size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'International Payments',
                        style: AppTypography.labelLarge.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PayPal, Stripe, and Wire Transfer coming soon!',
                        style: AppTypography.bodySmall.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Payment Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Payment Instructions',
                      style: AppTypography.labelLarge.copyWith(color: Colors.blue[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInstruction('1', 'Send payment to the selected method'),
                _buildInstruction('2', 'Take a screenshot of the transaction'),
                _buildInstruction('3', 'Upload proof in the payment confirmation form'),
                _buildInstruction('4', 'Your payment will be verified within 24 hours'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMobileWalletCard(Map<String, dynamic> wallet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (wallet['color'] as Color).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: wallet['color'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(wallet['icon'] as IconData, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet['name'] as String,
                        style: AppTypography.labelLarge.copyWith(
                          color: wallet['color'] as Color,
                        ),
                      ),
                      Text(
                        wallet['description'] as String,
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Number
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile Number',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wallet['number'] as String,
                        style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(wallet['number'] as String, 'Number'),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: wallet['color'] as Color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (_bankAccount['color'] as Color).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _bankAccount['color'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bankAccount['bankName'] as String,
                        style: AppTypography.labelLarge.copyWith(
                          color: _bankAccount['color'] as Color,
                        ),
                      ),
                      Text(
                        '${_bankAccount['branchName']} - ${_bankAccount['branchAddress']}',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bank Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBankDetailRow(
                  'Account Title',
                  _bankAccount['accountTitle'] as String,
                  copyable: true,
                ),
                const Divider(height: 24),
                _buildBankDetailRow(
                  'Account Number',
                  _bankAccount['accountNumber'] as String,
                  copyable: true,
                  highlight: true,
                ),
                const Divider(height: 24),
                _buildBankDetailRow(
                  'IBAN',
                  _bankAccount['iban'] as String,
                  copyable: true,
                ),
                const Divider(height: 24),
                _buildBankDetailRow(
                  'SWIFT Code',
                  _bankAccount['swiftCode'] as String,
                  copyable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value, {bool copyable = false, bool highlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: highlight
                    ? GoogleFonts.robotoMono(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      )
                    : GoogleFonts.robotoMono(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
              ),
            ],
          ),
        ),
        if (copyable)
          IconButton(
            onPressed: () => _copyToClipboard(value, label),
            icon: Icon(Icons.copy, size: 20, color: Colors.grey[600]),
            tooltip: 'Copy $label',
          ),
      ],
    );
  }

  Widget _buildInstruction(String step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: Colors.blue[900]),
            ),
          ),
        ],
      ),
    );
  }
}
