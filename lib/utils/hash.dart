import 'dart:convert';

import 'package:crypto/crypto.dart';

class HASH {
  static String hash_md5(String input) {
    var bytes = utf8.encode(input);
    var digest = md5.convert(bytes);
    print("gggggggggggggggggg${digest}");
    return digest.toString();
  }
}
