import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePageHTTPCache extends StatefulWidget {
  const HomePageHTTPCache({super.key, required this.apiClient});
  final ApiClient apiClient;

  @override
  State<HomePageHTTPCache> createState() => _HomePageHTTPCacheState();
}

class _HomePageHTTPCacheState extends State<HomePageHTTPCache> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HTTP Cache'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
            });

          },
          child: const Icon(Icons.refresh),
        ),
        body: FutureBuilder(
          future: widget.apiClient.sendRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final json = jsonDecode(snapshot.data.toString());

              return Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CachedNetworkImage(imageUrl: json['owner']['avatar_url'], fit: BoxFit.fitHeight,),
                        title: Text(
                          json['name'],
                          style: const TextStyle(
                            fontSize: 24,
                          )
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          json['description'] ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Forks: ${json['forks_count']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Stars: ${json['stargazers_count']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Watchers: ${json['watchers_count']}',
                          style: const TextStyle(fontSize: 16),
                        ),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Last update: ${json['updated_at']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class ApiClient {
  String? etag;
  String? responseBody;

  Future<String?> sendRequest() async {
    const url =
        'https://api.github.com/repos/flutter/flutter'; // Example repository URL

    final headers = {
      'If-None-Match': etag ?? '',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // Update the cache values
      etag = response.headers['etag'];


      responseBody = response.body;
      // Do something with the response body
      print('Updated cache values');
    } else if (response.statusCode == 304) {
      // The resource has not been modified, use the cached response
      // Do something with the cached response body
      print('Cached response');
    } else {
      // Handle other response codes
    }
    return responseBody;
  }
}


