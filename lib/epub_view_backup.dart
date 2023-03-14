import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class EpubView extends StatefulWidget {
  @override
  _EpubViewState createState() => _EpubViewState();
}

class _EpubViewState extends State<EpubView> {
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  @override
  void initState() {
    download();
    super.initState();
  }

  download() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await downloadFile();
    } else {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0x5686b918),
            statusBarBrightness: Brightness.light,
          ),
          title: const Text('Vocsy Plugin E-pub example'),
          backgroundColor: Color(0xFF86b918),
          elevation: 0,
        ),
        body: Center(
          child: loading
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Downloading.... E-pub'),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  print("=====filePath======$filePath");
                  VocsyEpub.setConfig(
                    themeColor: Theme.of(context).primaryColor,
                    identifier: "iosBook",
                    scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                    allowSharing: true,
                    enableTts: true,
                    nightMode: true,
                  );

                  // get current locator
                  VocsyEpub.locatorStream.listen((locator) {
                    print('LOCATOR: $locator');
                  });

                  VocsyEpub.open(
                    filePath,
                    lastLocation: EpubLocator.fromJson({
                      "bookId": "2239",
                      "href": "/OEBPS/ch06.xhtml",
                      "created": 1539934158390,
                      "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
                    }),
                  );
                },
                child: Text('Open Online E-pub'),
              ),
              ElevatedButton(
                onPressed: () async {
                  VocsyEpub.setConfig(
                    themeColor: Theme.of(context).primaryColor,
                    identifier: "iosBook",
                    scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                    allowSharing: true,
                    enableTts: true,
                    nightMode: true,
                  );
                  // get current locator
                  VocsyEpub.locatorStream.listen((locator) {
                    print('LOCATOR: $locator');
                  });
                  await VocsyEpub.openAsset(
                    'assets/4.epub',
                    lastLocation: EpubLocator.fromJson({
                      "bookId": "2239",
                      "href": "/OEBPS/ch06.xhtml",
                      "created": 1539934158390,
                      "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
                    }),
                  );
                },
                child: Text('Open Assets E-pub'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future downloadFile() async {
    if (await Permission.storage.isGranted) {
      await Permission.storage.request();
      await startDownload();
    } else {
      await startDownload();
    }
  }

  startDownload() async {
    Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();

    String path = appDocDir!.path + '/chair.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        "https://vocsyinfotech.in/envato/cc/flutter_ebook/uploads/22566_The-Racketeer---John-Grisham.epub",
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print((receivedBytes / totalBytes * 100).toStringAsFixed(0));
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
        });
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
      });
    }
  }
}