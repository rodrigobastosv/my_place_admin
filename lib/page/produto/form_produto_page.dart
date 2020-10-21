import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FormProdutoPage extends StatefulWidget {
  @override
  _FormProdutoPageState createState() => _FormProdutoPageState();
}

class _FormProdutoPageState extends State<FormProdutoPage> {
  List<Asset> images = List<Asset>();

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
      );
    } on Exception {}

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                images = await MultiImagePicker.pickImages(
                  enableCamera: true,
                  maxImages: 3,
                  materialOptions: MaterialOptions(
                    actionBarTitle: "Action bar",
                    allViewTitle: "All view title",
                    actionBarColor: "#aaaaaa",
                    actionBarTitleColor: "#bbbbbb",
                    lightStatusBar: false,
                    statusBarColor: '#abcdef',
                    startInAllView: true,
                    selectCircleStrokeColor: "#000000",
                    selectionLimitReachedText: "You can't select any more.",
                  ),
                );
                setState(() {
                  
                });
              },
              child: Text('Escolher imagens'),
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.check),
      ),
    );
  }
}
