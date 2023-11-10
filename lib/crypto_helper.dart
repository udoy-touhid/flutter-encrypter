import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt_handle;

class CryptoHelper {
  //instead of plain text convert key,iv to base64 and use .fromBase64 for better security

  Future<void> encrypt(
      {required String inputPath,
      required String outputPath,
      required String key,
      required String iv}) async {
    final encryptionKey = encrypt_handle.Key.fromUtf8(key);
    final encryptionIv = encrypt_handle.IV.fromUtf8(iv);
    final encrypter = encrypt_handle.Encrypter(
        encrypt_handle.AES(encryptionKey, mode: encrypt_handle.AESMode.cbc));

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

    final encryptedData = encrypter.encryptBytes(fileContents, iv: encryptionIv);

    log('File Successfully Encrypted!');

    await outputFile.writeAsBytes(encryptedData.bytes);
  }

  Future<void> decrypt(
      {required String inputPath,
      required String outputPath,
      required String key,
      required String iv}) async {
    final encryptionKey = encrypt_handle.Key.fromUtf8(key);
    final encryptionIv = encrypt_handle.IV.fromUtf8(iv);
    final encrypter = encrypt_handle.Encrypter(
        encrypt_handle.AES(encryptionKey, mode: encrypt_handle.AESMode.cbc));

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

    final decrypted = encrypter.decryptBytes(encrypt_handle.Encrypted(fileContents), iv: encryptionIv);

    log('File Successfully Decrypted!');

    await outputFile.writeAsBytes(decrypted);
  }
}
