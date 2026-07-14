import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class OrganisationManagementPage extends StatefulWidget {
  const OrganisationManagementPage({super.key});

  @override
  State<OrganisationManagementPage> createState() => _OrganisationManagementPageState();
}

class _OrganisationManagementPageState extends State<OrganisationManagementPage> {
  List<Map<String, dynamic>> _organisations = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrganizations();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchOrganizations() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await context.read<AdminApi>().listOrganizations();
    if (!mounted) return;

    result.when(
      success: (items) {
        setState(() {
          _organisations = items
              .map((e) => e is Map<String, dynamic>
                  ? e
                  : e is Map
                      ? Map<String, dynamic>.from(e)
                      : <String, dynamic>{})
              .where((org) => org.isNotEmpty)
              .toList();
          _isLoading = false;
        });
      },
      failure: (error) {
        setState(() {
          _errorMessage = error.message;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _toggleStatus(Map<String, dynamic> org) async {
    final uuid = org['uuid'] as String;
    final currentStatus = org['status'] as String;
    final nextStatus = currentStatus == 'active' ? 'inactive' : 'active';

    final result = await context.read<AdminApi>().updateOrganization(uuid, {'status': nextStatus});
    if (!mounted) return;

    result.when(
      success: (_) {
        _fetchOrganizations();
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status toggle failed: ${error.message}'), backgroundColor: Colors.red[800]),
        );
      },
    );
  }

  Future<void> _deleteOrg(String uuid) async {
    final result = await context.read<AdminApi>().deleteOrganization(uuid);
    if (!mounted) return;

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organisation deleted.')),
        );
        _fetchOrganizations();
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: ${error.message}'), backgroundColor: Colors.red[800]),
        );
      },
    );
  }

  void _showCreateDialog() {
    Navigator.of(context).pushNamed(
      RouteNames.organisationEdit,
      arguments: const {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    // Filtering soft-deleted organisations from backend (which have status: 'deleted')
    final activeOrgs = _organisations.where((org) => org['status'] != 'deleted').toList();

    final filteredOrgs = activeOrgs.where((org) {
      final query = _searchQuery.toLowerCase();
      final name = org['name']?.toString().toLowerCase() ?? '';
      final uuid = org['uuid']?.toString().toLowerCase() ?? '';
      return name.contains(query) || uuid.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: isMobile
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
        title: const Text('Organisation Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_rounded),
            tooltip: 'Add Organisation',
            onPressed: _showCreateDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _fetchOrganizations,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Organisation Summary', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Loaded organisations: ${_organisations.length}'),
                    Text('Active organisations: ${activeOrgs.length}'),
                    Text('Filtered organisations: ${filteredOrgs.length}'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Organisations',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $_errorMessage'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchOrganizations,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                          : filteredOrgs.isEmpty
                        ? const Center(child: Text('No organisations found'))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredOrgs.length,
                            separatorBuilder: (_, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final org = filteredOrgs[index];
                              final String uuid = org['uuid'] ?? '';
                              final String name = org['name'] ?? 'Unnamed';
                              final String status = org['status'] ?? 'inactive';
                              final bool isActive = status == 'active';
                              final adminsRaw = org['admins'];
                              final admins = adminsRaw is List
                                  ? adminsRaw
                                  : adminsRaw is Map
                                      ? adminsRaw.values.toList()
                                      : const <dynamic>[];

                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isActive
                                        ? AppColors.borderLight.withAlpha(128)
                                        : Colors.red.withAlpha(51),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: isActive
                                        ? AppColors.surfaceSubtle
                                        : Colors.red.withAlpha(25),
                                    child: Icon(
                                      Icons.business_rounded,
                                      color: isActive ? AppColors.charcoal : Colors.red,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.charcoal.withAlpha(20),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${admins.length} Admins',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text('UUID: $uuid'),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Status: ${status.toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isActive ? Colors.green[700] : Colors.red[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Switch(
                                        value: isActive,
                                        onChanged: (_) => _toggleStatus(org),
                                        activeThumbColor: Colors.green,
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            Navigator.of(context).pushNamed(
                                              RouteNames.organisationEdit,
                                              arguments: {'organizationUuid': uuid},
                                            );
                                          } else if (value == 'delete') {
                                            _deleteOrg(uuid);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit, size: 18),
                                                SizedBox(width: 8),
                                                Text('Rename'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, color: Colors.red, size: 18),
                                                SizedBox(width: 8),
                                                Text('Delete', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
