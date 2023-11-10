import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

import 'base_button.dart';
import 'crypto_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Encrypter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Encrypter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final CryptoHelper cryptoHelper = CryptoHelper();

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? selectedFile;
  var keyController = TextEditingController(text: "12345678123456781234567812345678");
  var ivController = TextEditingController(text: "1234567812345678");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "key",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: keyController,
                      maxLength: 32,
                    )),
                const Text(
                  "iv",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: ivController,
                      maxLength: 16,
                    )),
              ],
            ),
            SizedBox(height: 40),
            const Text("Please select file to encrypt/decrypt"),
            const SizedBox(height: 10),
            BaseButton(
              buttonWidth: 300,
              iconVisible: false,
              buttonLabel: 'Select File to upload',
              onClick: () async {
                selectedFile =
                    await FilePicker.platform.pickFiles(type: FileType.any, withReadStream: true);
                setState(() {});
                if (selectedFile != null) {
                  print("Selected file ${selectedFile!.files.first.name}");
                } else {
                  print("cancelled");
                }
              },
            ),
            const SizedBox(height: 20),
            if (selectedFile != null)
              Card(
                child: Container(
                    width: 220,
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedFile = null;
                                });
                              },
                              icon: const Icon(Icons.close_rounded)),
                        ),
                        Text(selectedFile!.files.first.name),
                      ],
                    )),
              ),
            const SizedBox(height: 50),
            if (selectedFile != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseButton(
                    onClick: () async {
                      await widget.cryptoHelper.encrypt(
                          inputPath: selectedFile!.files.first.path ?? "",
                          outputPath:
                              "${(await getDownloadsDirectory())!.path}/${selectedFile!.files.first.name}.enc",
                          key: keyController.text,
                          iv: ivController.text);

                      EasyLoading.showSuccess("Done");
                    },
                    iconVisible: false,
                    buttonLabel: "Encrypt now!",
                    buttonWidth: 300,
                  ),
                  const SizedBox(width: 10),
                  BaseButton(
                    onClick: () async {
                      await widget.cryptoHelper.decrypt(
                          inputPath: selectedFile!.files.first.path ?? "",
                          outputPath:
                              "${(await getDownloadsDirectory())!.path}/${selectedFile!.files.first.name}.decrypted",
                          key: keyController.text,
                          iv: ivController.text);

                      EasyLoading.showSuccess("Done");
                    },
                    iconVisible: false,
                    buttonLabel: "Decrypt now!",
                    buttonWidth: 300,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
