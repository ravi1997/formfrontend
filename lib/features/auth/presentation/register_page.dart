import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/core/state/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _deviceController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _deviceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthStateNotifier>();
      final success = await authState.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        designation: _designationController.text.trim().isEmpty ? null : _designationController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        deviceName: _deviceController.text.trim().isEmpty ? null : _deviceController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile registered and authenticated successfully.')),
        );
        Navigator.of(context).pop(); // Back to login, which automatically moves forward if authenticated
      } else if (mounted && authState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage!),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthStateNotifier>();
    final isMobile = AppBreakpoints.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.inkBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isMobile ? double.infinity : 450,
            margin: EdgeInsets.all(context.space24),
            padding: EdgeInsets.all(context.space32),
            decoration: AppCardStyles.elevatedDecoration,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.space12,
                        vertical: context.space6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        borderRadius: context.borderSm,
                      ),
                      child: Text(
                        'A.D.I.Y.O.G.I',
                        style: context.uiMicro.copyWith(
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.space24),
                  Center(
                    child: Text(
                      'Register Profile',
                      style: context.sectionHeading,
                    ),
                  ),
                  SizedBox(height: context.space8),
                  Center(
                    child: Text(
                      'Initialize system observer credential set',
                      style: context.bodyMedium.copyWith(color: AppColors.greyMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: context.space24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Observer Name',
                      hintText: 'e.g. John Doe',
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.space16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Security Email Address',
                      hintText: 'name@domain.com',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email address is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.space16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Access Password',
                      hintText: 'Minimum 8 characters',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
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
                  SizedBox(height: context.space16),
                  TextFormField(
                    controller: _designationController,
                    decoration: const InputDecoration(
                      labelText: 'Designation (Optional)',
                      hintText: 'e.g. System Admin / Data Operator',
                      prefixIcon: Icon(Icons.work_outline_rounded, size: 20),
                    ),
                  ),
                  SizedBox(height: context.space16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Identifier (Optional)',
                      hintText: 'e.g. +1234567890',
                      prefixIcon: Icon(Icons.phone_android_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: context.space16),
                  TextFormField(
                    controller: _deviceController,
                    decoration: const InputDecoration(
                      labelText: 'Device Name (Optional)',
                      hintText: 'e.g. Workstation-A',
                      prefixIcon: Icon(Icons.computer_outlined, size: 20),
                    ),
                  ),
                  SizedBox(height: context.space24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.status == AuthStatus.authenticating ? null : _submit,
                      style: AppButtonStyles.primary,
                      child: authState.status == AuthStatus.authenticating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(AppColors.pureWhite),
                              ),
                            )
                          : const Text('Register & Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
