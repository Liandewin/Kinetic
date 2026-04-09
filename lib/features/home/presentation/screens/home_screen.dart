import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _KineticAppBar()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 128),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SectionHeader(),
                  const SizedBox(height: 48),
                  _FeedItemHeader(
                      name: 'Elena Vance',
                      subtitle: 'MORNING RITUAL • 2H AGO',
                      showFollow: true),
                  const SizedBox(height: 16),
                  _PhotoFeedCard(
                      title: 'PEAK\nPERFORMANCE',
                      distance: '12.4',
                      pace: "4'52",
                      time: '1:00:24',
                      likes: 242,
                      comments: 18),
                  const SizedBox(height: 40),
                  _FeedItemHeader(
                      name: 'Marcus Thorne',
                      subtitle: 'CITY LOOP • 5H AGO',
                      showFollow: false),
                  const SizedBox(height: 16),
                  _MapFeedCard(
                      distance: '5.2',
                      pace: "5'10",
                      time: '0:26:52',
                      likes: 89,
                      comments: 4),
                  const SizedBox(height: 40),
                  _FeedItemHeader(
                      name: 'Sasha Grey',
                      subtitle: 'INTERVAL TRAINING • 8H AGO',
                      showFollow: false),
                  const SizedBox(height: 16),
                  const _BentoFeedCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KineticAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 24),
          Text(
            'KINETIC',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: AppColors.textPrimary),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.cardGray),
            child: const Icon(Icons.person_rounded,
                size: 20, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('COMMUNITY',
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('The Void Feed',
                style: GoogleFonts.lexend(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: AppColors.textPrimary)),
          ],
        ),
        _OverlappingAvatars(),
      ],
    );
  }
}

class _OverlappingAvatars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const s = 32.0;
    const overlap = 8.0;
    return SizedBox(
      height: s,
      width: s * 3 - overlap * 2,
      child: Stack(
        children: [
          _AvatarCircle(left: 0, color: const Color(0xFFE0C8A0)),
          _AvatarCircle(left: s - overlap, color: const Color(0xFFA0C8E0)),
          Positioned(
            left: (s - overlap) * 2,
            child: Container(
              width: s,
              height: s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardGray,
                border: Border.all(color: AppColors.backgroundLight, width: 2),
              ),
              alignment: Alignment.center,
              child: Text('+12',
                  style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final double left;
  final Color color;
  const _AvatarCircle({required this.left, required this.color});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: AppColors.backgroundLight, width: 2),
        ),
      ),
    );
  }
}

class _FeedItemHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool showFollow;
  const _FeedItemHeader(
      {required this.name, required this.subtitle, required this.showFollow});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.cardGray),
          child: const Icon(Icons.person_rounded,
              size: 22, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.35,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
        if (showFollow)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9999)),
            child: Text('FOLLOW',
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.black)),
          ),
      ],
    );
  }
}

BoxDecoration _cardDecoration({Color color = AppColors.cardWhite}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor.withOpacity(0.04),
          blurRadius: 32,
          offset: const Offset(0, 24),
          spreadRadius: -12,
        ),
      ],
    );

class _StatsRow extends StatelessWidget {
  final String distance, pace, time;
  const _StatsRow(
      {required this.distance, required this.pace, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          _StatItem(label: 'DISTANCE', value: distance, unit: 'KM'),
          _StatItem(label: 'PACE', value: pace, unit: '/KM'),
          _StatItem(label: 'TIME', value: time, unit: ''),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value, unit;
  const _StatItem(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(unit,
                    style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final int likes, comments;
  const _ActionRow({required this.likes, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
      child: Row(
        children: [
          Icon(Icons.favorite_border_rounded,
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text('$likes',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary)),
          const SizedBox(width: 24),
          Icon(Icons.chat_bubble_outline_rounded,
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text('$comments',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary)),
          const Spacer(),
          Icon(Icons.ios_share_rounded,
              size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _PhotoFeedCard extends StatelessWidget {
  final String title, distance, pace, time;
  final int likes, comments;
  const _PhotoFeedCard(
      {required this.title,
      required this.distance,
      required this.pace,
      required this.time,
      required this.likes,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 256,
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5A8A7A), Color(0xFF2C5F52)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.directions_run_rounded,
                      size: 80, color: Colors.white24),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0x881A1C1C), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(title,
                      style: GoogleFonts.lexend(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                          color: Colors.white,
                          height: 1.2)),
                ),
              ]),
            ),
          ),
          _StatsRow(distance: distance, pace: pace, time: time),
          _ActionRow(likes: likes, comments: comments),
        ],
      ),
    );
  }
}

class _MapFeedCard extends StatelessWidget {
  final String distance, pace, time;
  final int likes, comments;
  const _MapFeedCard(
      {required this.distance,
      required this.pace,
      required this.time,
      required this.likes,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(color: AppColors.cardMapBg),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 342,
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                Container(color: const Color(0xFF3A6B6B)),
                CustomPaint(painter: _MapGridPainter()),
                CustomPaint(painter: _RoutePainter()),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text('SAFTTIE SAFE WORK',
                        style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: Colors.white70)),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Column(
              children: [
                _StatsRow(distance: distance, pace: pace, time: time),
                _ActionRow(likes: likes, comments: comments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (double y = 0; y < size.height; y += 28)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    for (double x = 0; x < size.width; x += 28)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }

  @override
  bool shouldRepaint(_MapGridPainter _) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width * 0.5;
    final cy = size.height * 0.48;
    final r = size.width * 0.30;

    final startX = cx - r * 0.9;
    final startY = cy;
    final endX = cx - r * 0.8;
    final endY = cy + r * 0.3;

    final path = Path()
      ..moveTo(startX, startY)
      ..lineTo(cx - r * 0.3, cy - r * 0.6)
      ..lineTo(cx + r * 0.6, cy - r * 0.4)
      ..lineTo(cx + r * 0.7, cy + r * 0.5)
      ..lineTo(cx - r * 0.1, cy + r * 0.7)
      ..lineTo(endX, endY);

    canvas.drawPath(path, routePaint);

    canvas.drawCircle(
        Offset(startX, startY),
        5,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill);
    canvas.drawCircle(
        Offset(endX, endY),
        7,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    canvas.drawCircle(
        Offset(endX, endY),
        7,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawCircle(
        Offset(endX, endY),
        4,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_RoutePainter _) => false;
}

class _BentoFeedCard extends StatelessWidget {
  const _BentoFeedCard();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'AVG HEART RATE',
            value: '164',
            unit: 'BPM',
            progress: 0.75,
            progressColor: AppColors.heartRateRed,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricCard(
            label: 'ELEVATION',
            value: '210',
            unit: 'M',
            progress: 0.25,
            progressColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label, value, unit;
  final double progress;
  final Color progressColor;
  const _MetricCard(
      {required this.label,
      required this.value,
      required this.unit,
      required this.progress,
      required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: GoogleFonts.lexend(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary)),
              const SizedBox(width: 4),
              Text(unit,
                  style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary.withOpacity(0.5))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
