import 'package:flutter/material.dart';

import '../model/model_berita.dart';

class DetailBeritaPage extends StatelessWidget {
  final Datum? berita;

  const DetailBeritaPage(this.berita, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(berita?.judul ?? "Detail Berita"),
      ),
      body: SingleChildScrollView(         child: Column(
          children: [
            if (berita?.gambar != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'http://192.168.43.124/uas_mobile/image/${berita!.gambar}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                berita?.judul ?? "",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Author: ${berita?.author ?? ""}',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Created: ${berita?.created.toString() ?? ""}',
                    style: TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                berita?.konten ?? "",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
