import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/profile_api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _headline = TextEditingController();
  final _bio = TextEditingController();
  final _years = TextEditingController();
  String? _banner;
  bool _loading = true;
  bool _saving = false;
  bool _bannerBusy = false;

  @override
  void initState() {
    super.initState();
    getIt<ProfileApi>()
        .profile()
        .then((p) {
          if (!mounted) return;
          setState(() {
            _headline.text = p.headline;
            _bio.text = p.bio;
            _years.text = '${p.yearsExperience}';
            _banner = p.banner;
            _loading = false;
          });
        })
        .catchError((Object _) {
          if (mounted) setState(() => _loading = false);
        });
  }

  @override
  void dispose() {
    _headline.dispose();
    _bio.dispose();
    _years.dispose();
    super.dispose();
  }

  Future<void> _pickBanner() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _bannerBusy = true);
    try {
      final p = await getIt<ProfileApi>().uploadBanner(picked.path);
      if (!mounted) return;
      setState(() => _banner = p.banner);
      messenger.showSnackBar(const SnackBar(content: Text('Cover updated')));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Couldn't upload the cover. Use a JPG/PNG under 5 MB."),
        ),
      );
    } finally {
      if (mounted) setState(() => _bannerBusy = false);
    }
  }

  Future<void> _removeBanner() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _bannerBusy = true);
    try {
      final p = await getIt<ProfileApi>().removeBanner();
      if (mounted) setState(() => _banner = p.banner);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _bannerBusy = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await getIt<ProfileApi>().update(
        headline: _headline.text.trim(),
        bio: _bio.text.trim(),
        yearsExperience: int.tryParse(_years.text.trim()),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _BannerEditor(
                  url: _banner,
                  busy: _bannerBusy,
                  onPick: _bannerBusy ? null : _pickBanner,
                  onRemove: (_bannerBusy || _banner == null)
                      ? null
                      : _removeBanner,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _headline,
                  decoration: const InputDecoration(labelText: 'Headline'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bio,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'About you'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _years,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Years of experience',
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: const Text('Save'),
                ),
              ],
            ),
    );
  }
}

/// Cover image preview (3:1, like the customer app header) with change / remove.
class _BannerEditor extends StatelessWidget {
  const _BannerEditor({
    required this.url,
    required this.busy,
    required this.onPick,
    required this.onRemove,
  });

  final String? url;
  final bool busy;
  final VoidCallback? onPick;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final u = url;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: scheme.onPrimary,
              size: 30,
            ),
            const SizedBox(height: 6),
            Text(
              'Add a cover image',
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile cover',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Shown behind your photo on your public profile. Wide images work best '
          '(about 3:1, e.g. 1500×500).',
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 3,
            child: Material(
              color: scheme.surfaceContainerHighest,
              child: InkWell(
                onTap: onPick,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (u != null)
                      Image.network(
                        u,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => placeholder,
                      )
                    else
                      placeholder,
                    if (busy)
                      const ColoredBox(
                        color: Color(0x66000000),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.photo_library_outlined, size: 18),
              label: Text(u == null ? 'Choose image' : 'Change cover'),
            ),
            const SizedBox(width: 8),
            if (u != null)
              TextButton.icon(
                onPressed: onRemove,
                style: TextButton.styleFrom(foregroundColor: scheme.error),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Remove'),
              ),
          ],
        ),
      ],
    );
  }
}
