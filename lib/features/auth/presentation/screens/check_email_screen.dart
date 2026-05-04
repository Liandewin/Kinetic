import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

/// Post-signup confirmation screen. Instructs the user to click the link in
/// their inbox. The deep link (`io.kinetic.app://login-callback/`) will bring
/// them back into the app, at which point Supabase fires `SIGNED_IN` and the
/// router guard pushes them to `/`.
class CheckEmailScreen extends ConsumerStatefulWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  ConsumerState<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends ConsumerState<CheckEmailScreen> {
  static const int _cooldownSeconds = 60;

  Timer? _cooldownTimer;
  int _secondsRemaining = 0;

  bool get _inCooldown => _secondsRemaining > 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    if (_inCooldown) return;
    await ref
        .read(authNotifierProvider.notifier)
        .resendVerificationEmail(widget.email);

    if (!mounted) return;
    final state = ref.read(authNotifierProvider);
    if (state.hasError) {
      // Listener already showed an error snackbar. Just clear and bail —
      // don't show the success snackbar or start the cooldown.
      ref.read(authNotifierProvider.notifier).clearError();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification email resent to ${widget.email}'),
        backgroundColor: AppColors.primary,
      ),
    );
    _startCooldown();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _secondsRemaining = _cooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining <= 1) {
          _secondsRemaining = 0;
          timer.cancel();
        } else {
          _secondsRemaining -= 1;
        }
      });
    });
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
          // Don't clearError here — _resend inspects state post-await to
          // decide whether to show the success snackbar + start cooldown.
        },
      );
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Text(
                'KINETIC',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 5.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 72),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 44,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'CHECK YOUR EMAIL',
                style: GoogleFonts.lexend(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "We've sent a confirmation link to",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Tap the link in the email to verify your account — you'll be returned to the app automatically.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ),
              const Spacer(),
              AuthPrimaryButton(
                label: _inCooldown
                    ? 'RESEND IN ${_secondsRemaining}s'
                    : 'RESEND EMAIL',
                isLoading: isLoading,
                onTap: _inCooldown ? null : _resend,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.go(AppRoutes.login),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Back to Sign In',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
