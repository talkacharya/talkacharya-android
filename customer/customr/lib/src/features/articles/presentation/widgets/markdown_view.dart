import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/deeplink/deep_link_parser.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';

/// Renders an article's markdown on the app's own type scale and colours.
///
/// Parsed with `package:markdown` (GitHub-flavoured) and mapped to plain
/// widgets, so headings, quotes and lists look like the rest of the app rather
/// than a web page. Links into the app (`talkacharya://…` or our https domain)
/// open in-app; everything else goes to the browser.
class MarkdownView extends StatefulWidget {
  const MarkdownView({required this.data, this.accent, super.key});

  final String data;

  /// Bullet, quote bar and link colour. Defaults to the career hue.
  final AstroHue? accent;

  @override
  State<MarkdownView> createState() => _MarkdownViewState();
}

class _MarkdownViewState extends State<MarkdownView> {
  late List<md.Node> _nodes = _parse(widget.data);
  final _recognizers = <GestureRecognizer>[];

  static List<md.Node> _parse(String data) => md.Document(
    extensionSet: md.ExtensionSet.gitHubFlavored,
    encodeHtml: false,
  ).parseLines(data.replaceAll('\r\n', '\n').split('\n'));

  @override
  void didUpdateWidget(covariant MarkdownView old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) _nodes = _parse(widget.data);
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();
    final r = _Renderer(
      context: context,
      accent: widget.accent ?? AstroPalette.career,
      onLink: _openLink,
      recognizers: _recognizers,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: r.blocks(_nodes),
    );
  }

  Future<void> _openLink(String href) async {
    final inApp = locationForRaw(href);
    final uri = Uri.tryParse(href);
    final ours =
        uri != null &&
        (uri.scheme == 'talkacharya' || uri.host.endsWith('talkacharya.com'));
    if (inApp != null && ours) {
      if (mounted) await context.push(inApp);
      return;
    }
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Renderer {
  _Renderer({
    required this.context,
    required this.accent,
    required this.onLink,
    required this.recognizers,
  }) : theme = Theme.of(context),
       brand = context.brand;

  final BuildContext context;
  final AstroHue accent;
  final void Function(String href) onLink;
  final List<GestureRecognizer> recognizers;
  final ThemeData theme;
  final BrandColors brand;

  static const _blockTags = {
    'p',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'ul',
    'ol',
    'blockquote',
    'pre',
    'hr',
    'table',
  };

  TextStyle get _body => (theme.textTheme.bodyLarge ?? const TextStyle())
      .copyWith(height: 1.65, color: brand.ink);

  List<Widget> blocks(List<md.Node> nodes) => [
    for (final n in nodes) ?_block(n),
  ];

  Widget? _block(md.Node node) {
    if (node is md.Text) {
      final text = node.text.trim();
      if (text.isEmpty) return null;
      return _paragraph([node]);
    }
    if (node is! md.Element) return null;
    final children = node.children ?? const <md.Node>[];

    switch (node.tag) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        final level = int.parse(node.tag.substring(1));
        final style = switch (level) {
          1 => theme.textTheme.headlineSmall,
          2 => theme.textTheme.titleLarge,
          3 => theme.textTheme.titleMedium,
          _ => theme.textTheme.titleSmall,
        };
        return Padding(
          padding: EdgeInsets.only(top: level <= 2 ? 22 : 16, bottom: 8),
          child: Text.rich(
            TextSpan(
              children: _inline(
                children,
                (style ?? const TextStyle()).copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: brand.ink,
                ),
              ),
            ),
          ),
        );

      case 'p':
        final onlyImage =
            children.length == 1 &&
            children.first is md.Element &&
            (children.first as md.Element).tag == 'img';
        if (onlyImage) return _image(children.first as md.Element);
        return _paragraph(children);

      case 'ul':
      case 'ol':
        return _list(node, ordered: node.tag == 'ol');

      case 'blockquote':
        return Container(
          margin: const EdgeInsets.only(bottom: 14, top: 2),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          decoration: BoxDecoration(
            color: accent.tint(0.08),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
            border: Border(left: BorderSide(color: accent.end, width: 3)),
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontStyle: FontStyle.italic),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: blocks(children),
            ),
          ),
        );

      case 'pre':
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: brand.sectionBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: brand.hairline),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              node.textContent.trimRight(),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        );

      case 'hr':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Divider(color: brand.hairline, height: 1),
        );

      case 'table':
        return _table(node);

      default:
        // Unknown block (html etc.) — keep its text rather than drop it.
        final text = node.textContent.trim();
        return text.isEmpty ? null : _paragraph([md.Text(text)]);
    }
  }

  Widget _paragraph(List<md.Node> children) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text.rich(TextSpan(children: _inline(children, _body))),
  );

  Widget _list(md.Element list, {required bool ordered}) {
    final items = (list.children ?? const <md.Node>[])
        .whereType<md.Element>()
        .where((e) => e.tag == 'li')
        .toList();
    final start = int.tryParse(list.attributes['start'] ?? '') ?? 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 26,
                    child: ordered
                        ? Text(
                            '${start + i}.',
                            style: _body.copyWith(
                              color: accent.end,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10, left: 4),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: accent.linear(),
                              ),
                            ),
                          ),
                  ),
                  Expanded(child: _listItem(items[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _listItem(md.Element li) {
    final children = li.children ?? const <md.Node>[];
    final hasBlocks = children.any(
      (c) => c is md.Element && _blockTags.contains(c.tag),
    );
    if (!hasBlocks) {
      return Text.rich(TextSpan(children: _inline(children, _body)));
    }
    // Loose list items wrap their text in <p>; drop the paragraph gap inside.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final c in children)
          if (c is md.Element && c.tag == 'p')
            Text.rich(TextSpan(children: _inline(c.children ?? [], _body)))
          else
            ?_block(c),
      ],
    );
  }

  Widget _image(md.Element img) {
    final src = img.attributes['src'] ?? '';
    final alt = img.attributes['alt'] ?? '';
    if (src.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: src,
              fit: BoxFit.cover,
              placeholder: (_, _) => AspectRatio(
                aspectRatio: 16 / 9,
                child: ColoredBox(color: brand.shimmerBase),
              ),
              errorWidget: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          if (alt.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                alt,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _table(md.Element table) {
    final rows = <md.Element>[];
    void collect(md.Node n) {
      if (n is! md.Element) return;
      if (n.tag == 'tr') {
        rows.add(n);
      } else {
        (n.children ?? const <md.Node>[]).forEach(collect);
      }
    }

    collect(table);
    if (rows.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(
            color: brand.hairline,
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            for (var r = 0; r < rows.length; r++)
              TableRow(
                decoration: r == 0
                    ? BoxDecoration(color: accent.tint(0.1))
                    : null,
                children: [
                  for (final cell
                      in (rows[r].children ?? const <md.Node>[])
                          .whereType<md.Element>())
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: _inline(
                            cell.children ?? const [],
                            _body.copyWith(
                              fontSize: 14,
                              height: 1.4,
                              fontWeight: cell.tag == 'th'
                                  ? FontWeight.w700
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _inline(List<md.Node> nodes, TextStyle style) {
    final spans = <InlineSpan>[];
    for (final n in nodes) {
      if (n is md.Text) {
        spans.add(TextSpan(text: n.text, style: style));
        continue;
      }
      if (n is! md.Element) continue;
      final kids = n.children ?? const <md.Node>[];
      switch (n.tag) {
        case 'strong':
          spans.addAll(
            _inline(kids, style.copyWith(fontWeight: FontWeight.w700)),
          );
        case 'em':
          spans.addAll(
            _inline(kids, style.copyWith(fontStyle: FontStyle.italic)),
          );
        case 'del':
          spans.addAll(
            _inline(
              kids,
              style.copyWith(decoration: TextDecoration.lineThrough),
            ),
          );
        case 'code':
          spans.add(
            TextSpan(
              text: n.textContent,
              style: style.copyWith(
                fontFamily: 'monospace',
                fontSize: (style.fontSize ?? 16) * 0.9,
                backgroundColor: brand.sectionBg,
              ),
            ),
          );
        case 'br':
          spans.add(TextSpan(text: '\n', style: style));
        case 'a':
          final href = n.attributes['href'] ?? '';
          final recognizer = TapGestureRecognizer()..onTap = () => onLink(href);
          recognizers.add(recognizer);
          // Hit-testing lands on leaf spans and a parent's recognizer isn't
          // inherited, so the link is one flat span carrying its own tap.
          spans.add(
            TextSpan(
              text: n.textContent,
              style: style.copyWith(
                color: accent.end,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: accent.end.withValues(alpha: 0.4),
              ),
              recognizer: recognizer,
            ),
          );
        case 'img':
          spans.add(
            WidgetSpan(
              child: SizedBox(width: double.infinity, child: _image(n)),
            ),
          );
        default:
          spans.addAll(_inline(kids, style));
      }
    }
    return spans;
  }
}
