import 'package:flutter/material.dart';

/// Centres page content and limits its width so the same screen looks right on
/// small phones, large phones, tablets and the web. Padding grows with width.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = 640,
    this.scroll = true,
  });

  final Widget child;
  final double maxWidth;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth >= 600 ? 24.0 : 16.0;
        final content = Padding(padding: EdgeInsets.all(padding), child: child);
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SizedBox(
              width: double.infinity,
              child: scroll ? SingleChildScrollView(child: content) : content,
            ),
          ),
        );
      },
    );
  }
}
