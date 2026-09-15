import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/birth_profiles_api.dart';
import '../../data/models/birth_profile.dart';
import '../../data/models/place.dart';
import '../bloc/birth_profiles_cubit.dart';
import 'widgets/place_search_field.dart';

const _relations = [
  ('self', 'Myself'),
  ('spouse', 'Spouse / partner'),
  ('child', 'Child'),
  ('parent', 'Parent'),
  ('sibling', 'Sibling'),
  ('friend', 'Friend'),
  ('other', 'Someone else'),
];
const _genders = [('male', 'Male'), ('female', 'Female'), ('other', 'Other')];

/// Birth-profile form — creates a new profile, or edits an existing one when
/// [editId] is given. Pops with the saved [BirthProfile] on success.
///
/// [activate] makes a newly-created profile the active one (true from the login
/// flow); it is ignored in edit mode.
class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({this.activate = true, this.editId, super.key});

  /// When set, the form edits this profile instead of creating a new one.
  const CreateProfilePage.edit({required String profileId, super.key})
    : editId = profileId,
      activate = false;

  final bool activate;
  final String? editId;

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _label = TextEditingController();
  final _fullName = TextEditingController();

  String _relation = 'self';
  String _gender = 'male';
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _timeUnknown = false;
  String _timeAccuracy = 'exact';
  Place? _place;
  String _initialPlaceName = '';
  bool _submitting = false;

  /// Edit mode only: the form waits for the existing profile before it renders.
  bool _hydrated = false;

  bool get _isEdit => widget.editId != null;

  @override
  void initState() {
    super.initState();
    if (!_isEdit) _label.text = 'Myself';
    _label.addListener(() => setState(() {}));
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _hydrate());
    }
  }

  @override
  void dispose() {
    _label.dispose();
    _fullName.dispose();
    super.dispose();
  }

  void _hydrate() {
    final cubit = context.read<BirthProfilesCubit>();
    final existing = cubit.state.profileById(widget.editId);
    if (existing != null) {
      _applyExisting(existing);
      return;
    }
    // Not in memory (deep link / cold start) — load, then retry once.
    cubit.load(force: true).then((_) {
      if (mounted) _applyExisting(cubit.state.profileById(widget.editId));
    });
  }

  void _applyExisting(BirthProfile? p) {
    if (p == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile not found')));
        context.pop();
      }
      return;
    }
    setState(() {
      _label.text = p.label;
      _fullName.text = p.fullName;
      _relation = _relations.any((r) => r.$1 == p.relation)
          ? p.relation
          : 'other';
      _gender = _genders.any((g) => g.$1 == p.gender) ? p.gender : 'other';
      _birthDate = DateTime.tryParse(p.birthDate);
      final t = p.birthTime;
      if (t == null || t.isEmpty || p.birthTimeAccuracy == 'unknown') {
        _timeUnknown = true;
        _birthTime = null;
      } else {
        final parts = t.split(':');
        _birthTime = parts.length >= 2
            ? TimeOfDay(
                hour: int.tryParse(parts[0]) ?? 0,
                minute: int.tryParse(parts[1]) ?? 0,
              )
            : null;
        _timeUnknown = _birthTime == null;
        _timeAccuracy = p.birthTimeAccuracy == 'approximate'
            ? 'approximate'
            : 'exact';
      }
      _initialPlaceName = p.birthPlaceName;
      _hydrated = true;
    });
  }

  bool get _canSubmit {
    final base = _label.text.trim().isNotEmpty && _birthDate != null;
    return _isEdit ? base : (base && _place != null);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Date of birth',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 6, minute: 0),
      helpText: 'Time of birth',
    );
    if (picked != null) {
      setState(() {
        _birthTime = picked;
        _timeUnknown = false;
      });
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String? _fmtTime() => _timeUnknown || _birthTime == null
      ? null
      : '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}:00';

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;
    setState(() => _submitting = true);
    final cubit = context.read<BirthProfilesCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final nav = GoRouter.of(context);
    try {
      if (_isEdit) {
        final input = EditBirthProfile(
          label: _label.text.trim(),
          relation: _relation,
          gender: _gender,
          fullName: _fullName.text.trim(),
          birthDate: _fmtDate(_birthDate!),
          birthTime: _fmtTime(),
          clearBirthTime: _timeUnknown,
          birthTimeAccuracy: _timeAccuracy,
          placeId: _place?.placeId, // null ⇒ keep the current place / coords
        );
        final updated = await cubit.update(widget.editId!, input);
        if (mounted) nav.pop(updated);
        return;
      }
      final input = NewBirthProfile(
        label: _label.text.trim(),
        relation: _relation,
        gender: _gender,
        fullName: _fullName.text.trim(),
        birthDate: _fmtDate(_birthDate!),
        birthTime: _fmtTime(),
        birthTimeAccuracy: _timeAccuracy,
        placeId: _place!.placeId,
      );
      final profile = await cubit.create(input, activate: widget.activate);
      if (mounted) nav.pop(profile);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        messenger.showSnackBar(
          SnackBar(content: Text('Could not save profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEdit ? 'Edit birth profile' : 'New birth profile';
    if (_isEdit && !_hydrated) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final df = _birthDate;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const _Label('Who is this profile for?'),
            Wrap(
              spacing: 8,
              children: [
                for (final (value, text) in _relations)
                  ChoiceChip(
                    label: Text(text),
                    selected: _relation == value,
                    onSelected: (_) => setState(() {
                      _relation = value;
                      if (_label.text.trim().isEmpty ||
                          _relations.any((r) => r.$2 == _label.text)) {
                        _label.text = text;
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _label,
              decoration: const InputDecoration(
                labelText: 'Profile name',
                hintText: 'e.g. Myself, Mom, Ravi',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _fullName,
              decoration: const InputDecoration(
                labelText: 'Full name (optional)',
              ),
            ),
            const SizedBox(height: 16),
            const _Label('Gender'),
            Wrap(
              spacing: 8,
              children: [
                for (final (value, text) in _genders)
                  ChoiceChip(
                    label: Text(text),
                    selected: _gender == value,
                    onSelected: (_) => setState(() => _gender = value),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const _Label('Date of birth'),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_rounded, size: 18),
              label: Text(
                df == null
                    ? 'Select date'
                    : '${df.day.toString().padLeft(2, '0')}/${df.month.toString().padLeft(2, '0')}/${df.year}',
              ),
            ),
            const SizedBox(height: 16),
            const _Label('Time of birth'),
            Text(
              'A precise time gives a more accurate chart — the ascendant can '
              'change sign within a minute. Not sure? You can skip it.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _timeUnknown ? null : _pickTime,
                    icon: const Icon(Icons.schedule_rounded, size: 18),
                    label: Text(
                      _timeUnknown || _birthTime == null
                          ? 'Select time'
                          : _birthTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _timeUnknown,
              onChanged: (v) => setState(() {
                _timeUnknown = v ?? false;
                if (_timeUnknown) _birthTime = null;
              }),
              title: const Text("I don't know the birth time"),
            ),
            if (!_timeUnknown && _birthTime != null) ...[
              const SizedBox(height: 4),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'exact', label: Text('Exact')),
                  ButtonSegment(value: 'approximate', label: Text('Approx.')),
                ],
                selected: {_timeAccuracy},
                onSelectionChanged: (s) =>
                    setState(() => _timeAccuracy = s.first),
              ),
            ],
            const SizedBox(height: 20),
            PlaceSearchField(
              key: ValueKey('place:$_initialPlaceName'),
              initialText: _initialPlaceName,
              onSelected: (p) => setState(() => _place = p),
            ),
            if (_isEdit)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Leave the birth place as is to keep the saved coordinates.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _canSubmit && !_submitting ? _submit : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text(_isEdit ? 'Save changes' : 'Save profile'),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
