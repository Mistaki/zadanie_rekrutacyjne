import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zadanie_rekrutacyjne/photos.dart';
import 'package:http/http.dart' as http;
import 'package:zadanie_rekrutacyjne/photos_from_API.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  Future<List<Photo>> fetchPhotos(http.Client client) async {
    try {
      final response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      final list = json.decode(response.body) as List;
      final parsedList = list.map((model) {
        return Photo.fromJson(model);
      }).toList();
      return parsedList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Photo>>(
            future: fetchPhotos(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data![index].thumbnailUrl);
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}