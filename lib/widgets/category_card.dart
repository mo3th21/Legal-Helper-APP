import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qanon/theme/app_theme.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    this.onTap,
  });
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  double _scale = 1.0;
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) => setState(() {
        _scale = 0.97;
        _pressed = true;
      });

  void _handleTapUp(TapUpDetails _) => setState(() {
        _scale = 1.0;
        _pressed = false;
      });

  void _handleTapCancel() => setState(() {
        _scale = 1.0;
        _pressed = false;
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.translucent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            transform: Matrix4.diagonal3Values(_scale, _scale, 1.0),
        padding: const EdgeInsets.all(0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _pressed
                  ? [
                      BoxShadow(
                            color: Colors.black.withAlpha((0.18 * 255).round()),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          widget.icon,
                          size: 28,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                if (_pressed)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.03 * 255).round()),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
