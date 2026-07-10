import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';

class InsightLayer extends StatelessWidget {
  const InsightLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    Widget metricsWidget = Row(
      children: [
        Expanded(
          child:
              _buildMetricCard(
                    context,
                    'Total Inputs',
                    '1,249',
                    'Awareness Baseline',
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.15, end: 0.0),
        ),
        SizedBox(width: context.space24),
        Expanded(
          child:
              _buildMetricCard(
                    context,
                    'DAG Transformations',
                    '48',
                    'Logic Active',
                  )
                  .animate()
                  .fadeIn(
                    delay: 100.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.15, end: 0.0),
        ),
        SizedBox(width: context.space24),
        Expanded(
          child:
              _buildMetricCard(
                    context,
                    'Yield Output',
                    '99.4%',
                    'Accuracy Rate',
                  )
                  .animate()
                  .fadeIn(
                    delay: 200.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.15, end: 0.0),
        ),
      ],
    );

    if (isMobile) {
      metricsWidget = Column(
        children: [
          _buildMetricCard(
                context,
                'Total Inputs',
                '1,249',
                'Awareness Baseline',
              )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.15, end: 0.0),
          SizedBox(height: context.space16),
          _buildMetricCard(context, 'DAG Transformations', '48', 'Logic Active')
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.15, end: 0.0),
          SizedBox(height: context.space16),
          _buildMetricCard(context, 'Yield Output', '99.4%', 'Accuracy Rate')
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.15, end: 0.0),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.space32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insight Layer', style: context.sectionHeading),
          SizedBox(height: context.space4),
          Text(
            'Generates aggregate dashboards and structured understanding.',
            style: context.bodyLarge,
          ),
          SizedBox(height: context.space32),
          metricsWidget,
          SizedBox(height: context.space32),
          Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.space24),
                decoration: AppCardStyles.elevatedDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Structured Insight Summary',
                      style: context.labelLarge,
                    ),
                    SizedBox(height: context.space16),
                    Text(
                      'The transformation pipeline has processed 1,249 telemetry items with zero schema violations. '
                      'Yield results remain consistent with the performance parameters observed during active interpretation sequences.',
                      style: context.bodyLarge,
                    ),
                    SizedBox(height: context.space24),
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: AppButtonStyles.outlined,
                        child: const Text('Export Insight Schema'),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 350.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0.0),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.space24),
      decoration: AppCardStyles.elevatedDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.uiMicro.copyWith(color: AppColors.greyBody),
          ),
          SizedBox(height: context.space12),
          Text(value, style: context.displayHeading.copyWith(height: 1.0)),
          SizedBox(height: context.space8),
          Text(
            subtitle,
            style: context.uiMicro.copyWith(color: AppColors.greyMuted),
          ),
        ],
      ),
    );
  }
}
