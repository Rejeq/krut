import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/core/models/auth_session.dart';
import 'package:track_dev/providers/sources_provider.dart';

/// Shows a modal bottom sheet for selecting the preferred authentication method.
void showAuthSettings(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return _AuthSettingsSheet(ref: ref);
    },
  );
}

class _AuthSettingsSheet extends StatefulWidget {
  final WidgetRef ref;

  const _AuthSettingsSheet({required this.ref});

  @override
  State<_AuthSettingsSheet> createState() => _AuthSettingsSheetState();
}

class _AuthSettingsSheetState extends State<_AuthSettingsSheet> {
  AuthMethod _selected = AuthMethod.basic;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    final prefs = widget.ref.read(preferencesRepositoryProvider);
    final saved = await prefs.getAuthMethod();
    if (mounted) {
      setState(() {
        _selected = saved;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final prefs = widget.ref.read(preferencesRepositoryProvider);
    await prefs.setAuthMethod(_selected);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.security, size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Способ авторизации',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Выберите предпочтительный метод аутентификации для подключения к Redmine:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else ...[
            RadioListTile<AuthMethod>(
              title: const Text('Логин и пароль (Basic Auth)'),
              subtitle: const Text('Стандартный вход'),
              value: AuthMethod.basic,
              groupValue: _selected,
              onChanged: (value) {
                if (value != null) setState(() => _selected = value);
              },
            ),
            RadioListTile<AuthMethod>(
              title: const Text('Ключ API (API Token)'),
              subtitle: const Text('Для повышенной безопасности'),
              value: AuthMethod.apiKey,
              groupValue: _selected,
              onChanged: (value) {
                if (value != null) setState(() => _selected = value);
              },
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _loading ? null : _save,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
