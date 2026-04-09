import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ACHIEVEMENTS SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Scrollable content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 128),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Daily Goal Progress ──────────
                      _DailyGoalTracker(progress: 0.85, label: '85%'),
                      const SizedBox(height: 48),

                      // ── Earned Rewards ───────────────
                      _SectionHeader(
                          title: 'EARNED REWARDS', trailing: '12 Total'),
                      const SizedBox(height: 24),
                      _EarnedRewardCard(
                        icon: Icons.emoji_events_rounded,
                        title: 'First 5K',
                        subtitle: 'Completed on Oct 12, 2023',
                        state: _RewardState.earned,
                      ),
                      const SizedBox(height: 16),
                      _EarnedRewardCard(
                        icon: Icons.local_fire_department_rounded,
                        title: '7 Day Streak',
                        subtitle: 'Consistency is key',
                        state: _RewardState.earned,
                      ),
                      const SizedBox(height: 16),
                      _EarnedRewardCard(
                        icon: Icons.directions_run_rounded,
                        title: '100km Milestone',
                        subtitle: 'Level 2 Runner Status',
                        state: _RewardState.claimable,
                      ),
                      const SizedBox(height: 48),

                      // ── In Progress ──────────────────
                      _SectionHeader(
                          title: 'IN PROGRESS', trailing: 'Next Milestone'),
                      const SizedBox(height: 24),
                      _MilestoneCard(
                        icon: Icons.directions_run_rounded,
                        title: '3/5 Weekly Runs',
                        subtitle: '2 more to reach your goal',
                        progress: 0.60,
                        trailingLabel: null,
                      ),
                      const SizedBox(height: 24),
                      _MilestoneCard(
                        icon: Icons.terrain_rounded,
                        title: 'Mountain Climber',
                        subtitle: '850m / 1,000m Elevation',
                        progress: 0.85,
                        trailingLabel: '85%',
                      ),
                      const SizedBox(height: 24),

                      // Bento pair
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _BentoMilestoneCard(
                              category: 'SUB 20MIN 5K',
                              title: 'Pace Master',
                              progress: 0.40,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _BentoMilestoneCard(
                              category: 'AFTER HOURS',
                              title: 'Night Owl',
                              progress: 0.75,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // Frosted app bar on top
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
// FROSTED APP BAR  (shared style)
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
// DAILY GOAL TRACKER
// ─────────────────────────────────────────────────────────────────────────────
class _DailyGoalTracker extends StatelessWidget {
  final double progress;
  final String label;
  const _DailyGoalTracker({required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'DAILY GOAL PROGRESS',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: const Color(0xFF5F5E5E),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String trailing;
  const _SectionHeader({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: const Color(0xFF5F5E5E),
          ),
        ),
        Text(
          trailing,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EARNED REWARD CARD
// ─────────────────────────────────────────────────────────────────────────────
enum _RewardState { earned, claimable }

class _EarnedRewardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final _RewardState state;

  const _EarnedRewardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isClaimable = state == _RewardState.claimable;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: isClaimable
            ? const Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon + text
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardMapBg,
                ),
                child: Icon(icon, size: 22, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
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
            ],
          ),

          // Trailing: checkmark or CLAIM button
          if (isClaimable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                'CLAIM',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                  color: Colors.black,
                ),
              ),
            )
          else
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(Icons.check_rounded,
                  size: 13, color: Colors.black),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MILESTONE CARD  (full width, black progress bar)
// ─────────────────────────────────────────────────────────────────────────────
class _MilestoneCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final String? trailingLabel;

  const _MilestoneCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.trailingLabel,
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardMapBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon,
                        size: 20,
                        color: AppColors.textPrimary.withOpacity(0.6)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                ],
              ),
              if (trailingLabel != null)
                Text(
                  trailingLabel!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // Black progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.borderLight,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BENTO MILESTONE CARD  (compact, side by side)
// ─────────────────────────────────────────────────────────────────────────────
class _BentoMilestoneCard extends StatelessWidget {
  final String category;
  final String title;
  final double progress;

  const _BentoMilestoneCard({
    required this.category,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dim icon placeholder
          Container(
            height: 15,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          // Category
          Text(
            category,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.52,
              color: const Color(0xFF5F5E5E),
            ),
          ),
          const SizedBox(height: 3),
          // Title
          Text(
            title,
            style: GoogleFonts.lexend(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Black progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.borderLight,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
