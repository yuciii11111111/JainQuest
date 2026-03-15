import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' show FirebaseException;
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/image_upload_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/motion_pressable.dart';
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
  static const Duration _profileSaveTimeout = Duration(seconds: 15);
  static const Duration _profileImageUploadTimeout = Duration(seconds: 25);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  AppLanguage _selectedLanguage = AppLanguage.english;
  bool _isLoading = false;
  SelectedImage? _pickedImage;
  String? _existingAvatarUrl;
  String? _nameError;
  String? _ageError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProfileProvider);
      _nameController.text = user.displayName ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _existingAvatarUrl = user.avatarUrl;
      _selectedLanguage = AppLanguage.fromCode(user.preferredLanguageCode);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImageUploadService.pickImage();
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  Future<void> _saveProfile() async {
    final displayName = _nameController.text.trim();
    setState(() {
      _nameError = null;
      _ageError = null;
    });
    if (displayName.isEmpty) {
      setState(() {
        _nameError = context.t('please_enter_name');
      });
      _nameFocusNode.requestFocus();
      return;
    }

    final ageValue = int.tryParse(_ageController.text.trim());
    if (ageValue == null || ageValue <= 0) {
      setState(() {
        _ageError = context.t('please_enter_valid_age');
      });
      _ageFocusNode.requestFocus();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(userProfileProvider);
      var updatedUser = user.copyWith(
        displayName: displayName,
        age: ageValue,
        avatarUrl: _existingAvatarUrl,
        preferredLanguageCode: _selectedLanguage.code,
      );
      var photoUploadFailed = false;

      await _withTimeout(
        StorageService.saveUserProfile(updatedUser),
        duration: _profileSaveTimeout,
        operation: 'profile save',
      );

      if (_pickedImage != null) {
        try {
          final avatarUrl = await _withTimeout(
            ImageUploadService.uploadProfileImage(
              user.id,
              _pickedImage!,
            ),
            duration: _profileImageUploadTimeout,
            operation: 'profile image upload',
          );
          updatedUser = updatedUser.copyWith(avatarUrl: avatarUrl);
          await _withTimeout(
            StorageService.saveUserProfile(updatedUser),
            duration: _profileSaveTimeout,
            operation: 'profile save',
          );
        } on TimeoutException catch (error) {
          photoUploadFailed = true;
          debugPrint('Profile image upload timed out: $error');
        } on FirebaseException catch (error) {
          photoUploadFailed = true;
          debugPrint(
            'Profile image upload failed [${error.code}]: ${error.message}',
          );
        } catch (error) {
          photoUploadFailed = true;
          debugPrint('Profile image upload failed: $error');
        }
      }

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

        Navigator.of(context).pushAndRemoveUntilUltraSmooth(
          HomeScreen(showTutorialOnLoad: widget.isFirstTime),
          (route) => false,
        );

        if (photoUploadFailed) {
          _showPostNavigationSnackBar(
            context.t('profile_saved_photo_failed'),
            backgroundColor: AppColors.warning,
          );
        }
      }
    } on TimeoutException catch (error) {
      debugPrint('Profile save timed out: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('profile_save_timed_out')),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save profile: $e');
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

  Future<T> _withTimeout<T>(
    Future<T> future, {
    required Duration duration,
    required String operation,
  }) {
    return future.timeout(
      duration,
      onTimeout: () => throw TimeoutException(
        '$operation exceeded ${duration.inSeconds}s',
        duration,
      ),
    );
  }

  void _showPostNavigationSnackBar(
    String message, {
    required Color backgroundColor,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rootContext = appNavigatorKey.currentContext;
      final messenger =
          rootContext == null ? null : ScaffoldMessenger.maybeOf(rootContext);
      messenger?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Widget _buildAvatarPreview() {
    final scheme = Theme.of(context).colorScheme;
    final previewPixels =
        (100 * MediaQuery.devicePixelRatioOf(context)).round();
    final hasAvatar = _pickedImage != null ||
        (_existingAvatarUrl != null && _existingAvatarUrl!.isNotEmpty);

    Widget avatarContent;
    if (_pickedImage != null) {
      avatarContent = ClipOval(
        child: Image.memory(
          _pickedImage!.bytes,
          width: 100,
          height: 100,
          cacheWidth: previewPixels,
          cacheHeight: previewPixels,
          fit: BoxFit.cover,
        ),
      );
    } else if (_existingAvatarUrl != null && _existingAvatarUrl!.isNotEmpty) {
      avatarContent = ClipOval(
        child: Image.network(
          _existingAvatarUrl!,
          width: 100,
          height: 100,
          cacheWidth: previewPixels,
          cacheHeight: previewPixels,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.person_rounded,
            size: 48,
            color: scheme.onPrimary,
          ),
        ),
      );
    } else {
      avatarContent = Icon(
        Icons.person_rounded,
        size: 48,
        color: scheme.onPrimary,
      );
    }

    return Semantics(
      button: true,
      image: true,
      label: context.t(hasAvatar ? 'change_photo' : 'choose_avatar'),
      hint: context.t('tap_to_upload_photo'),
      child: Tooltip(
        message: context.t(hasAvatar ? 'change_photo' : 'tap_to_upload_photo'),
        child: MotionPressable(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(child: avatarContent),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
                      _buildAvatarPreview(),

                      const SizedBox(height: AppSpacing.xs),

                      Text(
                        context.t('tap_to_upload_photo'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        widget.isFirstTime
                            ? context.t('begin_spiritual_journey')
                            : context.t('update_profile'),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      DropdownButtonFormField<AppLanguage>(
                        value: _selectedLanguage,
                        decoration: InputDecoration(
                          labelText: context.t('preferred_language'),
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
                        focusNode: _nameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (_nameError == null) {
                            return;
                          }
                          setState(() => _nameError = null);
                        },
                        decoration: InputDecoration(
                          labelText: context.t('what_call_you'),
                          hintText: context.t('enter_name'),
                          errorText: _nameError,
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
                        focusNode: _ageFocusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) {
                          if (_ageError == null) {
                            return;
                          }
                          setState(() => _ageError = null);
                        },
                        decoration: InputDecoration(
                          labelText: context.t('how_old'),
                          hintText: context.t('enter_age'),
                          errorText: _ageError,
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
    );
  }
}
