import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/di/service_locator.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../core/util/async_value.dart';
import '../../data/kundali_repository.dart';
import '../cubit/kundali_cubit.dart';
import '../../../../shared/widgets/language_quick_button.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The client's full kundali during a consultation — charts + planets + dasha
/// + yogas + bhava + advanced strengths. All read consultation-scoped from the
/// birth profile the customer shared.
part 'tabs/charts_tab.dart';
part 'tabs/planets_tab.dart';
part 'tabs/dasha_tab.dart';
part 'tabs/yogas_tab.dart';
part 'tabs/doshas_tab.dart';
part 'tabs/overview_tab.dart';
part 'tabs/sade_tab.dart';
part 'tabs/numerology_tab.dart';
part 'tabs/remedies_tab.dart';
part 'tabs/bhava_tab.dart';
part 'tabs/advanced_tab.dart';

class ConsultationKundaliPage extends StatelessWidget {
  const ConsultationKundaliPage({
    required this.consultationId,
    this.clientName,
    this.profileId,
    this.standalone = false,
    super.key,
  });

  /// The consultation — or, when [standalone], one of the astrologer's own
  /// saved charts.
  final String consultationId;

  /// A chart the astrologer cast themselves, outside any consultation.
  final bool standalone;
  final String? clientName;

  /// One of the people the customer shared; null = the primary profile.
  final String? profileId;

  @override
  Widget build(BuildContext context) {
    final lang = context.select(
      (AuthBloc b) => b.state.user?.preferredLanguage,
    );
    return BlocProvider(
      key: ValueKey(lang),
      create: (_) => KundaliCubit(
        repo: standalone
            ? getIt<KundaliRepository>().forOwnCharts()
            : getIt<KundaliRepository>().forProfile(profileId),
        consultationId: consultationId,
      )..loadOverview(),
      child: _View(
        consultationId: consultationId,
        clientName: clientName,
        standalone: standalone,
      ),
    );
  }
}

const _essentials = <String>[
  'd1',
  'moon',
  'd9',
  'd10',
  'd7',
  'bhava_chalit',
  'transit',
];

class _View extends StatelessWidget {
  const _View({
    required this.consultationId,
    this.clientName,
    this.standalone = false,
  });
  final String consultationId;
  final bool standalone;
  final String? clientName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            clientName == null
                ? l.kundaliTitle
                : l.kundaliTitleFor(clientName!),
          ),
          actions: const [LanguageQuickButton()],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l.kundaliTabCharts),
              Tab(text: l.kundaliTabPlanets),
              Tab(text: l.kundaliTabDasha),
              Tab(text: l.kundaliTabYogas),
              Tab(text: l.kundaliTabDoshas),
              Tab(text: l.kundaliTabOverview),
              Tab(text: l.kundaliTabRemedies),
              Tab(text: l.kundaliTabBhava),
              Tab(text: l.kundaliTabGochar),
              Tab(text: l.kundaliTabNumbers),
              Tab(text: l.kundaliTabAdvanced),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ChartsTab(consultationId: consultationId, standalone: standalone),
            const _PlanetsTab(),
            const _DashaTab(),
            const _YogasTab(),
            const _DoshasTab(),
            const _OverviewTab(),
            const _RemediesTab(),
            const _BhavaTab(),
            const _SadeSatiTab(),
            const _NumerologyTab(),
            const _AdvancedTab(),
          ],
        ),
      ),
    );
  }
}

/// Renders one [AsyncValue] slice: spinner while first loading, [ErrorView] on
/// failure with nothing cached, else the data.
class _Slice<T> extends StatelessWidget {
  const _Slice({
    required this.slice,
    required this.onRetry,
    required this.builder,
  });
  final AsyncValue<T> slice;
  final VoidCallback onRetry;
  final Widget Function(T value) builder;

  @override
  Widget build(BuildContext context) => slice.when(
    idle: () => const Center(child: CircularProgressIndicator()),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (m) => ErrorView(message: m, onRetry: onRetry),
    data: builder,
  );
}
