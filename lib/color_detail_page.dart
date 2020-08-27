import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb_menu/flutter_breadcrumb_menu.dart';
import 'package:replicatenaverror/app.dart';

class ColorDetailPage extends StatelessWidget {
  ColorDetailPage({this.color, this.title, this.materialIndex: 500});
  final MaterialColor color;
  final String title;
  final int materialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          '$title[$materialIndex]',
        ),
      ),
      bottomSheet: SizedBox.fromSize(
        child: Breadcrumb(breads: breadService.breads),
        size: Size.fromHeight(70),
      ),
      body: Container(
        color: color[materialIndex],
      ),
    );
  }
}
