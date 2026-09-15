import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/kundali/data/kundali_repository.dart';
import 'package:astro_kundali/astro_kundali.dart';
import 'package:customr/src/features/kundali/presentation/cubit/kundali_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements KundaliRepository {}

VargaChart _vc(String type) => VargaChart(chartType: type);

void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  blocTest<KundaliCubit, KundaliState>(
    'loadChart caches per type and does not refetch a loaded chart',
    build: () {
      when(
        () => repo.vargaChart('p1', 'd9'),
      ).thenAnswer((_) async => _vc('d9'));
      return KundaliCubit(repo: repo, profileId: 'p1');
    },
    act: (c) async {
      await c.loadChart('d9');
      await c.loadChart('d9'); // second call is a no-op
    },
    verify: (c) {
      verify(() => repo.vargaChart('p1', 'd9')).called(1);
      expect(c.state.charts['d9']!.status, AsyncStatus.data);
      expect(c.state.charts['d9']!.value!.chartType, 'd9');
    },
  );

  blocTest<KundaliCubit, KundaliState>(
    'transit always refetches',
    build: () {
      when(
        () => repo.vargaChart('p1', 'transit'),
      ).thenAnswer((_) async => _vc('transit'));
      return KundaliCubit(repo: repo, profileId: 'p1');
    },
    act: (c) async {
      await c.loadChart('transit');
      await c.loadChart('transit');
    },
    verify: (_) => verify(() => repo.vargaChart('p1', 'transit')).called(2),
  );

  blocTest<KundaliCubit, KundaliState>(
    'loadChart surfaces an error without dropping the slice',
    build: () {
      when(() => repo.vargaChart('p1', 'd10')).thenThrow(Exception('boom'));
      return KundaliCubit(repo: repo, profileId: 'p1');
    },
    act: (c) => c.loadChart('d10'),
    verify: (c) => expect(c.state.charts['d10']!.status, AsyncStatus.error),
  );

  blocTest<KundaliCubit, KundaliState>(
    'loadChartTypes fills the chartTypes slice',
    build: () {
      when(() => repo.chartTypes('p1')).thenAnswer(
        (_) async => const [
          ChartTypeInfo(type: 'd1', name: 'Rasi', varga: 1),
          ChartTypeInfo(type: 'transit', name: 'Transit (Gochar)'),
        ],
      );
      return KundaliCubit(repo: repo, profileId: 'p1');
    },
    act: (c) => c.loadChartTypes(),
    verify: (c) {
      expect(c.state.chartTypes.status, AsyncStatus.data);
      expect(c.state.chartTypes.value!.length, 2);
    },
  );

  blocTest<KundaliCubit, KundaliState>(
    'reloadForLanguage re-fetches only what was loaded',
    build: () {
      when(
        () => repo.numerology('p1'),
      ).thenAnswer((_) async => const NumerologyReport());
      when(
        () => repo.vargaChart('p1', 'd9'),
      ).thenAnswer((_) async => _vc('d9'));
      return KundaliCubit(repo: repo, profileId: 'p1');
    },
    act: (c) async {
      await c.loadNumerology();
      await c.loadChart('d9');
      await c.reloadForLanguage();
    },
    verify: (c) {
      verify(() => repo.numerology('p1')).called(2);
      verify(() => repo.vargaChart('p1', 'd9')).called(2);
      verifyNever(() => repo.overview(any()));
      expect(c.state.numerology.status, AsyncStatus.data);
    },
  );
}
