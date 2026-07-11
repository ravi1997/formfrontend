import 'package:flutter/material.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final body = IndexedStack(index: _selectedIndex, children: _pages);

    return Scaffold(
      body: body,
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), label: 'Dashboard'),
                NavigationDestination(icon: Icon(Icons.folder_outlined), label: 'Projects'),
                NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'Forms'),
                NavigationDestination(icon: Icon(Icons.view_week_outlined), label: 'Sections'),
                NavigationDestination(icon: Icon(Icons.help_outline), label: 'Questions'),
                NavigationDestination(icon: Icon(Icons.circle_outlined), label: 'Choices'),
                NavigationDestination(icon: Icon(Icons.rule_outlined), label: 'Conditions'),
                NavigationDestination(icon: Icon(Icons.send_outlined), label: 'Submit'),
                NavigationDestination(icon: Icon(Icons.playlist_play_outlined), label: 'Actions'),
                NavigationDestination(icon: Icon(Icons.merge_type_outlined), label: 'Workflow'),
                NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: 'Health'),
                NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'Readiness'),
                NavigationDestination(icon: Icon(Icons.analytics_outlined), label: 'Metrics'),
                NavigationDestination(icon: Icon(Icons.schema_outlined), label: 'Schema'),
                NavigationDestination(icon: Icon(Icons.palette_outlined), label: 'Themes'),
                NavigationDestination(icon: Icon(Icons.dashboard_customize_outlined), label: 'Layouts'),
                NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'),
                NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: 'Cfg'),
                NavigationDestination(icon: Icon(Icons.note_alt_outlined), label: 'Audit'),
                NavigationDestination(icon: Icon(Icons.speed_outlined), label: 'Limits'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Sessions'),
              ],
            )
          : null,
      drawer: isMobile
          ? null
          : Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    _DrawerItem(
                      icon: Icons.space_dashboard_outlined,
                      label: 'Dashboard',
                      selected: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
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
                  ],
                ),
              ),
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
