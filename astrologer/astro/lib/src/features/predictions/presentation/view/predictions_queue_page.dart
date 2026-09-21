import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/predictions_repository.dart';
import '../cubit/predictions_queue_cubit.dart';

class PredictionsQueuePage extends StatelessWidget {
  const PredictionsQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PredictionsQueueCubit(getIt<PredictionsRepository>())..load(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction queue')),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<PredictionsQueueCubit>().load(force: true),
        child: BlocBuilder<PredictionsQueueCubit, AsyncValue<List<Prediction>>>(
          builder: (context, state) => state.when(
            idle: _loading,
            loading: _loading,
            error: (m) => ListView(
              children: [
                ErrorView(
                  message: m,
                  onRetry: () =>
                      context.read<PredictionsQueueCubit>().load(force: true),
                ),
              ],
            ),
            data: (items) => items.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 80),
                      EmptyState(
                        icon: Icons.inbox_outlined,
                        title: 'Nothing waiting',
                        message: 'New prediction requests will show up here.',
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        _QueueTile(prediction: items[i]),
                  ),
          ),
        ),
      ),
    );
  }

  static Widget _loading() => const Center(child: CircularProgressIndicator());
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.prediction});
  final Prediction prediction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = prediction.claimedAt != null;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            PredictionLabels.areaIcon(prediction.area),
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          '${PredictionLabels.areaTitle(prediction.area)} · '
          '${PredictionLabels.periodTitle(prediction.period)}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
        subtitle: Text(
          [
            prediction.profileLabel,
            if (prediction.language != 'en') 'lang: ${prediction.language}',
            if (prediction.dueAt != null)
              'due ${prediction.dueAt!.day}/${prediction.dueAt!.month}',
          ].where((s) => s.isNotEmpty).join(' · '),
        ),
        trailing: mine
            ? const Chip(label: Text('Yours'))
            : const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push('/predictions/${prediction.id}'),
      ),
    );
  }
}
