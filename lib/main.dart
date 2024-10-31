import 'package:caching_lec/chached_image_page.dart';
import 'package:caching_lec/secure_storage_page.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import 'http_caching_page.dart';
import 'objectbox.g.dart';
import 'objectbox_page.dart';
Future<void> storeData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Course', 'SWE463');
}

//get stored data
Future<String?> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('Course');
}
//clear stored data
Future<void> clearData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('Course');
}
late Store store;
initObjectBox() async {
  final docDir = await getApplicationDocumentsDirectory();
  store = Store(
    getObjectBoxModel(),
    directory: path.join(docDir.path, 'objectbox'),
  );
  print('saving to ${path.join(docDir.path, 'objectbox')}');
}
late ApiClient apiClient;


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  apiClient = ApiClient();
  await initObjectBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _course = 'Press the read button to get the stored data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Other caching examples'),
            ),
            ListTile(
              title: const Text('Secure Storage'),
              leading: const Icon(Icons.security),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePageSecureStorage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Cached Image'),
              leading: const Icon(Icons.image),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePageCachedNetworkImage(),
                  ),
                );
              }
            ),
            ListTile(
              title: const Text('ObjectBox'),
              leading: const Icon(Icons.storage),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  HomePageObjectBox(store: store,),
                  ),
                );
              }
            ),
            ListTile(
              title: const Text('HTTP Caching'),
              leading: const Icon(Icons.cloud),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageHTTPCache(apiClient: apiClient,),
                  ),
                );
              }
            ),
          ],
        ),
      ) ,
      appBar: AppBar(
        title: const Text('Persistence'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(_course ?? 'No Stored data'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  getData().then((value) => _course = value);
                });
              },
              child: const Text('Read'),
            ),
            const ElevatedButton(
              onPressed: storeData,
              child: Text('Save'),
            ),const ElevatedButton(
              onPressed: clearData,
              child: Text('Clear'),
            ),
          ],
        ),
      ],),
    );
  }
}


