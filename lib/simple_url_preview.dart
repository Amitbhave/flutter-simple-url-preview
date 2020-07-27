library simple_url_preview;

import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:simple_url_preview/widgets/empty_container.dart';
import 'package:simple_url_preview/widgets/preview_description.dart';
import 'package:simple_url_preview/widgets/preview_image.dart';
import 'package:simple_url_preview/widgets/preview_site_name.dart';
import 'package:simple_url_preview/widgets/preview_title.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleUrlPreview extends StatefulWidget {
  final String url;
  final double previewHeight;
  final bool isClosable;
  final Color textColor;
  final Color bgColor;

  SimpleUrlPreview({
    @required this.url,
    this.previewHeight,
    this.isClosable,
    this.textColor,
    this.bgColor,
  });

  @override
  _SimpleUrlPreviewState createState() => _SimpleUrlPreviewState();
}

class _SimpleUrlPreviewState extends State<SimpleUrlPreview> {
  Map _urlPreviewData;
  bool _isVisible = true;
  bool _isClosable;
  double _previewHeight;
  Color _textColor;
  Color _bgColor;

  void getUrlData() async {
    if (!isURL(widget.url)) {
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    var response = await get(widget.url);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      Map data = {};
      extractOGData(document, data, 'og:title');
      extractOGData(document, data, 'og:description');
      extractOGData(document, data, 'og:site_name');
      extractOGData(document, data, 'og:image');

      if (data != null && data.isNotEmpty) {
        setState(() {
          _urlPreviewData = data;
          _isVisible = true;
        });
      }
    } else {
      setState(() {
        _urlPreviewData = null;
      });
    }
  }

  void extractOGData(Document document, Map data, String parameter) {
    var titleMetaTag = document.getElementsByTagName("meta")?.firstWhere(
        (meta) => meta.attributes['property'] == parameter,
        orElse: () => null);
    if (titleMetaTag != null) {
      data[parameter] = titleMetaTag.attributes['content'];
    }
  }

  void _launchURL() async {
    if (await canLaunch(Uri.encodeFull(widget.url))) {
      await launch(Uri.encodeFull(widget.url));
    } else {
      throw 'Could not launch ${widget.url}';
    }
  }

  @override
  void initState() {
    super.initState();
    reinitializeState();
  }

  @override
  void didUpdateWidget(SimpleUrlPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    reinitializeState();
  }

  void reinitializeState() {
    _isClosable = widget.isClosable ?? false;
    _textColor = widget.textColor ?? Colors.black;
    _bgColor = widget.bgColor ?? Colors.white;
    if (widget.previewHeight == null || widget.previewHeight < 150) {
      _previewHeight = 150;
    } else {
      _previewHeight = widget.previewHeight;
    }
    getUrlData();
  }

  @override
  Widget build(BuildContext context) {
    if (_urlPreviewData != null) {
      if (_isVisible) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: _previewHeight,
          child: Stack(children: [
            GestureDetector(
              onTap: _launchURL,
              child: buildPreviewCard(context),
            ),
            buildClosablePreview(),
          ]),
        );
      } else {
        return EmptyContainer();
      }
    } else {
      return EmptyContainer();
    }
  }

  Widget buildClosablePreview() {
    return _isClosable
        ? Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: _textColor,
              ),
              onPressed: () {
                setState(() {
                  _isVisible = false;
                });
              },
            ),
          )
        : EmptyContainer();
  }

  Card buildPreviewCard(BuildContext context) {
    return Card(
      elevation: 5,
      color: _bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                0.20,
            child: PreviewImage(_urlPreviewData['og:image'], _previewHeight),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PreviewTitle(_urlPreviewData['og:title'], _textColor),
                  PreviewDescription(
                      _urlPreviewData['og:description'], _textColor),
                  PreviewSiteName(_urlPreviewData['og:site_name'], _textColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
