import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final Widget destination;

  const ActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.destination,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  double _scale = 1.0;
  bool _pressed = false;
  bool _navigating = false;

  void _startNavigation(BuildContext context) {
    if (_navigating) return;
    _navigating = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => widget.destination),
    ).then((_) {
      if (mounted) setState(() => _navigating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 40),
          curve: Curves.easeOut,
          transform: (() {
            // stronger perspective + scale + lift for a pronounced 3D pop
            final m = Matrix4.diagonal3Values(_scale, _scale, 1.0);
            m.setEntry(3, 2, 0.002); // stronger perspective
            m.setTranslationRaw(0, _pressed ? -12.0 : 0.0, 0);
            return m;
          })(),
          child: AnimatedPhysicalModel(
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeOut,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
            elevation: _pressed ? 52.0 : 8.0,
            color: Colors.transparent,
            shadowColor: Colors.black.withAlpha(
                _pressed ? (0.50 * 255).round() : (0.16 * 255).round()),
            child: Ink(
              decoration: BoxDecoration(gradient: widget.gradient),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _startNavigation(context),
                onTapDown: (_) => setState(() {
                  _pressed = true;
                  _scale = 0.88;
                }),
                onTapUp: (_) => setState(() {
                  _pressed = false;
                  _scale = 1.0;
                }),
                onTapCancel: () => setState(() {
                  _pressed = false;
                  _scale = 1.0;
                }),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTapDown: (_) => _startNavigation(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.12 * 255).round()),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(widget.icon, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
