import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePageSecureStorage extends StatefulWidget {
  const HomePageSecureStorage({super.key});

  @override
  State<HomePageSecureStorage> createState() => _HomePageSecureStorageState();
}

class _HomePageSecureStorageState extends State<HomePageSecureStorage> {
  String? _course = 'Press the read button to get the stored data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_course ?? 'No Stored data'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    getSecureData().then((value) => _course = value);
                  });
                },
                child: const Text('Read'),
              ),
              const ElevatedButton(
                onPressed: storeSecureData,
                child: Text('Save'),
              ),
              const ElevatedButton(
                onPressed: clearSecureData,
                child: Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Future<String?> getSecureData() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'Course');
}
Future<void> storeSecureData() async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'Course', value: 'SWE463');
}
Future<void> clearSecureData() async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'Course');
}

