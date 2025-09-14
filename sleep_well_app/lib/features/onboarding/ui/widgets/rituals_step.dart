import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/buttons.dart';
import '../../data/providers/onboarding_providers.dart';
import '../../data/models/ritual.dart';

class RitualsStep extends HookConsumerWidget {
  const RitualsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRituals = ref.watch(selectedRitualsProvider);
    final buddy = ref.watch(buddyProvider);
    final canProceed = ref.watch(canProceedProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Choose your wind-down rituals',
          style: AppTheme.h1,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Select 3 activities to help you relax before bed',
          style: AppTheme.body,
        ),
        
        const SizedBox(height: AppTheme.spacing24),
        
        // Ritual selection
        Text(
          'Your rituals (${selectedRituals.length}/3)',
          style: AppTheme.title,
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        Wrap(
          spacing: AppTheme.spacing12,
          runSpacing: AppTheme.spacing12,
          children: RitualType.values.map((ritualType) {
            final isSelected = selectedRituals.any((r) => r.type == ritualType);
            final ritual = selectedRituals.firstWhere(
              (r) => r.type == ritualType,
              orElse: () => Ritual(type: ritualType, durationMinutes: 5),
            );
            
            return _buildRitualCard(
              context,
              ref,
              ritual,
              isSelected,
            );
          }).toList(),
        ),
        
        const SizedBox(height: AppTheme.spacing32),
        
        // Sleep buddy section
        Text(
          'Sleep buddy (optional)',
          style: AppTheme.title,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Add a friend to keep you accountable',
          style: AppTheme.body,
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider),
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    color: AppTheme.accentPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    buddy != null ? 'Buddy: ${buddy.name}' : 'No buddy added',
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showBuddyModal(context, ref),
                    child: Text(
                      buddy != null ? 'Edit' : 'Add',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.accentPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (buddy != null) ...[
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'They\'ll get gentle nudges if you miss bedtime',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const Spacer(),
        
        // Continue button
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Complete Setup',
            onPressed: canProceed ? () => _completeOnboarding(ref) : null,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRitualCard(
    BuildContext context,
    WidgetRef ref,
    Ritual ritual,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => _toggleRitual(ref, ritual),
      child: Container(
        width: (MediaQuery.of(context).size.width - AppTheme.spacing16 * 3) / 2,
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.accentPrimary.withOpacity(0.1)
              : AppTheme.surface,
          border: Border.all(
            color: isSelected 
                ? AppTheme.accentPrimary
                : AppTheme.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        ),
        child: Column(
          children: [
            Icon(
              ritual.type.icon,
              color: isSelected ? AppTheme.accentPrimary : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              ritual.type.displayName,
              style: AppTheme.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.accentPrimary : AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              ritual.type.description,
              style: AppTheme.caption.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected) ...[
              const SizedBox(height: AppTheme.spacing8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                ),
                child: Text(
                  '${ritual.durationMinutes}m',
                  style: AppTheme.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _toggleRitual(WidgetRef ref, Ritual ritual) {
    final selectedRituals = ref.read(selectedRitualsProvider);
    
    if (selectedRituals.any((r) => r.type == ritual.type)) {
      // Remove ritual
      final newRituals = selectedRituals.where((r) => r.type != ritual.type).toList();
      ref.read(selectedRitualsProvider.notifier).state = newRituals;
    } else if (selectedRituals.length < 3) {
      // Add ritual
      final newRituals = [...selectedRituals, ritual];
      ref.read(selectedRitualsProvider.notifier).state = newRituals;
    }
  }
  
  void _showBuddyModal(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final currentBuddy = ref.read(buddyProvider);
    
    if (currentBuddy != null) {
      nameController.text = currentBuddy.name;
      phoneController.text = currentBuddy.phoneNumber;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusCard),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Sleep Buddy',
                style: AppTheme.h2,
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter their name',
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+1 (555) 123-4567',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.spacing24),
              
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Save',
                      onPressed: () {
                        if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                          ref.read(buddyProvider.notifier).state = SleepBuddy(
                            name: nameController.text,
                            phoneNumber: phoneController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _completeOnboarding(WidgetRef ref) {
    final selectedRituals = ref.read(selectedRitualsProvider);
    final buddy = ref.read(buddyProvider);
    
    final rituals = OnboardingRituals(
      selectedRituals: selectedRituals,
      buddy: buddy,
    );
    
    ref.read(onboardingStateProvider.notifier).setRituals(rituals);
    ref.read(onboardingStateProvider.notifier).completeOnboarding();
  }
}
