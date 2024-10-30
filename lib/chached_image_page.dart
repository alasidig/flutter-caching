import 'package:cached_network_image/cached_network_image.dart';
import 'package:caching_lec/text_with_bg_widget.dart';
import 'package:flutter/material.dart';

class HomePageCachedNetworkImage extends StatefulWidget {
  const HomePageCachedNetworkImage({super.key});

  @override
  State<HomePageCachedNetworkImage> createState() =>
      _HomePageCachedNetworkImageState();
}

class _HomePageCachedNetworkImageState
    extends State<HomePageCachedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistence'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextBoxWithBackground(text: 'CachedNetworkImage', backgroundColor: Colors.green),
          Container(
            width: 450,
            height: 200,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 4),
            ),
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/250?image=9',
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              ),
            ),
          ),
          const TextBoxWithBackground(
            text: 'Image.network',
            backgroundColor: Colors.blue,
          ),
          Container(
            width: 450,
            height: 200,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 4),
            ),
            child: Image.network('https://picsum.photos/250?image=8',
                loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            }, errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              );
            }),
          )
        ],
      ),
    );
  }
}
