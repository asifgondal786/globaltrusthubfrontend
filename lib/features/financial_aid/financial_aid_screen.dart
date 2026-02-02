import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class FinancialAidScreen extends StatelessWidget {
  const FinancialAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Financial Aid'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            Row(
              children: [
                _buildStatCard('Available Scholarships', '250+', Icons.school, Colors.green),
                const SizedBox(width: 12),
                _buildStatCard('Student Loans', '15+ Banks', Icons.account_balance, Colors.blue),
              ],
            ),
            const SizedBox(height: 24),

            // Scholarships Section
            Text('Featured Scholarships', style: AppTypography.h5),
            const SizedBox(height: 12),
            _buildScholarshipCard(
              'Fulbright Scholarship',
              'USA',
              'Full Tuition + Living Expenses',
              'For graduate studies in any field',
              Colors.blue,
            ),
            _buildScholarshipCard(
              'Chevening Scholarship',
              'UK',
              'Full Funding',
              'For master\'s degree programs',
              Colors.red,
            ),
            _buildScholarshipCard(
              'Erasmus Mundus',
              'Europe',
              '€1,400/month + Tuition',
              'For joint master programs',
              Colors.purple,
            ),

            const SizedBox(height: 24),

            // Student Loans Section
            Text('Student Loan Options', style: AppTypography.h5),
            const SizedBox(height: 12),
            _buildLoanCard(context, 'Education Loan - Bank A', '8.5% APR', 'Up to \$100,000', 'No collateral required'),
            _buildLoanCard(context, 'Student Plus Loan', '7.5% APR', 'Up to \$150,000', 'Co-signer required'),
            _buildLoanCard(context, 'Graduate Loan', '9.0% APR', 'Up to \$200,000', 'Flexible repayment'),

            const SizedBox(height: 24),

            // Financial Planning Tools
            Text('Financial Planning', style: AppTypography.h5),
            const SizedBox(height: 12),
            _buildToolCard(context, 'Budget Calculator', 'Plan your monthly expenses', Icons.calculate, () => _showBudgetCalculator(context)),
            _buildToolCard(context, 'Cost Comparison', 'Compare costs across countries', Icons.compare_arrows, () => _showCostComparison(context)),
            _buildToolCard(context, 'Loan EMI Calculator', 'Calculate loan repayments', Icons.payments, () => _showEMICalculator(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.h4.copyWith(color: color)),
            Text(title, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildScholarshipCard(String name, String country, String amount, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.workspace_premium, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.labelLarge),
                Text('$country • $amount', style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
                Text(description, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildLoanCard(BuildContext context, String name, String rate, String amount, String feature) {
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
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.labelLarge),
                Text('$rate • $amount', style: AppTypography.bodySmall),
                Text(feature, style: AppTypography.caption.copyWith(color: Colors.green)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showEMICalculator(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.labelLarge),
                      Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Budget Calculator
  void _showBudgetCalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BudgetCalculatorSheet(),
    );
  }

  // Cost Comparison
  void _showCostComparison(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CostComparisonSheet(),
    );
  }

  // EMI Calculator
  void _showEMICalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _EMICalculatorSheet(),
    );
  }
}

// Budget Calculator Sheet
class _BudgetCalculatorSheet extends StatefulWidget {
  const _BudgetCalculatorSheet();

  @override
  State<_BudgetCalculatorSheet> createState() => _BudgetCalculatorSheetState();
}

class _BudgetCalculatorSheetState extends State<_BudgetCalculatorSheet> {
  final _tuitionController = TextEditingController(text: '25000');
  final _housingController = TextEditingController(text: '12000');
  final _foodController = TextEditingController(text: '3600');
  final _transportController = TextEditingController(text: '1200');
  final _booksController = TextEditingController(text: '1000');
  final _personalController = TextEditingController(text: '2400');

  double get totalAnnual {
    return (double.tryParse(_tuitionController.text) ?? 0) +
           (double.tryParse(_housingController.text) ?? 0) +
           (double.tryParse(_foodController.text) ?? 0) +
           (double.tryParse(_transportController.text) ?? 0) +
           (double.tryParse(_booksController.text) ?? 0) +
           (double.tryParse(_personalController.text) ?? 0);
  }

