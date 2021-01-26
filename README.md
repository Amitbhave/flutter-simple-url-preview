# simple_url_preview 
[![likes](https://badges.bar/simple_url_preview/likes)](https://pub.dev/packages/simple_url_preview/score)
[![pub points](https://badges.bar/simple_url_preview/pub%20points)](https://pub.dev/packages/simple_url_preview/score)
[![popularity](https://badges.bar/simple_url_preview/popularity)](https://pub.dev/packages/simple_url_preview/score)

Flutter package to show url preview

![In Action](https://github.com/Amitbhave/flutter-simple-url-preview/blob/master/preview_in_action.png)

## Getting Started

This shows url preview of a URL.

Currently only supports [Open Graph Protocol](https://www.ogp.me/)

Please use latest version of the package.

## How to use ?

Add simple_url_preview to pubspec.yaml, and hit command 'flutter pub get'
```yaml
dependencies:
  ...
  simple_url_preview: ^1.1.1
```

#### 1) **Simple use:**
```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
),
```

#### 2) **Override preview height, padding.(Default and minimum possible height is 130):**
```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
  previewHeight: 200,
  previewContainerPadding: EdgeInsets.all(10),
),
```

#### 3) **Override text color and background color:**

Default textColor = Theme.of(context).accentColor

Default bgColor = Theme.of(context).primaryColor

```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
  textColor: Colors.white,
  bgColor: Colors.red,
),
```

#### 4) **Override title, description, and site style:**

Default titleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: textColor
)

Default descriptionTyle = TextStyle(
  fontSize: 14,
  color: textColor
)

Default siteStyle = TextStyle(
  fontSize: 14,
  color: textColor
)

```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
  isClosable: true,
  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  descriptionStyle: TextStyle(fontSize: 12),
  siteStyle: TextStyle(fontSize: 12, color: Colors.blueAccent),
),
```

#### 5) **If you want closable preview (Click on x to close the preview.):**
```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
  isClosable: true,
),
```

#### 6) **Override image loader color and title and description lines:**

Default and maximum title lines = 2 and description lines = 3.

```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
  titleLines: 1,
  descriptionLines: 2,
  imageLoaderColor: Colors.white,
),
```

#### 7) **Override onTap callback of the URL preview:**

By Default, will open URL in default browser.

```dart
SimpleUrlPreview(
  url: 'https://pub.dev/',
  onTap: () => print('Hello Flutter URL Preview'),
),
```

### Contribution:

Would :heart: to see any contributions.

### Appreciate:
If you liked my work, show some :heart: by :star: repo.

Also you can appreciate by

<p>
 <table style="border-spacing: 5px 10px;">

 <tr>
  <td>
<a href="https://www.buymeacoffee.com/amitbhave10"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" style="max-width:90%;" width="200" height="60"></a>
</td>

  <td style="margin: 10px">
<a href="https://paypal.me/amitbhave10"><img src="https://www.paypalobjects.com/webstatic/mktg/Logo/pp-logo-200px.png" alt="PayPal Logo"
style="max-width:90%;" width="200" height="60">
 </td>
 </tr>
 </table>
</p> 
