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
     final response = await client
         .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

       return compute(parsePhotos, response.body) as List<Photo>;

     }
   @override
   void initState() {
     super.initState();
     fetchPhotos(http.Client());
   }
   late List<Photo> photos = fetchPhotos(http.Client()) as List<Photo>;
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
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return Image.network(photos[index].thumbnailUrl);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        ));
  }
}
