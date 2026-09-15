import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../availability/presentation/cubit/availability_cubit.dart';
import '../../data/profile_api.dart';

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

typedef _Slot = ({TimeOfDay start, TimeOfDay end});

class WorkingHoursPage extends StatefulWidget {
  const WorkingHoursPage({super.key});
  @override
  State<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends State<WorkingHoursPage> {
  final _hours = <int, _Slot>{};
  final _channels = <String>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await getIt<ProfileApi>().workingHours();
      for (final r in rows) {
        final wd = (r['weekday'] as num).toInt();
        _hours[wd] = (
          start: _parse(r['start_time'] as String),
          end: _parse(r['end_time'] as String),
        );
      }
      final av = AvailabilityCubit(getIt());
      await av.load();
      _channels.addAll(av.state.channels);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  TimeOfDay _parse(String s) {
    final p = s.split(':');
    return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    final rows = _hours.entries
        .map(
          (e) => {
            'weekday': e.key,
            'start_time': _fmt(e.value.start),
            'end_time': _fmt(e.value.end),
          },
        )
        .toList();
    try {
      await getIt<ProfileApi>().setWorkingHours(rows);
      await AvailabilityCubit(getIt()).update(channels: _channels.toList());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  void _toggleDay(int wd, bool on) {
    setState(() {
      if (on) {
        _hours[wd] = (
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 21, minute: 0),
        );
      } else {
        _hours.remove(wd);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Availability & hours'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Channels you accept',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  spacing: 8,
                  children: ['chat', 'voice', 'video'].map((ch) {
                    return FilterChip(
                      label: Text(ch),
                      selected: _channels.contains(ch),
                      onSelected: (v) => setState(
                        () => v ? _channels.add(ch) : _channels.remove(ch),
                      ),
                    );
                  }).toList(),
                ),
                const Divider(height: 32),
                Text(
                  'Working hours',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (var wd = 0; wd < 7; wd++)
                  SwitchListTile(
                    title: Text(_days[wd]),
                    subtitle: _hours[wd] == null
                        ? const Text('Off')
                        : Text(
                            '${_fmt(_hours[wd]!.start)} – ${_fmt(_hours[wd]!.end)}',
                          ),
                    value: _hours[wd] != null,
                    onChanged: (v) => _toggleDay(wd, v),
                  ),
              ],
            ),
    );
  }
}
