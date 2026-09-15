import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/predictions_repository.dart';
import '../cubit/prediction_work_cubit.dart';

class PredictionWorkPage extends StatelessWidget {
  const PredictionWorkPage({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PredictionWorkCubit(repo: getIt<PredictionsRepository>(), id: id)
            ..load(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  Timer? _debounce;
  bool _hydrated = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _hydrate(Prediction p) {
    if (_hydrated) return;
    _hydrated = true;
    _title.text = p.title;
    _body.text = p.body;
  }

  void _autosave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      context.read<PredictionWorkCubit>().saveDraft(
        title: _title.text,
        body: _body.text,
      );
    });
  }

  int get _words =>
      _body.text.trim().isEmpty ? 0 : _body.text.trim().split(RegExp(r'\s+')).length;

  Future<void> _deliver(int minWords) async {
    if (_words < minWords) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Needs at least $minWords words ($_words so far).')),
      );
      return;
    }
    final ok = await context.read<PredictionWorkCubit>().deliver(
      title: _title.text,
      body: _body.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivered.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write forecast'),
        actions: [
          BlocBuilder<PredictionWorkCubit, PredictionWorkState>(
            builder: (context, state) {
              final p = state.prediction.value;
              if (p == null) return const SizedBox.shrink();
              if (p.status.isDelivered) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text('Delivered'),
                  ),
                );
              }
              if (p.claimedAt == null) {
                return TextButton(
                  onPressed: () => context.read<PredictionWorkCubit>().claim(),
                  child: const Text('Claim'),
                );
              }
              return TextButton(
                onPressed: () => context.read<PredictionWorkCubit>().release(),
                child: const Text('Release'),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<PredictionWorkCubit, PredictionWorkState>(
        listenWhen: (a, b) => a.error != b.error && b.error != null,
        listener: (context, state) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error!))),
        builder: (context, state) => state.prediction.when(
          idle: _loading,
          loading: _loading,
          error: (m) => ErrorView(
            message: m,
            onRetry: () => context.read<PredictionWorkCubit>().load(),
          ),
          data: (p) {
            _hydrate(p);
            final canEdit = p.claimedAt != null && !p.status.isDelivered;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                _Meta(prediction: p),
                const SizedBox(height: 12),
                _BriefCard(brief: p.factorBrief),
                const SizedBox(height: 16),
                TextField(
                  controller: _title,
                  enabled: canEdit,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _autosave(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _body,
                  enabled: canEdit,
                  minLines: 10,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Forecast',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {});
                    _autosave();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$_words words',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const Spacer(),
                    if (state.saving)
                      const Text('Saving…')
                    else if (state.savedAt != null)
                      const Text('Saved'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<PredictionWorkCubit, PredictionWorkState>(
        builder: (context, state) {
          final p = state.prediction.value;
          if (p == null || p.status.isDelivered || p.claimedAt == null) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton(
                onPressed: state.saving ? null : () => _deliver(120),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Deliver forecast'),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _loading() =>
      const Center(child: CircularProgressIndicator());
}

class _Meta extends StatelessWidget {
  const _Meta({required this.prediction});
  final Prediction prediction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(PredictionLabels.areaIcon(prediction.area), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${PredictionLabels.areaTitle(prediction.area)} · '
            '${PredictionLabels.periodTitle(prediction.period)}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
        Text(
          '${prediction.profileLabel} · ${prediction.language}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.brief});
  final Map<String, dynamic>? brief;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: const Text(
            'Chart brief',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
          ),
          children: [PredictionBriefView(brief: brief)],
        ),
      ),
    );
  }
}
