import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/presentation/view/widgets/text_field.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/features/auth/presentation/sign_up/logic/sign_up_cubit.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: const _SignUpScreen(),
    );
  }
}

class _SignUpScreen extends StatefulWidget {
  const _SignUpScreen();

  @override
  State<_SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<_SignUpScreen> {
  static const minPasswordLength = 6;

  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool isVisiblePassword = false;
  bool isVisibleConfirmPassword = false;

  bool get isValidEmail => _emailFormKey.currentState?.validate() ?? false;

  bool get isValidPassword =>
      _passwordFormKey.currentState?.validate() ?? false;

  bool get isValidConfirmPassword =>
      _confirmPasswordFormKey.currentState?.validate() ?? false;

  bool get isValidInput =>
      isValidEmail && isValidPassword && isValidConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state is SignUpError) {
                context.showSnackBarFail(text: state.error);
              }

              if (state is SignUpLoaded) {
                context.pop(state.user);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.images.logoS.path,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 80.0),
                _buildEmailForm(),
                const SizedBox(height: 10.0),
                _buildPasswordForm(),
                const SizedBox(height: 10.0),
                _buildConfirmPasswordForm(),
                const SizedBox(height: 20.0),
                _buildSignUpButton(),
                const SizedBox(height: 40),
                _buildDivider(),
                const SizedBox(height: 40),
                _buildHasAccountLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Form(
      key: _emailFormKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: STextField(
          controller: emailCtrl,
          labelText: S.of(context).email,
          hintText: S.of(context).enter_your_email,
          validator: (value) {
            if (value == null) {
              return null;
            }

            if (!EmailValidator.validate(value)) {
              return S.of(context).invalid_email_format;
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Form(
      key: _passwordFormKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: STextField(
          controller: passwordCtrl,
          labelText: S.of(context).password,
          hintText: S.of(context).enter_your_password,
          obscureText: !isVisiblePassword,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisiblePassword = !isVisiblePassword;
              });
            },
            icon: Icon(
              isVisiblePassword ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          validator: (value) {
            if (value == null) {
              return null;
            }

            if (value.length < minPasswordLength) {
              return S.of(context).the_password_must_be_longer_than(minPasswordLength);
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordForm() {
    return Form(
      key: _confirmPasswordFormKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: STextField(
          controller: confirmPasswordCtrl,
          labelText: S.of(context).confirm_password,
          hintText: S.of(context).re_enter_password,
          obscureText: !isVisibleConfirmPassword,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisibleConfirmPassword = !isVisibleConfirmPassword;
              });
            },
            icon: Icon(
              isVisibleConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          validator: (value) {
            if (value == null) {
              return null;
            }

            if (value != passwordCtrl.text) {
              return S.of(context).passwords_do_not_match;
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      width: double.maxFinite,
      child: FilledButton(
        onPressed: () async {
          if (!isValidInput) {
            return;
          }
          context.read<SignUpCubit>().signUpWithEmailAndPassword(
                email: emailCtrl.text,
                password: passwordCtrl.text,
              );
        },
        child: Text(S.of(context).sign_up),
      ),
    );
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 80,
            vertical: 5,
          ),
          child: const Divider(),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).colorScheme.surface,
          child: Text(S.of(context).or),
        ),
      ],
    );
  }

  Widget _buildHasAccountLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${S.of(context).already_have_an_account} ",
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Text(
            S.of(context).login_now,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
