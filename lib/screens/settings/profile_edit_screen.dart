import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/user_provider.dart';
import '../../providers/energy_provider.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../widgets/gradient_button.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalController = TextEditingController();

  String _sex = 'male';
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await ref.read(userDataProvider.future);
    if (user != null) {
      _nameController.text = user.name ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _weightController.text = user.weightKg?.toString() ?? '';
      _heightController.text = user.heightCm?.toString() ?? '';
      _goalController.text = user.goal ?? '';
      _sex = user.sex ?? 'male';
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await ref.read(userDataProvider.future);
      if (user == null) throw Exception('User not found');

      // Upload avatar if selected
      String? avatarUrl;
      if (_selectedImage != null) {
        final storage = ref.read(storageServiceProvider);
        avatarUrl = await storage.uploadAvatar(_selectedImage!, user.id);
      }

      // Update user data
      final db = ref.read(databaseServiceProvider);
      await db.updateUser(user.id, {
        'name': _nameController.text.trim(),
        'age': int.parse(_ageController.text),
        'sex': _sex,
        'weight_kg': double.parse(_weightController.text),
        'height_cm': double.parse(_heightController.text),
        'goal': _goalController.text.trim(),
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      });

      // Refresh user data
      ref.invalidate(userDataProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF34d399),
        ),
      );

      Navigator.of(context).pop();
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
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF60a5fa), Color(0xFF06b6d4)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              TextFormField(
                controller: _nameController,
                validator: (v) => Validators.required(v, 'Name'),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

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

              TextFormField(
                controller: _goalController,
                validator: (v) => Validators.required(v, 'Goal'),
                decoration: const InputDecoration(
                  labelText: 'Your Goal',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              GradientButton(
                text: 'Save Changes',
                onPressed: _handleSave,
                gradientColors: AppConstants.evolveGradient,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

