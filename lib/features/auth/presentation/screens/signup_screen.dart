import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    await ref
        .read(authNotifierProvider.notifier)
        .signUpWithEmail(email, password, name);

    if (!mounted) return;
    // If sign-up failed, the listener already showed a snackbar. Clear the
    // error state and bail — don't navigate to check-email on failure.
    // On success (and when email confirmations are required on the Supabase
    // project), there's no session yet — send the user to the "check your
    // email" screen so they know what to do next.
    final state = ref.read(authNotifierProvider);
    if (state.hasError) {
      ref.read(authNotifierProvider.notifier).clearError();
      return;
    }
    final encoded = Uri.encodeQueryComponent(email);
    context.go('${AppRoutes.checkEmail}?email=$encoded');
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  Future<void> _signInWithApple() async {
    await ref.read(authNotifierProvider.notifier).signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: AppColors.error,
            ),
          );
          // Don't clearError here — _signUp inspects state post-await to
          // decide whether to navigate to /check-email, and clearing
          // synchronously in the listener would hide the error from it.
        },
      );
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Text(
                'KINETIC',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'CREATE YOUR ACCOUNT',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              KineticTextField(
                controller: _nameController,
                label: 'FULL NAME',
                hint: 'Alex Rivera',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 12),
              KineticTextField(
                controller: _emailController,
                label: 'EMAIL',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              KineticTextField(
                controller: _passwordController,
                label: 'PASSWORD',
                hint: '••••••••',
                obscureText: _obscurePassword,
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AuthPrimaryButton(
                label: 'CREATE ACCOUNT',
                isLoading: isLoading,
                onTap: _signUp,
              ),
              const SizedBox(height: 32),
              const AuthOrDivider(),
              const SizedBox(height: 32),
              AuthSocialButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                onTap: isLoading ? null : _signInWithGoogle,
              ),
              const SizedBox(height: 12),
              AuthSocialButton(
                label: 'Continue with Apple',
                icon: Icons.apple_rounded,
                onTap: isLoading ? null : _signInWithApple,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
