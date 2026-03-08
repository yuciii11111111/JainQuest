import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../home/presentation/home_screen.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  final bool isFirstTime;

  const ProfileSetupScreen({
    super.key,
    this.isFirstTime = true,
  });

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  static const List<String> _emojiOptions = [
    '🧘',
    '🪷',
    '🌟',
    '📿',
    '🕉️',
    '🌿',
    '🔥',
    '🌙',
    '🐘',
    '🦚',
  ];
  String? _selectedEmoji;
  AppLanguage _selectedLanguage = AppLanguage.english;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProfileProvider);
      _nameController.text = user.displayName ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _selectedEmoji = user.avatarEmoji;
      _selectedLanguage = AppLanguage.fromCode(user.preferredLanguageCode);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final displayName = _nameController.text.trim();
    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('please_enter_name')),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final ageValue = int.tryParse(_ageController.text.trim());
    if (ageValue == null || ageValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('please_enter_valid_age')),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(userProfileProvider);
      final updatedUser = user.copyWith(
        displayName: displayName,
        age: ageValue,
        avatarEmoji: _selectedEmoji ?? user.avatarEmoji,
        preferredLanguageCode: _selectedLanguage.code,
      );
      await StorageService.saveUserProfile(updatedUser);
      ref.read(userProfileProvider.notifier).refresh();

      if (mounted) {
        if (widget.isFirstTime) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.t(
                  'profile_setup_complete',
                  args: {'name': updatedUser.displayName ?? 'Learner'},
                ),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const HomeScreen(showTutorialOnLoad: true)),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('failed_to_save_profile')),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surface,
              scheme.surfaceContainerHighest.withOpacityValue(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _selectedEmoji ?? '🙂',
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Title
                        Text(
                          widget.isFirstTime
                              ? context.t('set_up_profile')
                              : context.t('update_profile'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          context.t('personalize_learning'),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        Text(
                          context.t('choose_avatar'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          alignment: WrapAlignment.center,
                          children: _emojiOptions.map((emoji) {
                            final isSelected = emoji == _selectedEmoji;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedEmoji = emoji),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withOpacityValue(0.2)
                                      : scheme.surface,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.small),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : scheme.outline,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacityValue(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        const SizedBox(height: AppSpacing.lg),

                        DropdownButtonFormField<AppLanguage>(
                          value: _selectedLanguage,
                          decoration: InputDecoration(
                            labelText: context.t('preferred_language'),
                            prefixIcon: const Icon(Icons.language_rounded),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: BorderSide(color: scheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: BorderSide(color: scheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: scheme.surface,
                          ),
                          items: AppLanguage.values
                              .map(
                                (language) => DropdownMenuItem<AppLanguage>(
                                  value: language,
                                  child: Text(language.nativeName),
                                ),
                              )
                              .toList(),
                          onChanged: (language) {
                            if (language != null) {
                              setState(() => _selectedLanguage = language);
                            }
                          },
                        ),

                        const SizedBox(height: AppSpacing.md),

                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: context.t('what_call_you'),
                            hintText: context.t('enter_name'),
                            prefixIcon: const Icon(Icons.person_rounded),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: BorderSide(color: scheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: BorderSide(color: scheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: scheme.surface,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Age Input
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: context.t('how_old'),
                            hintText: context.t('enter_age'),
                            prefixIcon: const Icon(Icons.cake_rounded),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: BorderSide(color: scheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: BorderSide(color: scheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.button),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: scheme.surface,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Save Button
                        GradientButton(
                          label: widget.isFirstTime
                              ? context.t('get_started')
                              : context.t('save'),
                          icon: Icons.check_rounded,
                          onPressed: _isLoading ? null : _saveProfile,
                          isLoading: _isLoading,
                          width: double.infinity,
                        ),

                        if (!widget.isFirstTime) ...[
                          const SizedBox(height: AppSpacing.md),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              context.t('back'),
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
