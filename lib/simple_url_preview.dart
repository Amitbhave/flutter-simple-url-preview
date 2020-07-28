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

/// Provides URL preview
class SimpleUrlPreview extends StatefulWidget {
  /// URL for which preview is to be shown
  final String url;

  /// Height of the preview
  final double previewHeight;

  /// Whether or not to show close button for the preview
  final bool isClosable;

  /// Text color
  final Color textColor;

  /// Background color
  final Color bgColor;

  /// Number of lines for Title. (Max possible lines = 2)
  final int titleLines;

  /// Number of lines for Description. (Max possible lines = 3)
  final int descriptionLines;

  /// Color for loader icon shown, till image loads
  final Color imageLoaderColor;

  SimpleUrlPreview({
    @required this.url,
    this.previewHeight,
    this.isClosable,
    this.textColor,
    this.bgColor,
    this.titleLines,
    this.descriptionLines,
    this.imageLoaderColor,
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
  int _titleLines;
  int _descriptionLines;
  Color _imageLoaderColor;

  void _getUrlData() async {
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
      _extractOGData(document, data, 'og:title');
      _extractOGData(document, data, 'og:description');
      _extractOGData(document, data, 'og:site_name');
      _extractOGData(document, data, 'og:image');

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

  void _extractOGData(Document document, Map data, String parameter) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    reinitializeState();
  }

  @override
  void didUpdateWidget(SimpleUrlPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    reinitializeState();
  }

  void reinitializeState() {
    _isClosable = widget.isClosable ?? false;
    _textColor = widget.textColor ?? Theme.of(context).accentColor;
    _bgColor = widget.bgColor ?? Theme.of(context).primaryColor;
    _imageLoaderColor =
        widget.imageLoaderColor ?? Theme.of(context).accentColor;
    _initializeTitleLines();
    _initializeDescriptionLines();
    _initializePreviewHeight();
    _getUrlData();
  }

  void _initializePreviewHeight() {
    if (widget.previewHeight == null || widget.previewHeight < 150) {
      _previewHeight = 150;
    } else {
      _previewHeight = widget.previewHeight;
    }
  }

  void _initializeDescriptionLines() {
    if (widget.descriptionLines == null ||
        (widget.descriptionLines > 3 || widget.descriptionLines < 1)) {
      _descriptionLines = 3;
    } else {
      _descriptionLines = widget.descriptionLines;
    }
  }

  void _initializeTitleLines() {
    if (widget.titleLines == null ||
        (widget.titleLines > 2 || widget.titleLines < 1)) {
      _titleLines = 2;
    } else {
      _titleLines = widget.titleLines;
    }
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
              child: _buildPreviewCard(context),
            ),
            _buildClosablePreview(),
          ]),
        );
      } else {
        return EmptyContainer();
      }
    } else {
      return EmptyContainer();
    }
  }

  Widget _buildClosablePreview() {
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

  Card _buildPreviewCard(BuildContext context) {
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
                0.25,
            child: PreviewImage(
              _urlPreviewData['og:image'],
              _previewHeight,
              _imageLoaderColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PreviewTitle(
                    _urlPreviewData['og:title'],
                    _textColor,
                    _titleLines,
                  ),
                  PreviewDescription(
                    _urlPreviewData['og:description'],
                    _textColor,
                    _descriptionLines,
                  ),
                  PreviewSiteName(
                    _urlPreviewData['og:site_name'],
                    _textColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
