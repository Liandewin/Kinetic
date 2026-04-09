import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// START WORKOUT SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class StartWorkoutScreen extends StatefulWidget {
  const StartWorkoutScreen({super.key});

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Pulsing aura behind START button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.82, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Live clock
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _clockTimer.cancel();
    super.dispose();
  }

  String get _timeString {
    final h = _now.hour.toString().padLeft(2, '0');
    final m = _now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get _dateString {
    const days = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY'
    ];
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return '${days[_now.weekday - 1]}, ${months[_now.month - 1]} ${_now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // ── 1. Background: desaturated city grid ──────────
          Positioned.fill(child: _CityGridBackground()),

          // ── 2. Gradient overlay (fade top & bottom) ───────
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF9F9F9),
                    Colors.transparent,
                    Color(0xCCF9F9F9),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── 3. Main content ───────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 64), // clear frosted app bar
                _DailyProgressBar(progress: 0.667),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _DateTimeSection(
                          timeString: _timeString,
                          dateString: _dateString,
                        ),
                        _StartButtonArea(pulseAnimation: _pulseAnimation),
                        _BentoStatsGrid(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 4. Frosted app bar (renders on top) ───────────
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
// BACKGROUND: Desaturated city grid
// ─────────────────────────────────────────────────────────────────────────────
class _CityGridBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CityGridPainter(),
      child: const ColoredBox(color: Color(0xFFF0EFEE)),
    );
  }
}

class _CityGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = const Color(0xFFD6D4D2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final major = Paint()
      ..color = const Color(0xFFC0BDBA)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Minor grid lines every 22px
    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }
    for (double x = 0; x < size.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minor);
    }

    // Major roads every ~88px
    for (double y = 0; y < size.height; y += 88) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), major);
    }
    for (double x = 0; x < size.width; x += 88) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), major);
    }
  }

  @override
  bool shouldRepaint(_CityGridPainter _) => false;
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
          padding: EdgeInsets.only(
            top: topPadding,
            left: 24,
            right: 24,
          ),
          color: const Color(0xCCF9F9F9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu_rounded,
                  color: const Color(0xFF474747), size: 22),
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
// DAILY PROGRESS BAR  (2px, green fill)
// ─────────────────────────────────────────────────────────────────────────────
class _DailyProgressBar extends StatelessWidget {
  final double progress;
  const _DailyProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: const Color(0x33C6C6C6),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        minHeight: 2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATE & TIME SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _DateTimeSection extends StatelessWidget {
  final String timeString;
  final String dateString;
  const _DateTimeSection({required this.timeString, required this.dateString});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "READY TO MOVE"
        Text(
          'READY TO MOVE',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
            color: const Color(0xFF474747),
          ),
        ),
        const SizedBox(height: 8),
        // Time
        Text(
          timeString,
          style: GoogleFonts.lexend(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
            height: 1.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        // Date
        Text(
          dateString,
          style: GoogleFonts.lexend(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.8,
            color: const Color(0xFF5F5E5E),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// START BUTTON with pulsing aura
// ─────────────────────────────────────────────────────────────────────────────
class _StartButtonArea extends StatelessWidget {
  final Animation<double> pulseAnimation;
  const _StartButtonArea({required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing green aura
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, _) {
              return Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.20),
                  ),
                  foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.0),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // START button
          GestureDetector(
            onTap: () {
              // TODO: start workout logic
            },
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.20),
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                    spreadRadius: -12,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'START',
                style: GoogleFonts.lexend(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.4,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BENTO STATS GRID  (GPS / Battery / Calories)
// ─────────────────────────────────────────────────────────────────────────────
class _BentoStatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _GlassStatCard(
              icon: Icons.gps_fixed_rounded,
              iconColor: Colors.black,
              label: 'GPS',
              value: 'STRONG',
              greenBorder: false,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _GlassStatCard(
              icon: Icons.battery_full_rounded,
              iconColor: Colors.black,
              label: 'BATTERY',
              value: '88%',
              greenBorder: false,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _GlassStatCard(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.primary,
              label: 'BURNED',
              value: '1,240',
              unit: 'kcal',
              greenBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? unit;
  final bool greenBorder;

  const _GlassStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.unit,
    required this.greenBorder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: greenBorder
                ? const Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Icon(icon, size: 16, color: iconColor),

              // Label + Value
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      color: const Color(0xFF474747),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (unit != null) ...[
                        const SizedBox(width: 2),
                        Text(
                          unit!,
                          style: GoogleFonts.lexend(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
