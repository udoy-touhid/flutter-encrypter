import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt_handle;

class CryptoHelper {
  //instead of plain text convert key,iv to base64 and use .fromBase64 for better security
  static final _key = encrypt_handle.Key.fromUtf8('amaderlab1234567amaderlab1234567');
  static final _iv = encrypt_handle.IV.fromUtf8('amaderlab1234568');
  static final _encrypter =
      encrypt_handle.Encrypter(encrypt_handle.AES(_key, mode: encrypt_handle.AESMode.cbc));

  Future<void> encrypt(String inputPath, String outputPath) async {
    File inputFile = File(inputPath);
    File outputFile = File(outputPath);

    bool outputFileExists = await outputFile.exists();
    bool inputFileExists = await inputFile.exists();

    if (!outputFileExists) {
      await outputFile.create();
    }

    if (!inputFileExists) {
      throw Exception("Input file not found.");
    }

    log('Start loading file');
    final fileContents = await inputFile.readAsBytes();

    log('Start encrypting file');

    final encryptedData = _encrypter.encryptBytes(fileContents, iv: _iv);

    log('File Successfully Encrypted!');

    await outputFile.writeAsBytes(encryptedData.bytes);
  }

  Future<void> decrypt(String inputPath, String outputPath) async {
    File inputFile = File(inputPath);
    File outputFile = File(outputPath);

    bool outputFileExists = await outputFile.exists();
    bool inputFileExists = await inputFile.exists();

    if (!outputFileExists) {
      await outputFile.create();
    }

    if (!inputFileExists) {
      throw Exception("Input file not found.");
    }

    log('Start loading file');
    final fileContents = await inputFile.readAsBytes();
    // final decoded = base64.encode(_fileContents);

    log('Start decrypting file');

    final decrypted = _encrypter.decryptBytes(encrypt_handle.Encrypted(fileContents), iv: _iv);

    log('File Successfully Decrypted!');

    await outputFile.writeAsBytes(decrypted);
  }
}
