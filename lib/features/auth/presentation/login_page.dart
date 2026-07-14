import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/core/state/auth_state.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/auth/presentation/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRememberedEmail();
    });
  }

  Future<void> _loadRememberedEmail() async {
    final storage = context.read<SecureTokenStorage>();
    final remember = await storage.getRememberMe();
    if (remember) {
      final email = await storage.getSavedEmail();
      if (email != null && mounted) {
        setState(() {
          _rememberMe = true;
          _emailController.text = email;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final storage = context.read<SecureTokenStorage>();
      final authState = context.read<AuthStateNotifier>();
      
      // Save remember me preference before login is triggered (to avoid unmount issues)
      await storage.saveRememberMe(remember: _rememberMe, email: email);

      final success = await authState.login(
        email: email,
        password: _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authenticated successfully.')),
        );
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isMobile ? double.infinity : 420,
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
                      'Access Identity',
                      style: context.sectionHeading,
                    ),
                  ),
                  SizedBox(height: context.space8),
                  Center(
                    child: Text(
                      'Enter credentials to retrieve security token',
                      style: context.bodyMedium.copyWith(color: AppColors.greyMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: context.space32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
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
                  SizedBox(height: context.space20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Security Password',
                      hintText: 'Enter your password',
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
                      return null;
                    },
                  ),
                  SizedBox(height: context.space16),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.charcoal,
                        ),
                      ),
                      SizedBox(width: context.space8),
                      Text(
                        'Remember me',
                        style: context.bodyMedium.copyWith(
                          color: AppColors.greyBody,
                        ),
                      ),
                    ],
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
                          : const Text('Authenticate'),
                    ),
                  ),
                  if (authState.errorStatusCode == 401 || authState.errorStatusCode == 403) ...[
                    SizedBox(height: context.space12),
                    Text(
                      'This account must be verified before it can authenticate.',
                      style: context.bodyMedium.copyWith(
                        color: AppColors.greyMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  SizedBox(height: context.space24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'New to system? ',
                        style: context.bodyMedium.copyWith(color: AppColors.greyBody),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Register profile',
                          style: context.bodyMedium.copyWith(
                            color: AppColors.charcoal,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
