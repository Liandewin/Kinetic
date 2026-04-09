import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 128),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _ProfileHero(),
                      const SizedBox(height: 32),
                      const _StatsRow(),
                      const SizedBox(height: 48),
                      const _SectionHeader(
                        title: 'ACTIVE GOALS',
                        trailingText: '2/3 TARGET',
                        trailingColor: AppColors.primary,
                      ),
                      const SizedBox(height: 24),
                      const _GoalCard(
                        title: 'Monthly Distance',
                        subtitle: 'Target: 200 KM',
                        percentage: '82%',
                        progress: 0.82,
                      ),
                      const SizedBox(height: 24),
                      const _GoalCard(
                        title: 'Weekly Frequency',
                        subtitle: 'Target: 5 Runs',
                        percentage: '60%',
                        progress: 0.60,
                      ),
                      const SizedBox(height: 48),
                      const _SettingsLink(
                        icon: Icons.emoji_events_outlined,
                        label: 'PERSONAL RECORDS',
                      ),
                      const SizedBox(height: 8),
                      const _SettingsLink(
                        icon: Icons.settings_outlined,
                        label: 'SETTINGS',
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _FrostedAppBar(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FROSTED APP BAR
// ─────────────────────────────────────────────────────────────────────────────
class _FrostedAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 64 + topPadding,
          padding: EdgeInsets.only(top: topPadding, left: 24, right: 24),
          color: const Color(0xCCF9F9F9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 22),
              Text(
                'KINETIC',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.0,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardGray,
                ),
                child: const Icon(Icons.person_rounded,
                    size: 18, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE HERO
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [AppColors.primary, Color(0xFFE8E8E8)],
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundLight,
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardGray,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 56,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ALEX RIVERA',
          style: GoogleFonts.lexend(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.75,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ELITE TRAIL RUNNER',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 2.4,
            color: const Color(0xFF5F5E5E),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x4DF3F3F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33C6C6C6), width: 1),
      ),
      child: const IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _StatCell(label: 'TOTAL KM', value: '1,284')),
            VerticalDivider(color: Color(0x33C6C6C6), width: 1, thickness: 1),
            Expanded(child: _StatCell(label: 'TOTAL RUNS', value: '156')),
            VerticalDivider(color: Color(0x33C6C6C6), width: 1, thickness: 1),
            Expanded(child: _StatCell(label: 'AVG PACE', value: '4:32')),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
              color: const Color(0xFF5F5E5E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lexend(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String trailingText;
  final Color trailingColor;

  const _SectionHeader({
    required this.title,
    required this.trailingText,
    required this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          trailingText,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: trailingColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GOAL CARD
// ─────────────────────────────────────────────────────────────────────────────
class _GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String percentage;
  final double progress;

  const _GoalCard({
    required this.title,
    required this.subtitle,
    required this.percentage,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5F5E5E),
                    ),
                  ),
                ],
              ),
              Text(
                percentage,
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.borderLight,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS LINK
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsLink extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SettingsLink({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0x80F3F3F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF5F5E5E)),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 20, color: Color(0xFFC6C6C6)),
        ],
      ),
    );
  }
}
