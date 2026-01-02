import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final TextEditingController _passwordController = TextEditingController();
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
  bool _obscurePassword = true;

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
    _passwordController.dispose();
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

    if (widget.isFirstTime && _passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
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
      password: _passwordController.text.trim().isEmpty
          ? user.password
          : _passwordController.text.trim(),
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
                gradient: AppGradients.primary,
                shape: BoxShape.circle,
                boxShadow: AppShadows.glowing,
              ),
              child: Center(
                child: Text(
                  _selectedEmoji ?? '🙂',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              widget.isFirstTime ? 'Welcome to JainQuest!' : 'Update Profile',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),

            const SizedBox(height: AppSpacing.sm),

            Text(
              widget.isFirstTime
                  ? 'Let\'s personalize your learning journey'
                  : 'Update your details',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 300.ms),

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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacityValue(0.2)
                          : AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.glassBorder,
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
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundCard,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onSubmitted: (_) => _saveProfile(),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),

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
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundCard,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 350.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),

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
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundCard,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),

            const SizedBox(height: AppSpacing.md),

            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: widget.isFirstTime ? 'Password' : 'New password (optional)',
                hintText: widget.isFirstTime ? 'Set a password' : 'Leave blank to keep',
                prefixIcon: const Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundCard,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onSubmitted: (_) => _saveProfile(),
            )
                .animate()
                .fadeIn(delay: 450.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),

            const SizedBox(height: AppSpacing.lg),

            // Save Button
            GradientButton(
              label: widget.isFirstTime ? 'Get Started' : 'Save',
              icon: Icons.check_rounded,
              onPressed: _isLoading ? null : _saveProfile,
              isLoading: _isLoading,
              width: double.infinity,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),

            if (!widget.isFirstTime) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

