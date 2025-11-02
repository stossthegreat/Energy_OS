import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../widgets/gradient_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalController = TextEditingController();

  String _sex = 'male';
  bool _isLoading = false;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await ref.read(userDataProvider.future);
      if (user == null) throw Exception('User not found');

      final db = ref.read(databaseServiceProvider);
      await db.updateUser(user.id, {
        'age': int.parse(_ageController.text),
        'sex': _sex,
        'weight_kg': double.parse(_weightController.text),
        'height_cm': double.parse(_heightController.text),
        'goal': _goalController.text.trim(),
      });

      // Navigate to main app
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Tell Us About You',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Help us personalize your experience',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 40),

                // Age
                TextFormField(
                  controller: _ageController,
                  validator: (v) => Validators.number(v, 'Age'),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                ),

                const SizedBox(height: 20),

                // Sex
                DropdownButtonFormField<String>(
                  value: _sex,
                  decoration: const InputDecoration(
                    labelText: 'Sex',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  dropdownColor: Colors.grey[900],
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sex = value);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Weight
                TextFormField(
                  controller: _weightController,
                  validator: (v) => Validators.number(v, 'Weight'),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                ),

                const SizedBox(height: 20),

                // Height
                TextFormField(
                  controller: _heightController,
                  validator: (v) => Validators.number(v, 'Height'),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height_outlined),
                  ),
                ),

                const SizedBox(height: 20),

                // Goal
                TextFormField(
                  controller: _goalController,
                  validator: (v) => Validators.required(v, 'Goal'),
                  decoration: const InputDecoration(
                    labelText: 'Your Goal',
                    prefixIcon: Icon(Icons.flag_outlined),
                    hintText: 'e.g., build muscle, lose weight, improve energy',
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 40),

                GradientButton(
                  text: 'Complete Setup',
                  onPressed: _handleComplete,
                  gradientColors: AppConstants.todayGradient,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

