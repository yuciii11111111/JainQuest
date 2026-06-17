import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_models.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../../core/widgets/motion_pressable.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_setup_screen.dart';
import '../../../core/localization/app_strings.dart';

enum AuthIntent { undecided, signUp, signIn }

enum _AuthStep { intent, method, email, password, welcome }

class AuthFlowScreen extends ConsumerStatefulWidget {
  final AuthIntent initialIntent;

  const AuthFlowScreen({
    super.key,
    this.initialIntent = AuthIntent.undecided,
  });

  @override
  ConsumerState<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends ConsumerState<AuthFlowScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  late AuthIntent _intent;
  late _AuthStep _step;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showConfirmPassword = false;
  bool _needsProfileSetup = false;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _intent = widget.initialIntent;
    _step =
        _intent == AuthIntent.undecided ? _AuthStep.intent : _AuthStep.method;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool get _isSignUp => _intent == AuthIntent.signUp;

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _formError = message;
    });
  }

  bool _isValidEmail(String value) {
    final email = value.trim();
    return email.contains('@') && email.contains('.');
  }

  void _clearErrors() {
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _formError = null;
  }

  Widget _buildInlineError(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.danger,
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _setStep(_AuthStep step) {
    setState(() {
      _clearErrors();
      _step = step;
    });
  }

  void _goBack() {
    if (_step == _AuthStep.welcome || _isLoading) return;
    setState(() {
      _clearErrors();
      if (_step == _AuthStep.password) {
        _showConfirmPassword = false;
      }
      switch (_step) {
        case _AuthStep.intent:
          break;
        case _AuthStep.method:
          _step = _intent == AuthIntent.undecided
              ? _AuthStep.intent
              : _AuthStep.method;
          if (_intent != AuthIntent.undecided) {
            _intent = AuthIntent.undecided;
            _step = _AuthStep.intent;
          }
          break;
        case _AuthStep.email:
          _step = _AuthStep.method;
          break;
        case _AuthStep.password:
          _step = _AuthStep.email;
          break;
        case _AuthStep.welcome:
          break;
      }
    });
  }

  Future<void> _signInWithGoogle() async {
    final googleSignInFailedMessage = context.t('google_signin_failed');
    setState(() {
      _clearErrors();
      _isLoading = true;
    });
    try {
      final user = await AuthService.signInWithGoogle();
      if (user == null) return;

      await _handleAuthSuccess(user, isNewUserHint: _isSignUp);
    } catch (_) {
      _showError(googleSignInFailedMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitEmailStep() async {
    setState(_clearErrors);
    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = context.t('enter_valid_email');
      });
      _emailFocusNode.requestFocus();
      return;
    }
    _setStep(_AuthStep.password);
  }

  Future<void> _submitPasswordStep() async {
    final passwordMinCharsMessage = context.t('password_min_chars');
    final unableCreateAccountMessage = context.t('unable_create_account');
    final unableLoginMessage = context.t('unable_login');
    final authFailedMessage = context.t('auth_failed');
    final authFailedRetryMessage = context.t('auth_failed_retry');
    setState(() {
      _passwordError = null;
      _confirmPasswordError = null;
      _formError = null;
    });
    final password = _passwordController.text.trim();
    if (password.length < 6) {
      setState(() {
        _passwordError = passwordMinCharsMessage;
      });
      _passwordFocusNode.requestFocus();
      return;
    }

    if (_isSignUp && !_showConfirmPassword) {
      setState(() => _showConfirmPassword = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _confirmPasswordFocusNode.requestFocus();
        }
      });
      return;
    }

    if (_isSignUp &&
        _confirmPasswordController.text.trim() !=
            _passwordController.text.trim()) {
      setState(() {
        _confirmPasswordError = context.t('passwords_no_match');
      });
      _confirmPasswordFocusNode.requestFocus();
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        final result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = result.user;
        if (user == null) throw StateError(unableCreateAccountMessage);

        await StorageService.init(user: user);
        final profile = UserProfile(
          id: user.uid,
          createdAt: DateTime.now(),
          email: _emailController.text.trim(),
          showGuidedTour: true,
        );
        await StorageService.saveUserProfile(profile);
        ref.read(userProfileProvider.notifier).refresh();
        await _handleAuthSuccess(user, isNewUserHint: true);
      } else {
        final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = result.user;
        if (user == null) throw StateError(unableLoginMessage);
        await _handleAuthSuccess(user);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        setState(() {
          _passwordError = passwordMinCharsMessage;
        });
        _passwordFocusNode.requestFocus();
      } else {
        _showError(error.message ?? authFailedMessage);
        _passwordFocusNode.requestFocus();
      }
    } catch (_) {
      _showError(authFailedRetryMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAuthSuccess(
    User user, {
    bool isNewUserHint = false,
  }) async {
    await StorageService.init(user: user);
    ref.read(userProfileProvider.notifier).refresh();
    final profile = StorageService.getUserProfile();

    if (!mounted) return;
    setState(() {
      _needsProfileSetup = isNewUserHint || !profile.isProfileComplete;
      _step = _AuthStep.welcome;
    });
  }

  Future<void> _continueAfterWelcome() async {
    if (!mounted) return;
    if (_needsProfileSetup) {
      Navigator.of(context).pushAndRemoveUntilUltraSmooth(
        const ProfileSetupScreen(isFirstTime: true),
        (route) => false,
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntilUltraSmooth(
      HomeScreen(showTutorialOnLoad: _isSignUp),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            if (_step != _AuthStep.intent &&
                                _step != _AuthStep.welcome)
                              MotionPressable(
                                enabled: !_isLoading,
                                child: IconButton(
                                  onPressed: _isLoading ? null : _goBack,
                                  tooltip: context.t('back'),
                                  icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded),
                                  color: scheme.onSurface,
                                ),
                              )
                            else
                              const SizedBox(width: 48),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'JainQuest',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: scheme.onSurface,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 56,
                                ),
                      ),
                      if (_intent == AuthIntent.signIn) ...[
                        const SizedBox(height: AppSpacing.md),
                        _LoginIconRow(colorScheme: scheme),
                      ],
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(AppSpacing.lg),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: scheme.surface.withOpacityValue(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: scheme.outline),
                        ),
                        child: AnimatedSwitcher(
                          duration: AppMotion.standard,
                          switchInCurve: AppMotion.enterCurve,
                          switchOutCurve: AppMotion.exitCurve,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: AppMotion.contentOffset,
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: KeyedSubtree(
                            key: ValueKey(
                                _step.name + _showConfirmPassword.toString()),
                            child: AutofillGroup(
                              child: _buildStepContent(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_step) {
      case _AuthStep.intent:
        return _buildIntentStep();
      case _AuthStep.method:
        return _buildMethodStep();
      case _AuthStep.email:
        return _buildEmailStep();
      case _AuthStep.password:
        return _buildPasswordStep();
      case _AuthStep.welcome:
        return _buildWelcomeStep();
    }
  }

  Widget _buildIntentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CleanPrimaryButton(
          label: context.t('sign_up'),
          onPressed: _isLoading
              ? null
              : () {
                  setState(() {
                    _intent = AuthIntent.signUp;
                    _step = _AuthStep.method;
                  });
                },
        ),
        const SizedBox(height: AppSpacing.md),
        _CleanTextButton(
          label: context.t('already_have_account'),
          onPressed: _isLoading
              ? null
              : () {
                  setState(() {
                    _intent = AuthIntent.signIn;
                    _step = _AuthStep.method;
                  });
                },
        ),
      ],
    );
  }

  Widget _buildMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _isSignUp
              ? context.t('create_your_account')
              : context.t('welcome_back_title'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (_formError != null) _buildInlineError(_formError!),
        const SizedBox(height: AppSpacing.md),
        _CleanPrimaryButton(
          label: context.t('continue_with_google'),
          onPressed: _isLoading ? null : _signInWithGoogle,
          isLoading: _isLoading,
        ),
        const SizedBox(height: AppSpacing.md),
        _CleanTextButton(
          label: context.t('enter_email_address'),
          onPressed: _isLoading ? null : () => _setStep(_AuthStep.email),
        ),
      ],
    );
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t('enter_your_email'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        _CleanInput(
          controller: _emailController,
          focusNode: _emailFocusNode,
          labelText: context.t('email_address'),
          hintText: context.t('email_address'),
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          textInputAction: TextInputAction.done,
          errorText: _emailError,
          onChanged: (_) {
            if (_emailError == null && _formError == null) {
              return;
            }
            setState(() {
              _emailError = null;
              _formError = null;
            });
          },
          onSubmitted: (_) => _submitEmailStep(),
        ),
        if (_formError != null) _buildInlineError(_formError!),
        const SizedBox(height: AppSpacing.md),
        _CleanPrimaryButton(
          label: context.t('continue'),
          onPressed: _isLoading ? null : _submitEmailStep,
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    final isConfirmVisible = _isSignUp && _showConfirmPassword;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isConfirmVisible
              ? context.t('confirm_password_title')
              : context.t('set_password'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        _CleanInput(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          labelText: context.t('password_hint'),
          hintText: context.t('password_hint'),
          obscureText: _obscurePassword,
          autofillHints: _isSignUp
              ? const [AutofillHints.newPassword]
              : const [AutofillHints.password],
          textInputAction:
              isConfirmVisible ? TextInputAction.next : TextInputAction.done,
          errorText: _passwordError,
          onChanged: (_) {
            if (_passwordError == null && _formError == null) {
              return;
            }
            setState(() {
              _passwordError = null;
              _formError = null;
            });
          },
          onSubmitted: (_) => _submitPasswordStep(),
          suffix: IconButton(
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            tooltip: context.t(
              _obscurePassword ? 'show_password' : 'hide_password',
            ),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (isConfirmVisible) ...[
          const SizedBox(height: AppSpacing.md),
          _CleanInput(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            labelText: context.t('confirm_password_hint'),
            hintText: context.t('confirm_password_hint'),
            obscureText: _obscureConfirmPassword,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.done,
            errorText: _confirmPasswordError,
            onChanged: (_) {
              if (_confirmPasswordError == null && _formError == null) {
                return;
              }
              setState(() {
                _confirmPasswordError = null;
                _formError = null;
              });
            },
            onSubmitted: (_) => _submitPasswordStep(),
            suffix: IconButton(
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              tooltip: context.t(
                _obscureConfirmPassword ? 'show_password' : 'hide_password',
              ),
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        if (_formError != null) _buildInlineError(_formError!),
        const SizedBox(height: AppSpacing.md),
        _CleanPrimaryButton(
          label: _isSignUp
              ? (isConfirmVisible
                  ? context.t('create_account')
                  : context.t('continue'))
              : context.t('log_in'),
          onPressed: _isLoading ? null : _submitPasswordStep,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildWelcomeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t('welcome'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.t('account_ready'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _CleanPrimaryButton(
          label: context.t('continue_with_app'),
          onPressed: _continueAfterWelcome,
        ),
      ],
    );
  }
}

class _LoginIconRow extends StatelessWidget {
  final ColorScheme colorScheme;

  const _LoginIconRow({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LiquidGlassIconBubble(
          icon: Icons.shield_rounded,
          size: 42,
          iconSize: 20,
          iconColor: colorScheme.onSurface,
          tintColor: colorScheme.primary,
          tintOpacity: 0.12,
        ),
        const SizedBox(width: AppSpacing.md),
        LiquidGlassIconBubble(
          icon: Icons.auto_awesome_rounded,
          size: 48,
          iconSize: 24,
          iconColor: colorScheme.onSurface,
          tintColor: colorScheme.secondary,
          tintOpacity: 0.14,
        ),
        const SizedBox(width: AppSpacing.md),
        LiquidGlassIconBubble(
          icon: Icons.menu_book_rounded,
          size: 42,
          iconSize: 20,
          iconColor: colorScheme.onSurface,
          tintColor: colorScheme.tertiary,
          tintOpacity: 0.12,
        ),
      ],
    );
  }
}

class _CleanPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _CleanPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onPressed == null || isLoading;
    return SizedBox(
      height: 58,
      child: LiquidGlassContainer(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(999),
        tintColor: scheme.primary,
        tintOpacity: disabled ? 0.1 : 0.24,
        borderColor: scheme.primary.withOpacityValue(disabled ? 0.35 : 0.72),
        child: Center(
          child: Text(
            isLoading ? context.t('please_wait') : label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: disabled
                      ? scheme.onSurface.withOpacityValue(0.45)
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _CleanTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _CleanTextButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 46,
      child: LiquidGlassContainer(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(999),
        tintColor: scheme.primary,
        tintOpacity: 0.08,
        borderColor: scheme.primary.withOpacityValue(0.32),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: disabled
                      ? scheme.onSurface.withOpacityValue(0.45)
                      : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class _CleanInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  const _CleanInput({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.textInputAction,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
      cursorColor: scheme.onSurface,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
        suffixIcon: suffix,
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacityValue(0.92),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
