import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Reports its child's laid-out height whenever it changes, after the frame
/// (so the listener can safely setState). A collapsing header uses it to learn
/// how tall its expanded content really is, instead of guessing a number that
/// breaks at another font size, width or language.
class ReportHeight extends SingleChildRenderObjectWidget {
  const ReportHeight({
    required this.onChanged,
    required super.child,
    super.key,
  });

  final ValueChanged<double> onChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderReportHeight(onChanged);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) =>
      (renderObject as _RenderReportHeight).onChanged = onChanged;
}

class _RenderReportHeight extends RenderProxyBox {
  _RenderReportHeight(this.onChanged);

  ValueChanged<double> onChanged;
  double? _last;

  @override
  void performLayout() {
    super.performLayout();
    final h = size.height;
    if (h == _last) return;
    _last = h;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChanged(h));
  }
}
