import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/state/auth_state.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/features/dashboard/presentation/components/form_layer.dart';
import 'package:formfrontend/features/dashboard/presentation/components/logic_layer.dart';
import 'package:formfrontend/features/dashboard/presentation/components/insight_layer.dart';

typedef _LayerBuilder =
    Widget Function(BuildContext context, _DashboardScreenState state);

class _LayerDescriptor {
  final String title;
  final String subtitle;
  final IconData icon;
  final _LayerBuilder builder;

  const _LayerDescriptor({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });
}

class DashboardScreen extends StatefulWidget {
  static final ValueNotifier<int> activeLayerNotifier = ValueNotifier<int>(0);

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedLayerIndex = 0;

  @override
  void initState() {
    super.initState();
    DashboardScreen.activeLayerNotifier.addListener(_onActiveLayerChanged);
    _selectedLayerIndex = DashboardScreen.activeLayerNotifier.value;
  }

  @override
  void dispose() {
    DashboardScreen.activeLayerNotifier.removeListener(_onActiveLayerChanged);
    _inputController.dispose();
    super.dispose();
  }

  void _onActiveLayerChanged() {
    if (mounted) {
      setState(() {
        _selectedLayerIndex = DashboardScreen.activeLayerNotifier.value;
      });
    }
  }

  // Form State
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  String _transformationRule = 'Pass-through';
  bool _isCritical = false;

  // Mock Data
  final List<Map<String, dynamic>> _capturedInputs = [
    {
      'timestamp': '12:04:12',
      'data': 'System awareness baseline active',
      'rule': 'Log',
      'type': 'System',
    },
    {
      'timestamp': '12:05:45',
      'data': 'Node-4 telemetry feed online',
      'rule': 'Aggregate',
      'type': 'Network',
    },
  ];

  late final List<_LayerDescriptor> _layers = [
    _LayerDescriptor(
      title: '1. Form Layer',
      subtitle: 'Awareness → Data',
      icon: Icons.input_rounded,
      builder: (context, state) => FormLayer(
        formKey: state._formKey,
        inputController: state._inputController,
        transformationRule: state._transformationRule,
        isCritical: state._isCritical,
        capturedInputs: state._capturedInputs,
        onRuleChanged: (val) {
          if (val != null) {
            setState(() => state._transformationRule = val);
          }
        },
        onCriticalChanged: (val) {
          setState(() => state._isCritical = val ?? false);
        },
        onSubmit: state._submitForm,
      ),
    ),
    _LayerDescriptor(
      title: '2. Logic Layer',
      subtitle: 'Interpretation → Observation',
      icon: Icons.hub_outlined,
      builder: (context, state) => const LogicLayer(),
    ),
    _LayerDescriptor(
      title: '3. Insight Layer',
      subtitle: 'Generation → Insight',
      icon: Icons.auto_graph_outlined,
      builder: (context, state) => const InsightLayer(),
    ),
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _capturedInputs.insert(0, {
          'timestamp': DateTime.now().toString().substring(11, 19),
          'data': _inputController.text,
          'rule': _transformationRule,
          'type': _isCritical ? 'Critical' : 'Standard',
        });
        _inputController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Input perceived and transitioned to Data state.'),
        ),
      );
    }
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
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
        title: Row(
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
            SizedBox(width: context.space12),
            if (!isMobile)
              Text(
                'From Awareness to Insight',
                style: context.uiMicro.copyWith(color: AppColors.greyBody),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.space16),
            child: Center(
              child: Text(
                'System: Active',
                style: context.uiMicro.copyWith(color: AppColors.slateMid),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthStateNotifier>().logout();
            },
          ),
          SizedBox(width: context.space8),
        ],
      ),
      body: isMobile
          ? Column(
              children: [
                _buildMobileNavBar(),
                Expanded(child: _buildMainContent()),
              ],
            )
          : _buildMainContent(),
    );
  }



  Widget _buildMobileNavBar() {
    return Container(
      color: AppColors.pureWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_layers.length, (index) {
          final layer = _layers[index];
          final label = layer.title
              .split('.')
              .last
              .replaceAll('Layer', '')
              .trim();
          return _buildMobileNavButton(index, label, layer.icon);
        }),
      ),
    );
  }

  Widget _buildMobileNavButton(int index, String label, IconData icon) {
    final isSelected = _selectedLayerIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedLayerIndex = index),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.space12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.charcoal : AppColors.greyBody,
            ),
            SizedBox(height: context.space4),
            Text(
              label,
              style: context.uiMicro.copyWith(
                color: isSelected ? AppColors.charcoal : AppColors.greyBody,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_selectedLayerIndex),
        child: _buildLayerScreen(),
      ),
    );
  }

  Widget _buildLayerScreen() {
    if (_selectedLayerIndex >= 0 && _selectedLayerIndex < _layers.length) {
      return _layers[_selectedLayerIndex].builder(context, this);
    }
    return const SizedBox.shrink();
  }
}
