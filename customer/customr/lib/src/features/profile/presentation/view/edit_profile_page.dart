import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../auth/data/models/auth_user.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/profile_api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const _genders = ['male', 'female', 'other', 'undisclosed'];

  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  String _gender = 'undisclosed';
  DateTime? _dob;
  bool _saving = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    // Seed every field from the signed-in user, so what's saved is what shows.
    final u = context.read<AuthBloc>().state.user;
    _name = TextEditingController(text: u?.fullName ?? '');
    _email = TextEditingController(text: u?.email ?? '');
    _gender = _genders.contains(u?.gender) ? u!.gender : 'undisclosed';
    _dob = DateTime.tryParse(u?.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final authBloc = context.read<AuthBloc>();
    final l = context.l10n;
    setState(() => _uploading = true);
    try {
      final user = await getIt<ProfileApi>().uploadAvatar(picked.path);
      authBloc.add(AuthLoggedIn(user));
      messenger.showSnackBar(SnackBar(content: Text(l.editPhotoUpdated)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.editProfileSaveError)));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final authBloc = context.read<AuthBloc>();
    final navigator = Navigator.of(context);
    final l = context.l10n;
    try {
      final user = await getIt<ProfileApi>().updateProfile(
        fullName: _name.text.trim(),
        // Empty string clears a previously saved email.
        email: _email.text.trim(),
        gender: _gender,
        dateOfBirth: _dob == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_dob!),
      );
      authBloc.add(AuthLoggedIn(user));
      messenger.showSnackBar(SnackBar(content: Text(l.editProfileSaved)));
      if (mounted) navigator.pop();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.editProfileSaveError)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final user = context.select((AuthBloc b) => b.state.user);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: Form(
          key: _form,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 236,
                backgroundColor: brand.cosmicStart,
                surfaceTintColor: Colors.transparent,
                foregroundColor: Colors.white,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: Text(
                  l.profileEditProfile,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                flexibleSpace: Stack(
                  fit: StackFit.expand,
                  children: [
                    const CosmicBackdrop(),
                    FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 52, bottom: 16),
                          child: _AvatarHeader(
                            user: user,
                            uploading: _uploading,
                            onPick: _uploading ? null : _pickAvatar,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 140),
                sliver: SliverList.list(
                  children: [
                    _Section(
                      title: l.editSectionPersonal,
                      children: [
                        _FieldLabel(l.editFullName),
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            context,
                            icon: Icons.person_outline_rounded,
                            hue: AstroPalette.career,
                          ),
                          validator: (v) => (v == null || v.trim().length < 2)
                              ? l.editNameInvalid
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l.editGender),
                        _GenderChips(
                          value: _gender,
                          onChanged: (g) => setState(() => _gender = g),
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l.editDateOfBirth),
                        _TapField(
                          icon: Icons.cake_outlined,
                          hue: AstroPalette.love,
                          text: _dob == null
                              ? l.editDobPlaceholder
                              : DateFormat.yMMMMd(locale).format(_dob!),
                          placeholder: _dob == null,
                          onTap: _pickDob,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Section(
                      title: l.editSectionContact,
                      children: [
                        _FieldLabel(l.editEmail),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          decoration: _inputDecoration(
                            context,
                            icon: Icons.mail_outline_rounded,
                            hue: AstroPalette.air,
                            suffix: (user?.email.isNotEmpty ?? false)
                                ? l.editEmailUnverified
                                : null,
                          ),
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return null;
                            return RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(t)
                                ? null
                                : l.editEmailInvalid;
                          },
                        ),
                        const SizedBox(height: 14),
                        _FieldLabel(l.editPhone),
                        _TapField(
                          icon: Icons.phone_iphone_rounded,
                          hue: AstroPalette.health,
                          text: user?.phone ?? '—',
                          trailing: Icons.lock_outline_rounded,
                          helper: l.editPhoneLocked,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _SaveButton(
                      label: l.commonSave,
                      busy: _saving,
                      onPressed: _saving ? null : _save,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required IconData icon,
    required AstroHue hue,
    String? suffix,
  }) {
    final brand = context.brand;
    final radius = BorderRadius.circular(12);
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      prefixIcon: Icon(icon, size: 19, color: hue.end),
      suffixText: suffix,
      suffixStyle: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: AstroPalette.money.end),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: brand.hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: brand.hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: hue.end, width: 1.4),
      ),
    );
  }
}

// --- header -------------------------------------------------------------------------

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader({
    required this.user,
    required this.uploading,
    required this.onPick,
  });

  final AuthUser? user;
  final bool uploading;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final avatar = user?.avatar;
    final name = user?.shortName ?? '';
    final initial = Center(
      child: Text(
        name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFFFFB02E),
                    Color(0xFFFF5C8A),
                    Color(0xFF7B3FE4),
                    Color(0xFF5EC8FF),
                    Color(0xFFFFB02E),
                  ],
                ),
              ),
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AstroPalette.career.end,
                  border: Border.all(color: brand.cosmicStart, width: 2.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: uploading
                    ? const Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : (avatar != null && avatar.isNotEmpty)
                    ? Image.network(
                        avatar,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => initial,
                      )
                    : initial,
              ),
            ),
            Positioned(
              right: -2,
              bottom: 2,
              child: Semantics(
                button: true,
                label: l.editChangePhoto,
                child: Pressable(
                  child: Material(
                    shape: CircleBorder(
                      side: BorderSide(color: brand.cosmicStart, width: 2.5),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Ink(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: BrandColors.goldGradient,
                        ),
                      ),
                      child: InkWell(
                        onTap: onPick,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.photo_camera_rounded,
                            size: 17,
                            color: Color(0xFF3A1703),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name.isEmpty ? '—' : name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: onPick,
          style: TextButton.styleFrom(
            foregroundColor: AstroPalette.money.start,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(l.editChangePhoto),
        ),
      ],
    );
  }
}

// --- building blocks -----------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: brand.inkMuted,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: brand.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 6),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

/// A read-only / tap-to-pick field styled like the text inputs.
class _TapField extends StatelessWidget {
  const _TapField({
    required this.icon,
    required this.hue,
    required this.text,
    this.onTap,
    this.placeholder = false,
    this.trailing,
    this.helper,
  });

  final IconData icon;
  final AstroHue hue;
  final String text;
  final VoidCallback? onTap;
  final bool placeholder;
  final IconData? trailing;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: onTap == null
              ? brand.hairline.withValues(alpha: 0.35)
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, size: 19, color: hue.end),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: placeholder ? brand.inkMuted : null,
                      ),
                    ),
                  ),
                  Icon(
                    trailing ??
                        (onTap == null
                            ? Icons.lock_outline_rounded
                            : Icons.calendar_month_rounded),
                    size: 18,
                    color: brand.inkMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
            child: Text(
              helper!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.inkMuted,
              ),
            ),
          ),
      ],
    );
  }
}

class _GenderChips extends StatelessWidget {
  const _GenderChips({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = <(String, String, IconData, AstroHue)>[
      ('male', l.editGenderMale, Icons.male_rounded, AstroPalette.career),
      ('female', l.editGenderFemale, Icons.female_rounded, AstroPalette.love),
      ('other', l.editGenderOther, Icons.transgender_rounded, AstroPalette.air),
      (
        'undisclosed',
        l.editGenderUndisclosed,
        Icons.visibility_off_outlined,
        AstroPalette.water,
      ),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (key, label, icon, hue) in options)
          _Chip(
            label: label,
            icon: icon,
            hue: hue,
            selected: key == value,
            onTap: () => onChanged(key),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.hue,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final AstroHue hue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? hue.tint(0.14) : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? hue.end : brand.hairline,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : icon,
                size: 16,
                color: selected ? hue.end : brand.inkMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? hue.end : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Pressable(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: BrandColors.goldGradient.last.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            height: 52,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: BrandColors.goldGradient),
            ),
            child: InkWell(
              onTap: onPressed,
              child: Center(
                child: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF3A1703),
                        ),
                      )
                    : Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF3A1703),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
