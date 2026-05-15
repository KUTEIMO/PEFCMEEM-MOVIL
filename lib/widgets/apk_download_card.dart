import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/branding_strings.dart';
import '../theme/app_theme.dart';

/// Bloque de descarga de la APK Android (web / landing).
class ApkDownloadCard extends StatelessWidget {
  const ApkDownloadCard({super.key, this.compact = false});

  final bool compact;

  static final _apkUri = Uri.parse(BrandingStrings.apkDownloadUrl);

  Future<void> _open(BuildContext context) async {
    final ok = await launchUrl(
      _apkUri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_self',
    );
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace de descarga.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: compact ? 0 : 2,
      color: scheme.surfaceContainerHighest.withValues(alpha: compact ? 0.35 : 0.55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.android_rounded, color: AppColors.reward, size: compact ? 28 : 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'App Android',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 6 : 8),
            Text(
              'Descarga EULER en tu celular. Usa la misma cuenta que en la web.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
            ),
            SizedBox(height: compact ? 12 : 16),
            FilledButton.icon(
              onPressed: () => _open(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.reward,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Descargar APK'),
            ),
          ],
        ),
      ),
    );
  }
}
