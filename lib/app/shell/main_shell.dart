import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/state/auth_state.dart';
import 'package:formfrontend/core/state/current_user_state.dart';
import 'package:formfrontend/features/admin/presentation/organisation_management_page.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/features/admin/presentation/admin_dashboard_page.dart';
import 'package:formfrontend/features/admin/presentation/admin_audit_logs_page.dart';
import 'package:formfrontend/features/admin/presentation/admin_config_health_page.dart';
import 'package:formfrontend/features/admin/presentation/admin_rate_limits_page.dart';
import 'package:formfrontend/features/admin/presentation/admin_user_sessions_page.dart';
import 'package:formfrontend/features/dashboard/presentation/dashboard_screen.dart';
import 'package:formfrontend/features/choices/presentation/choices_list_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_test_page.dart';
import 'package:formfrontend/features/forms/presentation/forms_list_page.dart';
import 'package:formfrontend/features/projects/presentation/projects_list_page.dart';
import 'package:formfrontend/features/responses/presentation/action_executions_page.dart';
import 'package:formfrontend/features/responses/presentation/response_submission_page.dart';
import 'package:formfrontend/features/sections/presentation/sections_list_page.dart';
import 'package:formfrontend/features/questions/presentation/questions_list_page.dart';
import 'package:formfrontend/features/system/presentation/health_page.dart';
import 'package:formfrontend/features/system/presentation/metrics_page.dart';
import 'package:formfrontend/features/system/presentation/readiness_page.dart';
import 'package:formfrontend/features/system/presentation/schema_echo_page.dart';
import 'package:formfrontend/features/ui_templates/presentation/layout_templates_page.dart';
import 'package:formfrontend/features/ui_templates/presentation/theme_templates_page.dart';
import 'package:formfrontend/features/workflows/presentation/workflow_actions_page.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    DashboardScreen.activeLayerNotifier.addListener(_onLayerChanged);
  }

  @override
  void dispose() {
    DashboardScreen.activeLayerNotifier.removeListener(_onLayerChanged);
    super.dispose();
  }

  void _onLayerChanged() {
    setState(() {});
  }

  late final List<Widget> _pages = const [
    DashboardScreen(),
    ProjectsListPage(),
    FormsListPage(),
    SectionsListPage(),
    QuestionsListPage(),
    ChoicesListPage(),
    ConditionTestPage(),
    ResponseSubmissionPage(),
    ActionExecutionsPage(),
    WorkflowActionsPage(),
    HealthPage(),
    ReadinessPage(),
    MetricsPage(),
    SchemaEchoPage(),
    ThemeTemplatesPage(),
    LayoutTemplatesPage(),
    AdminDashboardPage(),
    AdminConfigHealthPage(),
    AdminAuditLogsPage(),
    AdminRateLimitsPage(),
    AdminUserSessionsPage(),
    OrganisationManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isSuperAdmin = context.watch<CurrentUserState>().isSuperAdmin;
    final body = IndexedStack(index: _selectedIndex, children: _pages);

    Widget buildDrawerContent() {
      final activeLayer = DashboardScreen.activeLayerNotifier.value;
      final isDashboardSelected = _selectedIndex == 0;

      return SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.space24,
                vertical: context.space16,
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space12,
                  vertical: context.space6,
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
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space12,
                  vertical: context.space8,
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.space12,
                      vertical: context.space8,
                    ),
                    child: Text(
                      'LIFECYCLE LAYERS',
                      style: context.uiMicro.copyWith(
                        color: AppColors.greyMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.input_rounded,
                    label: '1. Form Layer',
                    selected: isDashboardSelected && activeLayer == 0,
                    onTap: () {
                      setState(() => _selectedIndex = 0);
                      DashboardScreen.activeLayerNotifier.value = 0;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.hub_outlined,
                    label: '2. Logic Layer',
                    selected: isDashboardSelected && activeLayer == 1,
                    onTap: () {
                      setState(() => _selectedIndex = 0);
                      DashboardScreen.activeLayerNotifier.value = 1;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.auto_graph_outlined,
                    label: '3. Insight Layer',
                    selected: isDashboardSelected && activeLayer == 2,
                    onTap: () {
                      setState(() => _selectedIndex = 0);
                      DashboardScreen.activeLayerNotifier.value = 2;
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.space12,
                      vertical: context.space8,
                    ),
                    child: Text(
                      'MANAGEMENT',
                      style: context.uiMicro.copyWith(
                        color: AppColors.greyMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.folder_outlined,
                    label: 'Projects',
                    selected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  _DrawerItem(
                    icon: Icons.list_alt_outlined,
                    label: 'Forms',
                    selected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  _DrawerItem(
                    icon: Icons.view_week_outlined,
                    label: 'Sections',
                    selected: _selectedIndex == 3,
                    onTap: () => setState(() => _selectedIndex = 3),
                  ),
                  _DrawerItem(
                    icon: Icons.help_outline,
                    label: 'Questions',
                    selected: _selectedIndex == 4,
                    onTap: () => setState(() => _selectedIndex = 4),
                  ),
                  _DrawerItem(
                    icon: Icons.circle_outlined,
                    label: 'Choices',
                    selected: _selectedIndex == 5,
                    onTap: () => setState(() => _selectedIndex = 5),
                  ),
                  _DrawerItem(
                    icon: Icons.rule_outlined,
                    label: 'Conditions',
                    selected: _selectedIndex == 6,
                    onTap: () => setState(() => _selectedIndex = 6),
                  ),
                  _DrawerItem(
                    icon: Icons.send_outlined,
                    label: 'Submit',
                    selected: _selectedIndex == 7,
                    onTap: () => setState(() => _selectedIndex = 7),
                  ),
                  _DrawerItem(
                    icon: Icons.playlist_play_outlined,
                    label: 'Actions',
                    selected: _selectedIndex == 8,
                    onTap: () => setState(() => _selectedIndex = 8),
                  ),
                  _DrawerItem(
                    icon: Icons.merge_type_outlined,
                    label: 'Workflow',
                    selected: _selectedIndex == 9,
                    onTap: () => setState(() => _selectedIndex = 9),
                  ),
                  _DrawerItem(
                    icon: Icons.health_and_safety_outlined,
                    label: 'Health',
                    selected: _selectedIndex == 10,
                    onTap: () => setState(() => _selectedIndex = 10),
                  ),
                  _DrawerItem(
                    icon: Icons.check_circle_outline,
                    label: 'Readiness',
                    selected: _selectedIndex == 11,
                    onTap: () => setState(() => _selectedIndex = 11),
                  ),
                  _DrawerItem(
                    icon: Icons.analytics_outlined,
                    label: 'Metrics',
                    selected: _selectedIndex == 12,
                    onTap: () => setState(() => _selectedIndex = 12),
                  ),
                  _DrawerItem(
                    icon: Icons.schema_outlined,
                    label: 'Schema',
                    selected: _selectedIndex == 13,
                    onTap: () => setState(() => _selectedIndex = 13),
                  ),
                  _DrawerItem(
                    icon: Icons.palette_outlined,
                    label: 'Themes',
                    selected: _selectedIndex == 14,
                    onTap: () => setState(() => _selectedIndex = 14),
                  ),
                  _DrawerItem(
                    icon: Icons.dashboard_customize_outlined,
                    label: 'Layouts',
                    selected: _selectedIndex == 15,
                    onTap: () => setState(() => _selectedIndex = 15),
                  ),
                  _DrawerItem(
                    icon: Icons.admin_panel_settings_outlined,
                    label: 'Admin',
                    selected: _selectedIndex == 16,
                    onTap: () => setState(() => _selectedIndex = 16),
                  ),
                  _DrawerItem(
                    icon: Icons.health_and_safety_outlined,
                    label: 'Cfg',
                    selected: _selectedIndex == 17,
                    onTap: () => setState(() => _selectedIndex = 17),
                  ),
                  _DrawerItem(
                    icon: Icons.note_alt_outlined,
                    label: 'Audit',
                    selected: _selectedIndex == 18,
                    onTap: () => setState(() => _selectedIndex = 18),
                  ),
                  _DrawerItem(
                    icon: Icons.speed_outlined,
                    label: 'Limits',
                    selected: _selectedIndex == 19,
                    onTap: () => setState(() => _selectedIndex = 19),
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    label: 'Sessions',
                    selected: _selectedIndex == 20,
                    onTap: () => setState(() => _selectedIndex = 20),
                  ),
                  if (isSuperAdmin)
                    _DrawerItem(
                      icon: Icons.business_rounded,
                      label: 'Organisation',
                      selected: _selectedIndex == 21,
                      onTap: () => setState(() => _selectedIndex = 21),
                    ),
                  const Divider(),
                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    selected: false,
                    onTap: () {
                      context.read<AuthStateNotifier>().logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: isMobile
          ? body
          : Row(
              children: [
                Container(
                  width: 280,
                  decoration: const BoxDecoration(
                    color: AppColors.pureWhite,
                    border: Border(
                      right: BorderSide(
                        color: AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: buildDrawerContent(),
                ),
                Expanded(child: body),
              ],
            ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: [
                const NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), label: 'Dashboard'),
                const NavigationDestination(icon: Icon(Icons.folder_outlined), label: 'Projects'),
                const NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'Forms'),
                const NavigationDestination(icon: Icon(Icons.view_week_outlined), label: 'Sections'),
                const NavigationDestination(icon: Icon(Icons.help_outline), label: 'Questions'),
                const NavigationDestination(icon: Icon(Icons.circle_outlined), label: 'Choices'),
                const NavigationDestination(icon: Icon(Icons.rule_outlined), label: 'Conditions'),
                const NavigationDestination(icon: Icon(Icons.send_outlined), label: 'Submit'),
                const NavigationDestination(icon: Icon(Icons.playlist_play_outlined), label: 'Actions'),
                const NavigationDestination(icon: Icon(Icons.merge_type_outlined), label: 'Workflow'),
                const NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: 'Health'),
                const NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'Readiness'),
                const NavigationDestination(icon: Icon(Icons.analytics_outlined), label: 'Metrics'),
                const NavigationDestination(icon: Icon(Icons.schema_outlined), label: 'Schema'),
                const NavigationDestination(icon: Icon(Icons.palette_outlined), label: 'Themes'),
                const NavigationDestination(icon: Icon(Icons.dashboard_customize_outlined), label: 'Layouts'),
                const NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'),
                const NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: 'Cfg'),
                const NavigationDestination(icon: Icon(Icons.note_alt_outlined), label: 'Audit'),
                const NavigationDestination(icon: Icon(Icons.speed_outlined), label: 'Limits'),
                const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Sessions'),
                if (isSuperAdmin)
                  const NavigationDestination(icon: Icon(Icons.business_rounded), label: 'Organisation'),
              ],
            )
          : null,
      drawer: isMobile
          ? null
          : Drawer(
              child: buildDrawerContent(),
            ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }
}
