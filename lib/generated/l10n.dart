// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enter_your_email {
    return Intl.message(
      'Enter your email',
      name: 'enter_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enter_your_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Don't have account?`
  String get do_not_have_account {
    return Intl.message(
      'Don\'t have account?',
      name: 'do_not_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Create now`
  String get create_now {
    return Intl.message(
      'Create now',
      name: 'create_now',
      desc: '',
      args: [],
    );
  }

  /// `Sign up success. Please login`
  String get sign_up_success {
    return Intl.message(
      'Sign up success. Please login',
      name: 'sign_up_success',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalid_email_format {
    return Intl.message(
      'Invalid email format',
      name: 'invalid_email_format',
      desc: '',
      args: [],
    );
  }

  /// `The password must be longer than {minLength} characters`
  String the_password_must_be_longer_than(Object minLength) {
    return Intl.message(
      'The password must be longer than $minLength characters',
      name: 'the_password_must_be_longer_than',
      desc: '',
      args: [minLength],
    );
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message(
      'Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account!`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account!',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Login now`
  String get login_now {
    return Intl.message(
      'Login now',
      name: 'login_now',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter password`
  String get re_enter_password {
    return Intl.message(
      'Re-enter password',
      name: 're_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Hello {username}`
  String hello(Object username) {
    return Intl.message(
      'Hello $username',
      name: 'hello',
      desc: '',
      args: [username],
    );
  }

  /// `Hello user`
  String get hello_user {
    return Intl.message(
      'Hello user',
      name: 'hello_user',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `What's on your mind?`
  String get new_post_box {
    return Intl.message(
      'What\'s on your mind?',
      name: 'new_post_box',
      desc: '',
      args: [],
    );
  }

  /// `An error occur`
  String get an_error_occur {
    return Intl.message(
      'An error occur',
      name: 'an_error_occur',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get dark_theme {
    return Intl.message(
      'Dark theme',
      name: 'dark_theme',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get old_password {
    return Intl.message(
      'Old password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your old password`
  String get enter_old_password {
    return Intl.message(
      'Enter your old password',
      name: 'enter_old_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get enter_new_password {
    return Intl.message(
      'Enter your new password',
      name: 'enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Change password success`
  String get change_password_success {
    return Intl.message(
      'Change password success',
      name: 'change_password_success',
      desc: '',
      args: [],
    );
  }

  /// `Old password invalid`
  String get old_password_invalid {
    return Intl.message(
      'Old password invalid',
      name: 'old_password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Type your message`
  String get type_message {
    return Intl.message(
      'Type your message',
      name: 'type_message',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous user`
  String get anonymous {
    return Intl.message(
      'Anonymous user',
      name: 'anonymous',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message(
      'Post',
      name: 'post',
      desc: '',
      args: [],
    );
  }

  /// `New post`
  String get new_post {
    return Intl.message(
      'New post',
      name: 'new_post',
      desc: '',
      args: [],
    );
  }

  /// `Post by`
  String get post_by {
    return Intl.message(
      'Post by',
      name: 'post_by',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Delete message`
  String get delete_message {
    return Intl.message(
      'Delete message',
      name: 'delete_message',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this message?`
  String get delete_message_confirmation {
    return Intl.message(
      'Are you sure you want to delete this message?',
      name: 'delete_message_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Showing name`
  String get showing_name {
    return Intl.message(
      'Showing name',
      name: 'showing_name',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Cannot delete other user message`
  String get cannot_delete_other_user_message {
    return Intl.message(
      'Cannot delete other user message',
      name: 'cannot_delete_other_user_message',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `No image selected`
  String get no_image_selected {
    return Intl.message(
      'No image selected',
      name: 'no_image_selected',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No notifications available.`
  String get no_notifications {
    return Intl.message(
      'No notifications available.',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `No Title`
  String get no_title {
    return Intl.message(
      'No Title',
      name: 'no_title',
      desc: '',
      args: [],
    );
  }

  /// `No Message`
  String get no_message {
    return Intl.message(
      'No Message',
      name: 'no_message',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as Read`
  String get mark_all_read {
    return Intl.message(
      'Mark all as Read',
      name: 'mark_all_read',
      desc: '',
      args: [],
    );
  }

  /// `{time} ago`
  String time_ago(Object time) {
    return Intl.message(
      '$time ago',
      name: 'time_ago',
      desc: '',
      args: [time],
    );
  }

  /// `Update user's information`
  String get update_information {
    return Intl.message(
      'Update user\'s information',
      name: 'update_information',
      desc: '',
      args: [],
    );
  }

  /// `Please update your profile image and others information.`
  String get update_avatar_and_other_information {
    return Intl.message(
      'Please update your profile image and others information.',
      name: 'update_avatar_and_other_information',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
