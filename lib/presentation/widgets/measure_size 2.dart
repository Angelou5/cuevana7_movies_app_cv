import 'package:flutter/widgets.dart';

/// Mide el tamaño real de su hijo después de pintarlo y notifica el cambio.
/// Útil para layouts donde un elemento debe superponerse a otro sin saber
/// de antemano su alto exacto.
class MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;
  const MeasureSize({super.key, required this.onChange, required this.child});

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = (context.findRenderObject() as RenderBox?)?.size;
      if (size != null && size != _oldSize) {
        _oldSize = size;
        widget.onChange(size);
      }
    });
    return widget.child;
  }
}
