import 'package:flutter/material.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Url Preview Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Simple Url Preview Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = '';

  _onUrlChanged(String updatedUrl) {
    setState(() {
      _url = updatedUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SimpleUrlPreview(
            url: _url,
            textColor: Colors.white,
            bgColor: Colors.red,
            isClosable: true,
            titleLines: 2,
            descriptionLines: 3,
            imageLoaderColor: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              onChanged: (newValue) => _onUrlChanged(newValue),
              decoration: InputDecoration(
                hintText: 'Enter the url',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
