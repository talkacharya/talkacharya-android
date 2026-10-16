import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../shared/widgets/app_snack.dart';
import '../../data/support_messages.dart';

/// The topics a customer can pick, in the order they are offered.
const kSupportTopics = [
  'payment',
  'consultation',
  'order',
  'account',
  'app',
  'other',
];

String supportTopicLabel(AppLocalizations l, String key) => switch (key) {
  'payment' => l.supTopicPayment,
  'consultation' => l.supTopicConsultation,
  'order' => l.supTopicOrder,
  'account' => l.supTopicAccount,
  'app' => l.supTopicApp,
  _ => l.supTopicOther,
};

IconData supportTopicIcon(String key) => switch (key) {
  'payment' => Icons.account_balance_wallet_rounded,
  'consultation' => Icons.forum_rounded,
  'order' => Icons.shopping_bag_rounded,
  'account' => Icons.person_rounded,
  'app' => Icons.bug_report_rounded,
  _ => Icons.help_rounded,
};

/// `/support` — write to the TalkAcharya team, and read their replies.
class SupportMessagesPage extends StatefulWidget {
  const SupportMessagesPage({this.topic, super.key});

  /// A topic to open on (from a link), else none picked.
  final String? topic;

  @override
  State<SupportMessagesPage> createState() => _SupportMessagesPageState();
}

class _SupportMessagesPageState extends State<SupportMessagesPage> {
  final _api = getIt<SupportMessagesApi>();
  final _message = TextEditingController();
  late String? _topic = kSupportTopics.contains(widget.topic)
      ? widget.topic
      : null;
  SupportInbox? _inbox;
  String? _error;
  bool _sending = false;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _load();
    PackageInfo.fromPlatform()
        .then((info) => _version = '${info.version}+${info.buildNumber}')
        .catchError((_) => _version);
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final inbox = await _api.inbox();
      if (!mounted) return;
      setState(() {
        _inbox = inbox;
        _error = null;
      });
      // Opening the page reads the replies: clears the badge on Home.
      if (inbox.unreadReplies > 0) await _api.markSeen().catchError((_) {});
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  Future<void> _send() async {
    final l = context.l10n;
    final text = _message.text.trim();
    if (_topic == null) {
      AppSnack.showTop(context, l.supPickTopic, type: SnackType.info);
      return;
    }
    if (text.length < 10) {
      AppSnack.showTop(context, l.supTooShort, type: SnackType.info);
      return;
    }
    setState(() => _sending = true);
    try {
      await _api.send(topic: _topic!, message: text, appVersion: _version);
      _message.clear();
      if (mounted) FocusScope.of(context).unfocus();
      await _load();
      if (mounted) {
        AppSnack.showTop(context, l.supSent, type: SnackType.success);
      }
    } catch (e) {
      if (mounted) {
        AppSnack.showTop(context, friendlyError(e), type: SnackType.error);
      }
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final messages = _inbox?.messages ?? const <SupportMessage>[];
    return Scaffold(
      backgroundColor: brand.canvas,
      appBar: AppBar(title: Text(l.supTitle)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const _Hero(),
            const SizedBox(height: 18),
            Text(
              l.supWhatAbout,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.15,
              children: [
                for (final t in kSupportTopics)
                  _TopicTile(
                    label: supportTopicLabel(l, t),
                    icon: supportTopicIcon(t),
                    selected: _topic == t,
                    onTap: () => setState(() => _topic = t),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: brand.hairline),
              ),
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _message,
                    minLines: 4,
                    maxLines: 8,
                    maxLength: 4000,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l.supHint,
                      border: InputBorder.none,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.supReplyPromise,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _SendButton(busy: _sending, onTap: _send),
                    ],
                  ),
                ],
              ),
            ),
            if (_error != null && _inbox == null) ...[
              const SizedBox(height: 24),
              ErrorView(message: _error!, onRetry: _load),
            ],
            if (messages.isNotEmpty) ...[
              const SizedBox(height: 26),
              Text(
                l.supEarlier,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              for (final m in messages) _MessageCard(message: m),
            ],
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          const Positioned.fill(child: CosmicBackdrop()),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.supHeroTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: brand.onCosmic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.supHeroBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: brand.onCosmicMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                const HueIcon(
                  hue: AstroPalette.money,
                  icon: Icons.support_agent_rounded,
                  size: 54,
                  iconSize: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    const hue = AstroPalette.career;
    return Pressable(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: selected ? hue.tint(0.14) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? hue.end : brand.hairline,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: selected ? hue.end : brand.inkMuted),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.busy, required this.onTap});

  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Pressable(
      child: Material(
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: BrandColors.goldGradient),
          ),
          child: InkWell(
            onTap: busy ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: Color(0xFF3A1703),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l.supSend,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: const Color(0xFF3A1703),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});
  final SupportMessage message;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final m = message;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final when = m.createdAt == null
        ? ''
        : DateFormat.yMMMd(locale).add_jm().format(m.createdAt!);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: m.unreadReply ? brand.gold : brand.hairline,
          width: m.unreadReply ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(supportTopicIcon(m.topic), size: 16, color: brand.inkMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${supportTopicLabel(l, m.topic)} · $when',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (m.answered ? brand.online : brand.gold).withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  m.answered ? l.supAnswered : l.supWaiting,
                  style: TextStyle(
                    color: m.answered ? brand.online : brand.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(m.message, style: theme.textTheme.bodyMedium),
          if (m.answered) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: brand.tint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.supTeamReplied,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: brand.onTint,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m.reply,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: brand.onTint,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
