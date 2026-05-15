import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../core/branding_strings.dart';
import '../../core/models/user_role.dart';
import '../../core/routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// About: borrador de proyecto (Markdown) + créditos y marca.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final Future<String> _markdownFuture;

  @override
  void initState() {
    super.initState();
    _markdownFuture = rootBundle.loadString(BrandingStrings.assetProjectDocument);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Volver',
          onPressed: () => _goBack(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              BrandingStrings.acronym,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              BrandingStrings.appTagline,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<String>(
        future: _markdownFuture,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('No se pudo cargar el documento.\n${snap.error}', textAlign: TextAlign.center),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            cacheExtent: 800,
            children: [
              RepaintBoundary(child: _CreditsCard(scheme: scheme)),
              const SizedBox(height: 14),
              Center(
                child: SvgPicture.asset(
                  BrandingStrings.assetMarkSvg,
                  height: 44,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(height: 16),
              MarkdownBody(
                data: snap.data!,
                selectable: true,
                shrinkWrap: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  h1: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  h2: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  h3: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  p: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.48),
                  blockSpacing: 10,
                  listIndent: 20,
                ),
              ),
              const SizedBox(height: 20),
              if (kIsWeb)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new_rounded, size: 20),
                    label: const Text('Abrir versión HTML (about.html)'),
                    onPressed: () async {
                      final uri = Uri.base.resolve('about.html');
                      final ok = await launchUrl(uri, webOnlyWindowName: '_blank');
                      if (context.mounted && !ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se pudo abrir la ventana. Revisa el bloqueador de ventanas emergentes o usa el enlace superior de la página.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              FilledButton(
                onPressed: () => _goBack(context),
                child: const Text('Volver'),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _goBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    context.go(AppRoutes.auth);
    return;
  }
  final role = context.app.userRole;
  context.go(AppRoutes.homeForRole(role == UserRole.teacher));
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equipo',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(BrandingStrings.author1, style: Theme.of(context).textTheme.bodyMedium),
          Text(BrandingStrings.author2, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            BrandingStrings.authorProgram,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          Text(
            BrandingStrings.authorMeta,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
