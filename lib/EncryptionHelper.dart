import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';

class DateEncryptor {
  // Define a 32-character key
  final Key _key = Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 characters
  // Use a fixed IV for simplicity (can also generate a random IV and store it alongside the encrypted string)
  final IV _iv = IV.fromUtf8('16byteslongIV123'); // 16 characters

  // Encrypt a DateTime
  String encrypt(DateTime date) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final formattedDate = DateFormat('dd-MM-yyyy').format(date); // Format date
    final encrypted = encrypter.encrypt(formattedDate, iv: _iv); // Encrypt
    return encrypted.base64; // Return encrypted string
  }

  // Decrypt an encrypted string back to DateTime
  DateTime decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv); // Decrypt
    DateTime a =  DateFormat('dd-MM-yyyy').parse(decrypted);
    return a;// Parse back to DateTime
  }
}


