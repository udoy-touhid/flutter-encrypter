import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Please select file to encrypt"),
            SizedBox(
              height: 10,
            ),
            BaseButton(
              buttonWidth: 300,
              iconVisible: false,
              buttonLabel: 'Select File to upload',
              onClick: () async {
                selectedFile =
                    await FilePicker.platform.pickFiles(type: FileType.any, withReadStream: true);
                setState(() {});
                if (selectedFile != null) {
                  print(selectedFile!.files.first.extension?.toLowerCase() ?? "");
                  // if (!acceptableFormats
                  //     .contains(result!.files.first.extension?.toLowerCase() ?? "")) {
                  //   EasyLoading.showError("File must be of type ${acceptableFormats.toString()}");
                  //   print(result!.files.first.name);
                  //
                  //   result = null;
                  // }
                } else {
                  print("cancelled");
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
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
            SizedBox(height: 50),
            if (selectedFile != null)
              BaseButton(
                onClick: () async {
                  await widget.cryptoHelper.encrypt(selectedFile!.files.first.path ?? "",
                      "${(await getDownloadsDirectory())!.path}/myfile.${selectedFile!.files.first.extension}.enc");

                  await widget.cryptoHelper.decrypt("${(await getDownloadsDirectory())!.path}/myfile.${selectedFile!.files.first.extension}.enc",
                      "${(await getDownloadsDirectory())!.path}/decrypted-myfile.${selectedFile!.files.first.extension}");


                },
                iconVisible: false,
                buttonLabel: "Encrypt now!",
                buttonWidth: 300,
              )
          ],
        ),
      ),
    );
  }
}
