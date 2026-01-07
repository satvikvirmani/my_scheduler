import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/spacing.dart';
import 'widgets/examination_card.dart';
import '../../providers/exam_provider.dart';

class ExaminationScreen extends ConsumerWidget {
  const ExaminationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exams = ref.watch(upcomingExamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Examination'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upcoming',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ✅ ListView gets bounded height via Expanded
              Expanded(
                child: exams.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text('Error: $e')),
                  data: (examList) {
                    if (examList.isEmpty) {
                      return const Center(
                        child: Text('No upcoming exams'),
                      );
                    }

                    return ListView.separated(
                      itemCount: examList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return ExamCard(
                          exam: examList[index],
                          index: index,
                        );
                      },
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
}