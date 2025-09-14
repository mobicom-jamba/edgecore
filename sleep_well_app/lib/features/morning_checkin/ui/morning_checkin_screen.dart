import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/modals.dart';
import '../../../core/database/database.dart';
import '../data/providers/morning_checkin_providers.dart';
import '../data/models/morning_checkin.dart';

class MorningCheckinScreen extends HookConsumerWidget {
  const MorningCheckinScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = ref.watch(checkinCompletedProvider);
    final streakDays = ref.watch(streakDaysProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morning Check-in'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: isCompleted
            ? _buildCompletedView(context, ref, streakDays.value ?? 0)
            : _buildCheckinForm(context, ref, streakDays.value ?? 0),
      ),
    );
  }
  
  Widget _buildCheckinForm(
    BuildContext context,
    WidgetRef ref,
    int streakDays,
  ) {
    final inBedOnTime = ref.watch(inBedOnTimeProvider);
    final energyLevel = ref.watch(energyLevelProvider);
    final moodLevel = ref.watch(moodLevelProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(streakDays),
          
          const SizedBox(height: AppTheme.spacing32),
          
          // In bed on time question
          _buildInBedOnTimeQuestion(context, ref, inBedOnTime),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Energy level question
          _buildEnergyLevelQuestion(context, ref, energyLevel),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Mood level question
          _buildMoodLevelQuestion(context, ref, moodLevel),
          
          const SizedBox(height: AppTheme.spacing32),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Complete Check-in',
              onPressed: () => _submitCheckin(context, ref),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(int streakDays) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How did your night go?',
          style: AppTheme.h1,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Your daily check-in helps track your sleep quality and build healthy habits.',
          style: AppTheme.body,
        ),
        if (streakDays > 0) ...[
          const SizedBox(height: AppTheme.spacing16),
          Card(
            color: AppTheme.success.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppTheme.success,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    '$streakDays day streak!',
                    style: AppTheme.title.copyWith(
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  
  Widget _buildInBedOnTimeQuestion(
    BuildContext context,
    WidgetRef ref,
    bool? inBedOnTime,
  ) => CardSection(
      title: 'Were you in bed on time?',
      body: Column(
        children: [
          _buildYesNoOption(
            context,
            ref,
            'Yes',
            true,
            inBedOnTime,
            (value) => ref.read(inBedOnTimeProvider.notifier).state = value,
            Icons.check_circle_outline,
            AppTheme.success,
          ),
          const SizedBox(height: AppTheme.spacing12),
          _buildYesNoOption(
            context,
            ref,
            'No',
            false,
            inBedOnTime,
            (value) => ref.read(inBedOnTimeProvider.notifier).state = value,
            Icons.cancel_outlined,
            AppTheme.warning,
          ),
        ],
      ),
    );
  
  Widget _buildEnergyLevelQuestion(
    BuildContext context,
    WidgetRef ref,
    int energyLevel,
  ) => CardSection(
      title: 'How is your energy level?',
      body: Column(
        children: [
          Text(
            'Rate your energy from 1 (very low) to 5 (very high)',
            style: AppTheme.caption,
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildRatingScale(
            context,
            ref,
            energyLevel,
            (value) => ref.read(energyLevelProvider.notifier).state = value,
            ['Very Low', 'Low', 'Medium', 'High', 'Very High'],
          ),
        ],
      ),
    );
  
  Widget _buildMoodLevelQuestion(
    BuildContext context,
    WidgetRef ref,
    int moodLevel,
  ) => CardSection(
      title: 'How is your mood?',
      body: Column(
        children: [
          Text(
            'Rate your mood from 1 (very poor) to 5 (very good)',
            style: AppTheme.caption,
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildRatingScale(
            context,
            ref,
            moodLevel,
            (value) => ref.read(moodLevelProvider.notifier).state = value,
            ['Very Poor', 'Poor', 'Neutral', 'Good', 'Very Good'],
          ),
        ],
      ),
    );
  
  Widget _buildYesNoOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    bool value,
    bool? selectedValue,
    ValueChanged<bool> onChanged,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedValue == value;
    
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(value);
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusButton),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppTheme.surfaceAlt,
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          border: Border.all(
            color: isSelected ? color : AppTheme.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacing12),
            Text(
              label,
              style: AppTheme.title.copyWith(
                color: isSelected ? color : AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRatingScale(
    BuildContext context,
    WidgetRef ref,
    int selectedValue,
    ValueChanged<int> onChanged,
    List<String> labels,
  ) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final value = index + 1;
        final isSelected = selectedValue == value;
        
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(value);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.accentPrimary : AppTheme.surfaceAlt,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppTheme.accentPrimary : AppTheme.divider,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toString(),
                  style: AppTheme.title.copyWith(
                    color: isSelected ? AppTheme.background : AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    labels[index],
                    style: AppTheme.caption.copyWith(
                      color: isSelected ? AppTheme.background : AppTheme.textSecondary,
                      fontSize: 9,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  
  Widget _buildCompletedView(
    BuildContext context,
    WidgetRef ref,
    int streakDays,
  ) => Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.success,
            size: 80,
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            'Check-in complete!',
            style: AppTheme.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Great job taking care of your sleep health. Keep up the good work!',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          if (streakDays > 0) ...[
            const SizedBox(height: AppTheme.spacing24),
            Card(
              color: AppTheme.success.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppTheme.success,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    Text(
                      '$streakDays day streak!',
                      style: AppTheme.title.copyWith(
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spacing32),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Continue',
              onPressed: () {
                HapticFeedback.lightImpact();
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  
  Future<void> _submitCheckin(BuildContext context, WidgetRef ref) async {
    final inBedOnTime = ref.read(inBedOnTimeProvider);
    final energyLevel = ref.read(energyLevelProvider);
    final moodLevel = ref.read(moodLevelProvider);
    
    if (inBedOnTime == null || energyLevel == 0 || moodLevel == 0) {
      Toast.show(
        context: context,
        message: 'Please answer all questions',
        type: ToastType.warning,
      );
      return;
    }
    
    // Create check-in record
    final checkin = MorningCheckin()
      ..date = DateTime.now()
      ..inBedOnTime = inBedOnTime
      ..energy = energyLevel
      ..mood = moodLevel;
    
    // Save to database
    final isar = DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.morningCheckins.put(checkin);
    });
    
    // Mark as completed
    ref.read(checkinCompletedProvider.notifier).state = true;
    
    HapticFeedback.lightImpact();
  }
}
