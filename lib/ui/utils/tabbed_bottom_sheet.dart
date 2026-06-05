import 'package:flutter/material.dart';

typedef AppSheetTab = ({Tab tab, Widget content});

Future<T?> showTabbedBottomSheet<T>({
  required BuildContext context,
  required List<AppSheetTab> tabs,
  double maxHeightFactor = 0.85,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    useSafeArea: true,
    builder: (context) {
      return AppTabbedBottomSheet(
        tabs: tabs,
        maxHeightFactor: maxHeightFactor,
      );
    },
  );
}

class AppTabbedBottomSheet extends StatelessWidget {
  const AppTabbedBottomSheet({
    super.key,
    required this.tabs,
    this.maxHeightFactor = 0.85,
  });

  final List<AppSheetTab> tabs;
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    assert(tabs.isNotEmpty, 'tabs must not be empty');

    final height = MediaQuery.sizeOf(context).height * maxHeightFactor;

    return DefaultTabController(
      length: tabs.length,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const _SheetHandle(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                isScrollable: tabs.length > 3,
                tabs: tabs.map((e) => e.tab).toList(),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: tabs.map((e) => e.content).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

enum TriStateFilterValue {
  disabled,
  enabled,
  excluded,
}

TriStateFilterValue nextTriStateFilterValue(TriStateFilterValue value) {
  switch (value) {
    case TriStateFilterValue.disabled:
      return TriStateFilterValue.enabled;
    case TriStateFilterValue.enabled:
      return TriStateFilterValue.excluded;
    case TriStateFilterValue.excluded:
      return TriStateFilterValue.disabled;
  }
}

class TriStateFilterEntry extends StatelessWidget {
  const TriStateFilterEntry({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final TriStateFilterValue value;
  final ValueChanged<TriStateFilterValue> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = switch (value) {
      TriStateFilterValue.disabled => Icons.check_box_outline_blank,
      TriStateFilterValue.enabled => Icons.check_box,
      TriStateFilterValue.excluded => Icons.indeterminate_check_box,
    };

    return InkWell(
      onTap: () => onChanged(nextTriStateFilterValue(value)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: subtitle == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Default checkbox entry for filters.
class FilterCheckboxEntry extends StatelessWidget {
  const FilterCheckboxEntry({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class FilterTextEntry extends StatelessWidget {
  const FilterTextEntry({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.onSubmitted,
    this.onChanged,
  });

  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

enum SortDirection {
  ascending,
  descending,
}

class SortOptionEntry extends StatelessWidget {
  const SortOptionEntry({
    super.key,
    required this.title,
    required this.direction,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final SortDirection direction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leadingIcon = direction == SortDirection.ascending
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: selected
          ? Icon(leadingIcon, size: 20, color: theme.colorScheme.primary)
          : const SizedBox(width: 20),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: selected ? const Icon(Icons.check, size: 18) : null,
    );
  }
}

class DisplayRadioEntry<T> extends StatelessWidget {
  const DisplayRadioEntry({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // ignore: deprecated_member_use
      onChanged: onChanged,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
    );
  }
}

