abstract class ElementNames {
  static const String alertDialog = 'alert-dialog';
  static const String align = 'align';
  static const String appBar = 'app-bar';
  static const String border = 'border';
  static const String borderRadius = 'border-radius';
  static const String borderSide = 'border-side';
  static const String boxDecoration = 'box-decoration';
  static const String button = 'button';
  static const String center = 'center';
  static const String column = 'column';
  static const String container = 'container';
  static const String customScrollView = 'custom-scroll-view';
  static const String decorationImage = 'decoration-image';
  static const String div = 'div';
  static const String expanded = 'expanded';
  static const String flexible = 'flexible';
  static const String form = 'form';
  static const String gridView = 'grid-view';
  static const String h1 = 'h1';
  static const String h2 = 'h2';
  static const String h3 = 'h3';
  static const String h4 = 'h4';
  static const String h5 = 'h5';
  static const String h6 = 'h6';
  static const List<String> headings = [h1, h2, h3, h4, h5, h6];
  static const String icon = 'icon';
  static const String image = 'image';
  static const String img = 'img';
  static const String input = 'input';
  static const String inputBorder = 'input-border';
  static const String inputDecoration = 'input-decoration';
  static const String listView = 'list-view';
  static const String margin = 'margin';
  static const String networkImage = 'network-image';
  static const String paragraph = 'p';
  static const String padding = 'padding';
  static const String preferredSize = 'preferred-size';
  static const String row = 'row';
  static const String scaffold = 'scaffold';
  static const String simpleDialog = 'simple-dialog';
  static const String showDialog = 'show-dialog';
  static const String singleChildScrollView = 'single-child-scroll-view';
  static const String sizedBox = 'sized-box';
  static const String spacer = 'spacer';
  static const String textarea = 'textarea';
  static const String textFormField = 'text-form-field';
}

bool isHtmlHeadingElement(String elementName) {
  return ElementNames.headings.contains(elementName);
}

abstract class HtmlElementNames {}

class FlutterElementNames {}
