import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class OrganisationFormPage extends StatefulWidget {
  final String? organizationUuid;

  const OrganisationFormPage({super.key, this.organizationUuid});

  @override
  State<OrganisationFormPage> createState() => _OrganisationFormPageState();
}

class _OrganisationFormPageState extends State<OrganisationFormPage> {
  final _uuidController = TextEditingController();
  final _nameController = TextEditingController();
  final _adminsController = TextEditingController();
  String _status = 'active';
  bool get _isCreateMode => widget.organizationUuid == null;

  @override
  void dispose() {
    _uuidController.dispose();
    _nameController.dispose();
    _adminsController.dispose();
    super.dispose();
  }

  List<String> _splitCsv(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  Future<void> _save() async {
    final api = context.read<AdminApi>();
    final payload = <String, dynamic>{
      if (_isCreateMode) 'uuid': _uuidController.text.trim(),
      'name': _nameController.text.trim(),
      'admins': _splitCsv(_adminsController.text),
      'status': _status,
    };
    final result = _isCreateMode
        ? await api.createOrganization(payload)
        : await api.updateOrganization(widget.organizationUuid!, payload);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? (_isCreateMode ? 'Organisation created.' : 'Organisation updated.')
              : result.errorOrNull?.message ?? 'Save failed',
        ),
      ),
    );
    if (result.isSuccess) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isCreateMode ? 'Create Organisation' : 'Edit Organisation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isCreateMode) ...[
            TextField(
              controller: _uuidController,
              decoration: const InputDecoration(labelText: 'UUID'),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _adminsController,
            decoration: const InputDecoration(labelText: 'Admin UUIDs comma separated'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _status,
            items: const [
              DropdownMenuItem(value: 'active', child: Text('active')),
              DropdownMenuItem(value: 'inactive', child: Text('inactive')),
            ],
            onChanged: (value) => setState(() => _status = value ?? 'active'),
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: Text(_isCreateMode ? 'Create Organisation' : 'Save Organisation'),
          ),
        ],
      ),
    );
  }
}
