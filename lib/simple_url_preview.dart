library simple_url_preview;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  /// Container padding
  final EdgeInsetsGeometry previewContainerPadding;

  /// onTap URL preview, by default opens URL in default browser
  final VoidCallback onTap;

  SimpleUrlPreview({
    @required this.url,
    this.previewHeight = 130.0,
    this.isClosable,
    this.textColor,
    this.bgColor,
    this.titleLines = 2,
    this.descriptionLines = 3,
    this.imageLoaderColor,
    this.previewContainerPadding,
    this.onTap,
  })  : assert(previewHeight >= 130.0,
            'The preview height should be greater than or equal to 130'),
        assert(titleLines <= 2 && titleLines > 0,
            'The title lines should be less than or equal to 2 and not equal to 0'),
        assert(descriptionLines <= 3 && descriptionLines > 0,
            'The description lines should be less than or equal to 3 and not equal to 0');

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
  EdgeInsetsGeometry _previewContainerPadding;
  VoidCallback _onTap;

  @override
  void initState() {
    super.initState();
    _getUrlData();
  }

  @override
  void didUpdateWidget(SimpleUrlPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getUrlData();
  }

  void _initialize() {
    _previewHeight = widget.previewHeight;
    _descriptionLines = widget.descriptionLines;
    _titleLines = widget.titleLines;
    _previewContainerPadding = widget.previewContainerPadding;
    _onTap = widget.onTap ?? _launchURL;
  }

  void _getUrlData() async {
    final _pref = await SharedPreferences.getInstance();
    if (!isURL(widget.url)) {
      setState(() {
        _urlPreviewData = null;
      });
      return;
    }

    final cachedData = _pref.getString(widget.url);
    if (cachedData != null) {
      setState(() {
        _urlPreviewData = jsonDecode(cachedData);
        _isVisible = true;
      });
    }

    var response = await get(widget.url);
    if (response.statusCode != 200) {
      if (!this.mounted) {
        return;
      }

      setState(() {
        _urlPreviewData = null;
      });
    }

    var document = parse(response.body);
    Map data = {};
    _extractOGData(document, data, 'og:title');
    _extractOGData(document, data, 'og:description');
    _extractOGData(document, data, 'og:site_name');
    _extractOGData(document, data, 'og:image');

    if (!this.mounted) {
      return;
    }

    if (data != null && data.isNotEmpty) {
      _pref.setString(widget.url, jsonEncode(data));
      setState(() {
        _urlPreviewData = data;
        _isVisible = true;
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
  Widget build(BuildContext context) {
    _isClosable = widget.isClosable ?? false;
    _textColor = widget.textColor ?? Theme.of(context).accentColor;
    _bgColor = widget.bgColor ?? Theme.of(context).primaryColor;
    _imageLoaderColor =
        widget.imageLoaderColor ?? Theme.of(context).accentColor;
    _initialize();

    if (_urlPreviewData == null || !_isVisible) {
      return SizedBox();
    }

    return Container(
      padding: _previewContainerPadding,
      height: _previewHeight,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _onTap,
            child: _buildPreviewCard(context),
          ),
          _buildClosablePreview(),
        ],
      ),
    );
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
        : SizedBox();
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
