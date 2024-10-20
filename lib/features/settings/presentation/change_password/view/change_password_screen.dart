import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/presentation/view/widgets/text_field.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/features/settings/presentation/change_password/logic/change_password_cubit.dart';
import 'package:s_social/generated/l10n.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: const _ChangePasswordScreen(),
    );
  }
}

class _ChangePasswordScreen extends StatefulWidget {
  const _ChangePasswordScreen();

  @override
  State<_ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<_ChangePasswordScreen> {
  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool isVisibleOldPassword = false;
  bool isVisibleNewPassword = false;
  bool isVisibleConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).change_password),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordError) {
                context.showSnackBarFail(text: state.error);
              }

              if (state is ChangePasswordSuccess) {
                context.pop(true);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                _buildOldPasswordForm(),
                const SizedBox(height: 10.0),
                _buildPasswordForm(),
                const SizedBox(height: 10.0),
                _buildConfirmPasswordForm(),
                const SizedBox(height: 20.0),
                _buildChangePasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOldPasswordForm() {
    return Form(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: STextField(
          controller: oldPasswordCtrl,
          labelText: S.of(context).old_password,
          hintText: S.of(context).enter_old_password,
          obscureText: !isVisibleOldPassword,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisibleOldPassword = !isVisibleOldPassword;
              });
            },
            icon: Icon(
              isVisibleOldPassword ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      child: STextField(
        controller: newPasswordCtrl,
        labelText: S.of(context).new_password,
        hintText: S.of(context).enter_new_password,
        obscureText: !isVisibleNewPassword,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isVisibleNewPassword = !isVisibleNewPassword;
            });
          },
          icon: Icon(
            isVisibleNewPassword ? Icons.visibility : Icons.visibility_off,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        validator: (value) {
          if (value == null) {
            return null;
          }

          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordForm() {
    return Container(
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
            isVisibleConfirmPassword ? Icons.visibility : Icons.visibility_off,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      width: double.maxFinite,
      child: FilledButton(
        onPressed: () async {
          await context.read<ChangePasswordCubit>().changePassword(
                oldPassword: oldPasswordCtrl.text,
                newPassword: newPasswordCtrl.text,
                confirmPassword: confirmPasswordCtrl.text,
              );
        },
        child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          builder: (context, state) {
            if (state is ChangePasswordLoading) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              );
            }
            return Text(S.of(context).change_password);
          },
        ),
      ),
    );
  }
}
