import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import '../../providers/reports_provider.dart';
import 'widgets/report_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../core/constants/text_styles.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);

    final cgpa = ref
        .read(reportsRepositoryProvider)
        .calculateCgpa(reportsAsync.value ?? []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
                vertical: AppSpacing.pagePadding,
              ),
              decoration: const BoxDecoration(color: AppColors.card2),
              child: Column(
                children: [
                  const CustomAppBar(title: 'Reports'),
                  const SizedBox(height: AppSpacing.pagePadding),

                  reportsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.pagePadding),
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Text('Error: $e'),
                    data: (_) {
                      return Column(
                        children: [
                          Text(
                            cgpa.toStringAsFixed(2),
                            style: AppTextStyles.showcase2.copyWith(
                              color: AppColors.body,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.gap),
                          Text(
                            'Current Cumulative GPA',
                            style: AppTextStyles.assist.copyWith(
                              color: AppColors.body,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: reportsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (reports) {
                  if (reports.isEmpty) {
                    return const Center(child: Text('No reports available'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    itemCount: reports.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.pagePadding,
                      ),
                      child: ReportCard(report: reports[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
