import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import '../../providers/reports_provider.dart';
import '../../models/report.dart';
import 'widgets/report_card.dart';

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔝 Top section with background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                ),
                child: Column(
                  children: [
                    // Top bar
                    AppBar(
                      title: const Text('Reports'),
                      backgroundColor: AppColors.mint,
                    ),

                    const SizedBox(height: 24),

                    // 🎓 GPA (dynamic)
                    reportsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, _) => Text('Error: $e'),
                      data: (reports) {
                        return Column(
                          children: [
                            Text(
                              cgpa.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Current Cumulative GPA',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // 📄 Semester cards
              Padding(
                padding:
                    const EdgeInsets.all(AppSpacing.pagePadding),
                child: reportsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Text('Error: $e'),
                  data: (reports) {
                    if (reports.isEmpty) {
                      return const Text('No reports available');
                    }

                    return Column(
                      children: reports.map(
                        (report) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ReportCard(report: report),
                        ),
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Typed + safe GPA calculation
  // ignore: unused_element
  double _calculateCumulativeGpa(List<Report> reports) {
    if (reports.isEmpty) return 0;

    final total =
        reports.fold<double>(0, (sum, r) => sum + r.gpa);

    return total / reports.length;
  }
}