  double get totalMonthly => totalAnnual / 12;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Row(
                    children: [
                      const Icon(Icons.calculate, color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Text('Budget Calculator', style: AppTypography.h4),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Enter your estimated expenses to calculate your annual budget', 
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),),
                  const SizedBox(height: 24),
                  
                  _buildInputField('Tuition & Fees (Annual)', _tuitionController, Icons.school),
                  _buildInputField('Housing/Rent (Annual)', _housingController, Icons.home),
                  _buildInputField('Food & Meals (Annual)', _foodController, Icons.restaurant),
                  _buildInputField('Transportation (Annual)', _transportController, Icons.directions_car),
                  _buildInputField('Books & Supplies (Annual)', _booksController, Icons.book),
                  _buildInputField('Personal Expenses (Annual)', _personalController, Icons.shopping_bag),
                  
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Annual Budget', style: AppTypography.labelLarge.copyWith(color: Colors.white70)),
                            Text('\$${totalAnnual.toStringAsFixed(0)}', style: AppTypography.h4.copyWith(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Monthly Average', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                            Text('\$${totalMonthly.toStringAsFixed(0)}/month', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          prefixText: '\$ ',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }
}

// Cost Comparison Sheet
class _CostComparisonSheet extends StatefulWidget {
  const _CostComparisonSheet();

  @override
  State<_CostComparisonSheet> createState() => _CostComparisonSheetState();
}

class _CostComparisonSheetState extends State<_CostComparisonSheet> {
  String _selectedCountry1 = 'USA';
  String _selectedCountry2 = 'UK';

  final Map<String, Map<String, double>> _countryCosts = {
    'USA': {'tuition': 35000, 'housing': 15000, 'living': 12000, 'total': 62000},
    'UK': {'tuition': 22000, 'housing': 12000, 'living': 10000, 'total': 44000},
    'Canada': {'tuition': 20000, 'housing': 10000, 'living': 9000, 'total': 39000},
    'Australia': {'tuition': 28000, 'housing': 14000, 'living': 11000, 'total': 53000},
    'Germany': {'tuition': 500, 'housing': 8000, 'living': 8000, 'total': 16500},
  };

  @override
  Widget build(BuildContext context) {
    final cost1 = _countryCosts[_selectedCountry1]!;
    final cost2 = _countryCosts[_selectedCountry2]!;
    final savings = cost1['total']! - cost2['total']!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                  Row(
                    children: [
                      const Icon(Icons.compare_arrows, color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Text('Cost Comparison', style: AppTypography.h4),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(child: _buildCountryDropdown(_selectedCountry1, (v) => setState(() => _selectedCountry1 = v!))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('VS', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: _buildCountryDropdown(_selectedCountry2, (v) => setState(() => _selectedCountry2 = v!))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  _buildComparisonRow('Tuition/Year', cost1['tuition']!, cost2['tuition']!),
                  _buildComparisonRow('Housing/Year', cost1['housing']!, cost2['housing']!),
                  _buildComparisonRow('Living Expenses', cost1['living']!, cost2['living']!),
                  const Divider(height: 32),
                  _buildComparisonRow('Total/Year', cost1['total']!, cost2['total']!, isTotal: true),
                  
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: savings > 0 ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: savings > 0 ? Colors.green : Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Icon(savings > 0 ? Icons.savings : Icons.info, color: savings > 0 ? Colors.green : Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          savings > 0 
                            ? 'You save \$${savings.abs().toStringAsFixed(0)}/year with $_selectedCountry2'
                            : '\$${savings.abs().toStringAsFixed(0)}/year more in $_selectedCountry2',
                          style: AppTypography.labelLarge.copyWith(color: savings > 0 ? Colors.green : Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: _countryCosts.keys.map((country) => DropdownMenuItem(
            value: country,
            child: Text(country),
          ),).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, double val1, double val2, {bool isTotal = false}) {
    final style = isTotal ? AppTypography.labelLarge : AppTypography.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text('\$${val1.toStringAsFixed(0)}', style: style, textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(label, style: style.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
          ),
          Expanded(child: Text('\$${val2.toStringAsFixed(0)}', style: style, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

// EMI Calculator Sheet
class _EMICalculatorSheet extends StatefulWidget {
  const _EMICalculatorSheet();

  @override
  State<_EMICalculatorSheet> createState() => _EMICalculatorSheetState();
}

class _EMICalculatorSheetState extends State<_EMICalculatorSheet> {
  double _loanAmount = 50000;
  double _interestRate = 8.5;
  double _loanTenure = 5;

  double get monthlyEMI {
    double principal = _loanAmount;
    double rate = _interestRate / 12 / 100;
    double time = _loanTenure * 12;
    
    if (rate == 0) return principal / time;
    
    double emi = principal * rate * (1 + rate).pow(time) / ((1 + rate).pow(time) - 1);
    return emi;
  }

  double get totalPayment => monthlyEMI * _loanTenure * 12;
  double get totalInterest => totalPayment - _loanAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Row(
                    children: [
                      const Icon(Icons.payments, color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Text('Loan EMI Calculator', style: AppTypography.h4),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Loan Amount Slider
                  Text('Loan Amount: \$${_loanAmount.toStringAsFixed(0)}', style: AppTypography.labelLarge),
                  Slider(
                    value: _loanAmount,
                    min: 5000,
                    max: 200000,
                    divisions: 39,
                    activeColor: AppColors.primary,
                    onChanged: (value) => setState(() => _loanAmount = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Interest Rate Slider
                  Text('Interest Rate: ${_interestRate.toStringAsFixed(1)}%', style: AppTypography.labelLarge),
                  Slider(
                    value: _interestRate,
                    min: 4,
                    max: 15,
                    divisions: 22,
                    activeColor: AppColors.primary,
                    onChanged: (value) => setState(() => _interestRate = value),
                  ),
                  const SizedBox(height: 16),
                  
                  // Loan Tenure Slider
                  Text('Loan Tenure: ${_loanTenure.toStringAsFixed(0)} years', style: AppTypography.labelLarge),
                  Slider(
                    value: _loanTenure,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    activeColor: AppColors.primary,
                    onChanged: (value) => setState(() => _loanTenure = value),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Results
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Monthly EMI', style: AppTypography.labelLarge.copyWith(color: Colors.white70)),
                            Text('\$${monthlyEMI.toStringAsFixed(2)}', style: AppTypography.h4.copyWith(color: Colors.white)),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Interest', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                            Text('\$${totalInterest.toStringAsFixed(0)}', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Payment', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
                            Text('\$${totalPayment.toStringAsFixed(0)}', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Loan application submitted!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply for This Loan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on double {
  double pow(double exponent) => power(this, exponent);
}

double power(double base, double exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
