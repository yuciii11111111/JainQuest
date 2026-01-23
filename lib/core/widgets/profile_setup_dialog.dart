import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../services/storage_service.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

class ProfileSetupDialog extends ConsumerStatefulWidget {
  final bool isFirstTime;

  const ProfileSetupDialog({
    super.key,
    this.isFirstTime = true,
  });

  @override
  ConsumerState<ProfileSetupDialog> createState() => _ProfileSetupDialogState();
}

class _ProfileSetupDialogState extends ConsumerState<ProfileSetupDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill name if editing
    if (!widget.isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final user = ref.read(userProfileProvider);
        _nameController.text = user.displayName ?? '';
        _ageController.text = user.age?.toString() ?? '';
        _emailController.text = user.email ?? '';
        _selectedEmoji = user.avatarEmoji;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final ageValue = int.tryParse(_ageController.text.trim());
    if (ageValue == null || ageValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid age'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = ref.read(userProfileProvider);
    final updatedUser = user.copyWith(
      displayName: _nameController.text.trim(),
      age: ageValue,
      email: _emailController.text.trim(),
      avatarEmoji: _selectedEmoji ?? user.avatarEmoji,
    );
    await StorageService.saveUserProfile(updatedUser);
    ref.read(userProfileProvider.notifier).refresh();

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      if (widget.isFirstTime) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to JainQuest, ${_nameController.text.trim()}!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
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
              widget.isFirstTime ? 'Welcome to JainQuest!' : 'Update Profile',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              widget.isFirstTime
                  ? 'Let\'s personalize your learning journey'
                  : 'Update your details',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              'Choose your avatar',
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
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacityValue(0.2)
                          : scheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : scheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
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
            const SizedBox(height: AppSpacing.lg),

            // Name Input
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: BorderSide(color: scheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: BorderSide(color: scheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: scheme.surface,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onSubmitted: (_) => _saveProfile(),
            ),

            const SizedBox(height: AppSpacing.md),

            // Age Input
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                hintText: 'Enter your age',
                prefixIcon: const Icon(Icons.cake_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: BorderSide(color: scheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: BorderSide(color: scheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: scheme.surface,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: AppSpacing.md),

            // Email Input
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: BorderSide(color: scheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: BorderSide(color: scheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: scheme.surface,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Save Button
            GradientButton(
              label: widget.isFirstTime ? 'Get Started' : 'Save',
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
                  'Cancel',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
