import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../data/models/product.dart';
import 'store_ui.dart';

/// Renders a product's `input_schema` (sankalp names, gotra, ring size, date of
/// birth …). Per-participant fields repeat once per person in the package.
class ProductInputsForm extends StatefulWidget {
  const ProductInputsForm({
    required this.schema,
    required this.values,
    required this.errors,
    required this.onChanged,
    this.participants = 1,
    super.key,
  });

  final List<InputField> schema;
  final Map<String, dynamic> values;
  final Map<String, String> errors;
  final void Function(String key, Object? value) onChanged;
  final int participants;

  @override
  State<ProductInputsForm> createState() => _ProductInputsFormState();
}

class _ProductInputsFormState extends State<ProductInputsForm> {
  final _controllers = <String, TextEditingController>{};

  TextEditingController _controller(String id, String initial) =>
      _controllers.putIfAbsent(id, () => TextEditingController(text: initial));

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final f in widget.schema) ...[
          if (f.perParticipant)
            ..._participantFields(context, f)
          else
            _field(context, f),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  List<Widget> _participantFields(BuildContext context, InputField f) {
    final l = context.l10n;
    final raw = widget.values[f.key];
    final list = raw is List ? raw.map((e) => '$e').toList() : <String>[];
    final error = widget.errors[f.key];
    return [
      Text(
        f.label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 6),
      for (var i = 0; i < widget.participants; i++) ...[
        TextField(
          controller: _controller(
            '${f.key}#$i',
            i < list.length ? list[i] : '',
          ),
          textCapitalization: TextCapitalization.words,
          maxLength: f.maxLength,
          decoration: InputDecoration(
            labelText: widget.participants > 1
                ? l.storePersonN(i + 1)
                : f.label,
            counterText: '',
            errorText: i == 0 ? error : null,
          ),
          onChanged: (text) {
            final next = List<String>.generate(
              widget.participants,
              (j) => j < list.length ? list[j] : '',
            );
            next[i] = text;
            list
              ..clear()
              ..addAll(next);
            widget.onChanged(f.key, next);
          },
        ),
        const SizedBox(height: 8),
      ],
    ];
  }

  Widget _field(BuildContext context, InputField f) {
    final error = widget.errors[f.key];
    final label = f.required ? '${f.label} *' : f.label;
    final value = widget.values[f.key];
    switch (f.kind) {
      case InputKind.choice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in f.choices)
                  ChoiceChip(
                    label: Text(c.label),
                    selected: '$value' == c.value,
                    onSelected: (_) => widget.onChanged(f.key, c.value),
                  ),
              ],
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      case InputKind.date:
        final picked = DateTime.tryParse('${value ?? ''}');
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final now = DateTime.now();
            final date = await showDatePicker(
              context: context,
              initialDate: picked ?? DateTime(now.year - 25),
              firstDate: DateTime(1900),
              lastDate: DateTime(now.year + 2),
            );
            if (date != null) {
              widget.onChanged(
                f.key,
                '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              );
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              errorText: error,
              suffixIcon: const Icon(Icons.calendar_month_rounded),
            ),
            child: Text(
              picked == null ? '' : storeDate(context, picked),
              style: TextStyle(color: context.brand.ink),
            ),
          ),
        );
      case InputKind.textarea:
      case InputKind.text:
      case InputKind.number:
      case InputKind.phone:
      case InputKind.email:
        return TextField(
          controller: _controller(f.key, value == null ? '' : '$value'),
          maxLines: f.kind == InputKind.textarea ? 3 : 1,
          maxLength: f.maxLength,
          keyboardType: switch (f.kind) {
            InputKind.number => const TextInputType.numberWithOptions(
              decimal: true,
            ),
            InputKind.phone => TextInputType.phone,
            InputKind.email => TextInputType.emailAddress,
            InputKind.textarea => TextInputType.multiline,
            _ => TextInputType.text,
          },
          inputFormatters: f.kind == InputKind.number
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
          textCapitalization: f.kind == InputKind.text
              ? TextCapitalization.words
              : TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: label,
            hintText: f.hint.isEmpty ? null : f.hint,
            errorText: error,
            counterText: '',
          ),
          onChanged: (text) => widget.onChanged(f.key, text),
        );
    }
  }
}
