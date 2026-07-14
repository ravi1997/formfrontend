import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrganizations();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _generateUuid() {
    final random = Random();
    final hex = List.generate(32, (index) => random.nextInt(16).toRadixString(16)).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
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
          _organisations = List<Map<String, dynamic>>.from(items.map((e) => Map<String, dynamic>.from(e)));
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

  Future<void> _createOrg() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final uuid = _generateUuid();
    final result = await context.read<AdminApi>().createOrganization({
      'uuid': uuid,
      'name': name,
      'status': 'active',
      'admins': [],
    });

    if (!mounted) return;
    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organisation created successfully.')),
        );
        _fetchOrganizations();
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${error.message}'), backgroundColor: Colors.red[800]),
        );
      },
    );
  }

  Future<void> _updateOrgName(String uuid, String currentName) async {
    _nameController.text = currentName;
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Organisation Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _nameController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || !mounted) return;

    final result = await context.read<AdminApi>().updateOrganization(uuid, {'name': newName});
    if (!mounted) return;

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organisation name updated.')),
        );
        _fetchOrganizations();
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${error.message}'), backgroundColor: Colors.red[800]),
        );
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
    _nameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Organisation'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Organisation Name',
            hintText: 'e.g. Wayne Enterprises',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _createOrg();
            },
            child: const Text('Create'),
          ),
        ],
      ),
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
                              final admins = org['admins'] as List<dynamic>? ?? [];

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
                                            _updateOrgName(uuid, name);
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
