// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
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
  String get localeName => 'vi';

  static String m0(username) => "Xin chào ${username}";

  static String m1(minLength) => "Mật khẩu phải dài hơn ${minLength} ký tự";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "already_have_an_account":
            MessageLookupByLibrary.simpleMessage("Đã có tài khoản!"),
        "an_error_occur":
            MessageLookupByLibrary.simpleMessage("Đã có lỗi xảy ra!"),
        "change_password": MessageLookupByLibrary.simpleMessage("Đổi mật khẩu"),
        "change_password_success":
            MessageLookupByLibrary.simpleMessage("Đổi mật khẩu thành công"),
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Xác nhận mật khẩu"),
        "create_now": MessageLookupByLibrary.simpleMessage("Tạo tài khoản"),
        "dark_theme": MessageLookupByLibrary.simpleMessage("Giao diện tối"),
        "do_not_have_account":
            MessageLookupByLibrary.simpleMessage("Chưa có tài khoản?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "english": MessageLookupByLibrary.simpleMessage("Tiếng anh"),
        "enter_new_password":
            MessageLookupByLibrary.simpleMessage("Nhập mật khẩu cũ"),
        "enter_old_password":
            MessageLookupByLibrary.simpleMessage("Nhập mật khẩu cũ"),
        "enter_your_email":
            MessageLookupByLibrary.simpleMessage("Nhập email của bạn"),
        "enter_your_password":
            MessageLookupByLibrary.simpleMessage("Nhập mật khẩu của bạn"),
        "hello": m0,
        "hello_user":
            MessageLookupByLibrary.simpleMessage("Xin chào người dùng"),
        "invalid_email_format":
            MessageLookupByLibrary.simpleMessage("Sai định dạng email"),
        "language": MessageLookupByLibrary.simpleMessage("Ngôn ngữ"),
        "login": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "login_now": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "logout": MessageLookupByLibrary.simpleMessage("Đăng xuất"),
        "message": MessageLookupByLibrary.simpleMessage("Tin nhắn"),
        "new_password": MessageLookupByLibrary.simpleMessage("Mật khẩu mới"),
        "new_post": MessageLookupByLibrary.simpleMessage("Bạn đang nghĩ gì?"),
        "old_password": MessageLookupByLibrary.simpleMessage("Mật khẩu cũ"),
        "old_password_invalid":
            MessageLookupByLibrary.simpleMessage("Mật khẩu cũ không hợp lệ"),
        "or": MessageLookupByLibrary.simpleMessage("Hoặc"),
        "password": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
        "passwords_do_not_match":
            MessageLookupByLibrary.simpleMessage("Mật khẩu không trùng khớp"),
        "re_enter_password":
            MessageLookupByLibrary.simpleMessage("Nhập lại mật khẩu"),
        "settings": MessageLookupByLibrary.simpleMessage("Cài đặt"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Đăng ký"),
        "sign_up_success": MessageLookupByLibrary.simpleMessage(
            "Đăng ký thành công. Vui lòng đăng nhập"),
        "the_password_must_be_longer_than": m1,
        "vietnamese": MessageLookupByLibrary.simpleMessage("Tiếng việt")
      };
}
