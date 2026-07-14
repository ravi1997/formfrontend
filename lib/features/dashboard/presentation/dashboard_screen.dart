import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/core/state/auth_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigate(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  Widget _quickAction(
    BuildContext context,
    String label,
    IconData icon,
    String routeName,
  ) {
    return FilledButton.icon(
      onPressed: () => _navigate(context, routeName),
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _gatewayCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> actions,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.pureWhite),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(subtitle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: actions),
          ],
        ),
      ),
    );
  }

  Widget _gatewayBody(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final cards = <Widget>[
      _gatewayCard(
        context: context,
        title: 'Workspace home',
        subtitle: 'Return to the main workspace surfaces and recent work.',
        icon: Icons.space_dashboard_outlined,
        actions: [
          _quickAction(
            context,
            'Search',
            Icons.search_outlined,
            RouteNames.search,
          ),
          _quickAction(
            context,
            'Projects',
            Icons.folder_outlined,
            RouteNames.projects,
          ),
          _quickAction(
            context,
            'Forms',
            Icons.list_alt_outlined,
            RouteNames.forms,
          ),
        ],
      ),
      _gatewayCard(
        context: context,
        title: 'Navigation shell',
        subtitle:
            'Move between the core content-building surfaces without losing context.',
        icon: Icons.route_outlined,
        actions: [
          _quickAction(
            context,
            'Sections',
            Icons.view_week_outlined,
            RouteNames.sections,
          ),
          _quickAction(
            context,
            'Questions',
            Icons.help_outline,
            RouteNames.questions,
          ),
          _quickAction(
            context,
            'Choices',
            Icons.circle_outlined,
            RouteNames.choices,
          ),
        ],
      ),
      _gatewayCard(
        context: context,
        title: 'Integrations hub',
        subtitle:
            'Enter workflow, schema, and related integration flows from one place.',
        icon: Icons.integration_instructions_outlined,
        actions: [
          _quickAction(
            context,
            'Workflow',
            Icons.merge_type_outlined,
            RouteNames.workflow,
          ),
          _quickAction(
            context,
            'Schema',
            Icons.schema_outlined,
            RouteNames.schema,
          ),
          _quickAction(
            context,
            'Metrics',
            Icons.analytics_outlined,
            RouteNames.metrics,
          ),
        ],
      ),
      _gatewayCard(
        context: context,
        title: 'Operations panel',
        subtitle:
            'Open health, readiness, admin, audit, rate limit, and session tools.',
        icon: Icons.admin_panel_settings_outlined,
        actions: [
          _quickAction(
            context,
            'Health',
            Icons.health_and_safety_outlined,
            RouteNames.health,
          ),
          _quickAction(
            context,
            'Readiness',
            Icons.check_circle_outline,
            RouteNames.readiness,
          ),
          _quickAction(
            context,
            'Admin',
            Icons.admin_panel_settings_outlined,
            RouteNames.admin,
          ),
          _quickAction(
            context,
            'Audit logs',
            Icons.note_alt_outlined,
            RouteNames.adminAuditLogs,
          ),
        ],
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Gateway', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 12),
        Text(
          'Workspace home, navigation shell, integrations hub, and operations panel in one place.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Chip(label: Text('Workspace home')),
            Chip(label: Text('Navigation shell')),
            Chip(label: Text('Integrations hub')),
            Chip(label: Text('Operations panel')),
          ],
        ),
        const SizedBox(height: 24),
        if (isMobile)
          ...cards.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: card,
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 16) / 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: cards
                    .map((card) => SizedBox(width: cardWidth, child: card))
                    .toList(),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        leading: isMobile
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.space8,
                vertical: context.space4,
              ),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: context.borderSm,
              ),
              child: Text(
                'A.D.I.Y.O.G.I',
                style: context.uiMicro.copyWith(
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            if (!isMobile) ...[
              SizedBox(height: context.space4),
              Text(
                'Gateway home',
                overflow: TextOverflow.ellipsis,
                style: context.uiMicro.copyWith(color: AppColors.greyBody),
              ),
            ],
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.space16),
            child: Center(
              child: Text(
                'Gateway: Active',
                style: context.uiMicro.copyWith(color: AppColors.slateMid),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => context.read<AuthStateNotifier>().logout(),
          ),
          SizedBox(width: context.space8),
        ],
      ),
      body: isMobile
          ? _gatewayBody(context)
          : PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: const ValueKey<String>('gateway-home'),
                child: _gatewayBody(context),
              ),
            ),
      drawer: isMobile
          ? null
          : Drawer(
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.space_dashboard_outlined),
                      title: const Text('Workspace home'),
                      onTap: () => _navigate(context, RouteNames.main),
                    ),
                    ListTile(
                      leading: const Icon(Icons.search_outlined),
                      title: const Text('Global search'),
                      onTap: () => _navigate(context, RouteNames.search),
                    ),
                    ListTile(
                      leading: const Icon(Icons.folder_outlined),
                      title: const Text('Projects'),
                      onTap: () => _navigate(context, RouteNames.projects),
                    ),
                    ListTile(
                      leading: const Icon(Icons.list_alt_outlined),
                      title: const Text('Forms'),
                      onTap: () => _navigate(context, RouteNames.forms),
                    ),
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings_outlined),
                      title: const Text('Admin'),
                      onTap: () => _navigate(context, RouteNames.admin),
                    ),
                    ListTile(
                      leading: const Icon(Icons.health_and_safety_outlined),
                      title: const Text('Health'),
                      onTap: () => _navigate(context, RouteNames.health),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Logout'),
                      onTap: () => context.read<AuthStateNotifier>().logout(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
