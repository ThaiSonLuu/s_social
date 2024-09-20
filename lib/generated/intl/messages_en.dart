// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(username) => "Hello ${username}";

  static String m1(minLength) =>
      "The password must be longer than ${minLength} characters";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "already_have_an_account":
            MessageLookupByLibrary.simpleMessage("Already have an account!"),
        "an_error_occur":
            MessageLookupByLibrary.simpleMessage("An error occur!"),
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "create_now": MessageLookupByLibrary.simpleMessage("Create now"),
        "do_not_have_account":
            MessageLookupByLibrary.simpleMessage("Don\'t have account?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enter_your_email":
            MessageLookupByLibrary.simpleMessage("Enter your email"),
        "enter_your_password":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "hello": m0,
        "hello_user": MessageLookupByLibrary.simpleMessage("hello user"),
        "invalid_email_format":
            MessageLookupByLibrary.simpleMessage("Invalid email format"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "login_now": MessageLookupByLibrary.simpleMessage("Login now"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "or": MessageLookupByLibrary.simpleMessage("Or"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwords_do_not_match":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "re_enter_password":
            MessageLookupByLibrary.simpleMessage("Re-enter password"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
        "sign_up_success": MessageLookupByLibrary.simpleMessage(
            "Sign up success. Please login"),
        "the_password_must_be_longer_than": m1
      };
}
