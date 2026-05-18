import 'package:flutter/material.dart';

class CustomPlayButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPressed;
  final double size;

  const CustomPlayButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
    this.size = 64.0,
  });

  @override
  State<CustomPlayButton> createState() => _CustomPlayButtonState();
}

class _CustomPlayButtonState extends State<CustomPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handlePress,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1DB954),
                Color(0xFF1aa34a),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1DB954).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: AlwaysStoppedAnimation(widget.isPlaying ? 1.0 : 0.0),
              color: Colors.white,
              size: widget.size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF282828),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: size,
            color: color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4.0,
        activeTrackColor: activeColor ?? const Color(0xFF1DB954),
        inactiveTrackColor: inactiveColor ?? const Color(0xFF3E3E42),
        thumbColor: activeColor ?? const Color(0xFF1DB954),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 6.0,
          elevation: 0,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 12.0,
        ),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: activeColor ?? const Color(0xFF1DB954),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final List<Color>? gradient;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height ?? 56,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient ?? [const Color(0xFF1DB954), const Color(0xFF1aa34a)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
