import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class SwipeToSeal extends StatefulWidget {
  final VoidCallback onSwiped;
  final bool enabled;

  const SwipeToSeal({
    super.key,
    required this.onSwiped,
    this.enabled = true,
  });

  @override
  State<SwipeToSeal> createState() => _SwipeToSealState();
}

class _SwipeToSealState extends State<SwipeToSeal>
    with SingleTickerProviderStateMixin {
  static const double _height = 64;
  static const double _thumbSize = 52;
  static const double _padding = 6;

  double _position = 0;
  bool _completed = false;

  late final AnimationController _snapController;
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  double _maxPosition(double trackWidth) =>
      trackWidth - _thumbSize - _padding * 2;

  void _onDragUpdate(DragUpdateDetails details, double maxPos) {
    if (_completed || !widget.enabled) return;
    setState(() {
      _position = (_position + details.delta.dx).clamp(0, maxPos);
    });
  }

  void _onDragEnd(DragEndDetails details, double maxPos) {
    if (_completed || !widget.enabled) return;
    if (_position >= maxPos * 0.85) {
      setState(() {
        _position = maxPos;
        _completed = true;
      });
      HapticFeedback.heavyImpact();
      _playSound();
      widget.onSwiped();
    } else {
      _snapBack();
    }
  }

  void _snapBack() {
    final startPos = _position;
    _snapController.reset();

    void listener() {
      if (mounted) {
        setState(() {
          _position = startPos * (1 - _snapController.value);
        });
      }
    }

    _snapController.addListener(listener);
    _snapController
        .animateTo(1, curve: Curves.easeOut)
        .then((_) => _snapController.removeListener(listener));
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/seal.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final maxPos = _maxPosition(trackWidth);
        final progress = maxPos > 0 ? (_position / maxPos).clamp(0.0, 1.0) : 0.0;

        return GestureDetector(
          onHorizontalDragUpdate: (d) => _onDragUpdate(d, maxPos),
          onHorizontalDragEnd: (d) => _onDragEnd(d, maxPos),
          child: Container(
            height: _height,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(_height / 2),
            ),
            child: Stack(
              children: [
                // Заливка прогресса
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_height / 2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: Duration.zero,
                        width: (_position + _thumbSize + _padding * 2)
                            .clamp(0, trackWidth),
                        decoration: BoxDecoration(
                          color: (_completed ? Colors.green : AppTheme.primary)
                              .withValues(alpha: 0.25 + progress * 0.15),
                          borderRadius: BorderRadius.circular(_height / 2),
                        ),
                      ),
                    ),
                  ),
                ),

                // Текст подсказки
                Center(
                  child: Opacity(
                    opacity: (1 - progress * 2).clamp(0.0, 1.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Свайп чтобы запечатать',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppTheme.textSecondary.withValues(alpha: 0.4),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                // Ползунок
                Positioned(
                  left: _padding + _position,
                  top: _padding,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: _completed ? Colors.green : AppTheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                      _completed ? Icons.check : Icons.lock,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
