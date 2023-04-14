import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/behaviors.dart';
import 'package:html/dom.dart' as html_dom;

import 'core.dart';
import 'parsers.dart';
import 'templating/core.dart';
import 'eventing/ui_event.dart';
import 'state_management/ui_state.dart';
import 'utils.dart';

Iterable<AlertDialog> buildAlertDialog(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  //final childWidgets = children.whereType<Widget>().toList();
}

Iterable<Align> buildAlign(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final element = node as html_dom.Element;

  yield const Align();
}

Iterable<AppBar> buildAppBar(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  bool automaticallyImplyLeading = parseBool(
          element.attributes['automatically-imply-leading'],
          defaultValue: true) ??
      true;

  Color? backgroundColor = parseColour(element.attributes['background-color']);
  Color? foregroundColor = parseColour(element.attributes['foreground-color']);

  bool? centerTitle =
      parseBool(element.attributes['center-title'], defaultValue: null);

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  final actionsContent =
      children.whereType<Content>().where((c) => c.id == 'actions').firstOrNull;
  final bottomContent =
      children.whereType<Content>().where((c) => c.id == 'bottom').firstOrNull;
  final leadingContent =
      children.whereType<Content>().where((c) => c.id == 'leading').firstOrNull;
  final titleContent =
      children.whereType<Content>().where((c) => c.id == 'title').firstOrNull;

  yield AppBar(
    actions: actionsContent?.build().whereType<Widget>().toList(),
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom:
        bottomContent?.build().whereType<PreferredSizeWidget>().singleOrNull,
    centerTitle: centerTitle,
    foregroundColor: foregroundColor,
    leading: leadingContent?.build().whereType<Widget>().singleOrNull,
    title: titleContent?.build().whereType<Widget>().singleOrNull ??
        childWidgets.singleWidgetOrNull(),
  );
}

Iterable<Border> buildBorder(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final sides = children.whereType<BorderSide>().toList();

  yield Border(
    top: sides[0],
    right: sides[0],
    bottom: sides[0],
    left: sides[0],
  );
}

Iterable<BorderRadius> buildBorderRadius(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final element = node as html_dom.Element;

  yield BorderRadius.circular(10);
}

Iterable<BorderSide> buildBorderSide(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final color = parseColour(element.attributes['color']) ?? Colors.black;
  final strokeAlign = element.attributes['stroke-align']
      .apply((value) => value.isNotNullEmpty ? double.parse(value!) : 1.0);
  final style =
      parseBorderStyle(element.attributes['style']) ?? BorderStyle.solid;
  final width = element.attributes['width']
      .apply((value) => value.isNotNullEmpty ? double.parse(value!) : 1.0);

  yield BorderSide(
    color: color,
    strokeAlign: strokeAlign,
    style: style,
    width: width,
  );
}

Iterable<ButtonStyleButton> buildButton(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final id = element.attributes['id'];
  final key = id.isNotNullEmpty ? Key(id!) : null;

  final label = element.attributes['label'] ?? '';

  yield ElevatedButton(
    onPressed: () {
      raiseEventFunc(
        UiEvent(
          eventType: UiEventTypes.buttonPressed,
          widgetId: id,
          widgetKey: key,
          node: node,
          payload: null,
        ),
      );
    },
    key: key,
    child: Text(label),
  );
}

Iterable<Center> buildCenter(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Center(child: childWidgets.singleWidgetOrDefault());
}

Iterable<Column> buildColumn(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final mainAxisAlignment =
      parseMainAxisAlignment(element.attributes['main-axis-alignment']) ??
          MainAxisAlignment.start;

  final crossAxisAlignment =
      parseCrossAxisAlignment(element.attributes['cross-axis-alignment']) ??
          CrossAxisAlignment.start;

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Column(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    children: childWidgets,
  );
}

Iterable<Container> buildContainer(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final width = element.attributes['width']
      .apply((value) => value.isNotNullEmpty ? double.parse(value!) : null);

  final height = element.attributes['height']
      .apply((value) => value.isNotNullEmpty ? double.parse(value!) : null);

  final color = parseColour(element.attributes['color']);

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  final decoration = children.whereType<Decoration>().singleOrNull;

  yield Container(
    color: color,
    decoration: decoration,
    height: height,
    width: width,
    child: childWidgets.singleWidgetOrDefault(),
  );
}

Iterable<CustomScrollView> buildCustomScrollView(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield CustomScrollView(
    slivers: childWidgets,
  );
}

Iterable<Decoration> buildDecoration(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final color = parseColour(element.attributes['color']);

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();

  final border = children.whereType<Border>().singleOrNull;
  final borderRadius = children.whereType<BorderRadius>().singleOrNull;
  final image = children.whereType<DecorationImage>().singleOrNull;

  yield BoxDecoration(
    border: border,
    borderRadius: borderRadius,
    color: color,
    image: image,
  );
}

Iterable<DecorationImage> buildDecorationImage(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final fit = parseBoxFit(element.attributes['fit']);

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();

  final image = children.whereType<ImageProvider>().singleOrNull;

  yield DecorationImage(
    image: image!,
    fit: fit,
  );
}

Iterable<EdgeInsets> buildEdgeInsets(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  yield const EdgeInsets.all(0);
}

Iterable<Expanded> buildExpanded(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Expanded(
    child: childWidgets.singleWidgetOrDefault(),
  );
}

Iterable<Icon> buildIcon(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final codePoint = int.parse(element.attributes['code-point'] ?? '0');
  final iconData =
      IconData(codePoint, fontFamily: element.attributes['font-family']);

  yield Icon(iconData);
}

Iterable<Image> buildImage(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  yield Image.network(element.attributes['src'] ?? element.attributes['url']!);
}

Iterable<Flexible> buildFlexible(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Flexible(
    flex: 1,
    fit: FlexFit.tight,
    child: childWidgets.singleWidgetOrDefault(),
  );
}

Iterable<Form> buildForm(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Form(
    autovalidateMode: AutovalidateMode.always,
    child: childWidgets.singleWidgetOrDefault(),
  );
}

Iterable<FormField> buildFormField(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final id = element.attributes['id'];
  final key = id.isNotNullEmpty ? Key(id!) : null;

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final inputDecoration = children.whereType<InputDecoration>().singleOrNull;

  FormField? widget;

  widget = TextFormField(
    decoration: inputDecoration,
    key: key,
  );

  yield widget;
}

Iterable<GridView> buildGridView(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield GridView.count(
    crossAxisCount: 2,
    children: childWidgets,
  );
}

Iterable<InputBorder> buildInputBorder(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final type = element.attributes['type']?.toLowerCase();

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();

  final borderRadius = children.whereType<BorderRadius>().singleOrNull ??
      BorderRadius.circular(10);

  final borderSide = children.whereType<BorderSide>().singleOrNull ??
      const BorderSide(
        color: Colors.green,
        strokeAlign: 0,
        style: BorderStyle.solid,
        width: 5,
      );

  if (type == 'underline') {
    yield UnderlineInputBorder(
      borderSide: borderSide,
      borderRadius: borderRadius,
    );
  } else if (type == 'outline') {
    yield OutlineInputBorder(
      borderSide: borderSide,
      borderRadius: borderRadius,
    );
  }
}

Iterable<InputDecoration> buildInputDecoration(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final counterText = element.attributes['counter-text'];
  final helperText = element.attributes['helper-text'];
  final hintText = element.attributes['hint-text'];
  final labelText = element.attributes['label-text'] ?? '';

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();

  final border = children.whereType<InputBorder>().singleOrNull;

  final iconContent =
      children.whereType<Content>().where((c) => c.id == 'icon').firstOrNull;

  final icon = iconContent?.build().whereType<Widget>().firstOrNull;

  yield InputDecoration(
    counterText: counterText,
    enabledBorder: border,
    helperText: helperText,
    hintText: hintText,
    icon: icon,
    labelText: labelText,
    //prefix: icon,
    //prefixIcon: icon,
    //suffix: icon,
    //suffixIcon: icon,
  );
}

Iterable<ListView> buildListView(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final shrinkWrap = element.attributes['shink-wrap'] == 'true';

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield ListView(
    shrinkWrap: shrinkWrap,
    children: childWidgets,
  );
}

Iterable<NetworkImage> buildNetworkImage(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final url = element.attributes['src'] ?? element.attributes['url']!;

  yield NetworkImage(url);
}

Iterable<Padding> buildPadding(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Padding(
    padding: const EdgeInsets.all(0),
    child: childWidgets.singleWidgetOrDefault(),
  );
}

Iterable<PreferredSize> buildPreferredSize(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  //yield PreferredSize(
  //preferredSize: Size.fromHeight(height),
  //child: childWidgets.singleWidgetOrDefault(),
  //);
}

Iterable<PreferredSizeWidget> buildPreferredSizeWidget(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  //yield PreferredSize(
  //preferredSize: Size.fromHeight(height),
  //child: childWidgets.singleWidgetOrDefault(),
  //);
}

Iterable<Row> buildRow(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final mainAxisAlignment =
      parseMainAxisAlignment(element.attributes['main-axis-alignment']) ??
          MainAxisAlignment.start;

  final crossAxisAlignment =
      parseCrossAxisAlignment(element.attributes['cross-axis-alignment']) ??
          CrossAxisAlignment.start;

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield Row(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    children: childWidgets,
  );
}

Iterable<Scaffold> buildScaffold(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  //final appBarContent =
  //    children.whereType<Content>().where((c) => c.id == 'appbar').firstOrNull;

  final bodyContent =
      children.whereType<Content>().where((c) => c.id == 'body').firstOrNull;

  final bottomSheetContent = children
      .whereType<Content>()
      .where((c) => c.id.toLowerCase() == 'bottomsheet')
      .firstOrNull;

  final floatingActionButtonContent = children
      .whereType<Content>()
      .where((c) => c.id.toLowerCase() == 'floatingactionbutton')
      .firstOrNull;

  final persistentFooterButtonsContent = children
      .whereType<Content>()
      .where((c) => c.id.toLowerCase() == 'persistentfooterbuttons')
      .firstOrNull;

  yield Scaffold(
    appBar: childWidgets.whereType<AppBar>().singleOrNull,
    body: bodyContent?.build().whereType<Widget>().singleOrNull ??
        childWidgets
            .where((child) =>
                child is! AppBar &&
                child is! NavigationBar &&
                child is! BottomNavigationBar)
            .toList()
            .singleWidgetOrDefault(),
    floatingActionButton:
        floatingActionButtonContent?.build().whereType<Widget>().firstOrNull,
    bottomSheet: bottomSheetContent?.build().whereType<Widget>().firstOrNull,
    persistentFooterButtons:
        persistentFooterButtonsContent?.build().whereType<Widget>().toList(),
    bottomNavigationBar: childWidgets.firstWhereOrNull(
        (child) => child is NavigationBar || child is BottomNavigationBar),
  );
}

Iterable<Object> buildShowDialog(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final dialogType = element.attributes['type']?.trim().toLowerCase();
  final isModal =
      parseBool(element.attributes['modal'], defaultValue: false) ?? false;

  final isDismissable =
      parseBool(element.attributes['dismissable'], defaultValue: false) ?? true;

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  final widgetContent = children
      .whereType<Content>()
      .where((c) => c.id.toLowerCase() == 'widget')
      .firstOrNull;

  final dialogContent = children
      .whereType<Content>()
      .where((c) => c.id.toLowerCase() == 'dialog')
      .firstOrNull;

  dialogBuilder(context) {
    return dialogContent?.build().whereType<Widget>().firstOrNull ??
        const Placeholder();
  }

  onTap() {
    switch (dialogType) {
      case 'bottomsheet':
        if (isModal) {
          showModalBottomSheet(
            context: buildContext,
            builder: dialogBuilder,
            isDismissible: isDismissable,
          );
        } else {
          showModalBottomSheet(
            context: buildContext,
            builder: dialogBuilder,
            isDismissible: isDismissable,
          );
        }
        break;

      default:
        showDialog(
          context: buildContext,
          builder: dialogBuilder,
          barrierDismissible: isDismissable,
        );
        break;
    }
  }

  yield GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: widgetContent?.build().whereType<Widget>().firstOrNull ??
        childWidgets.firstOrNull,
  );
}

Iterable<SimpleDialog> buildSimpleDialog(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  //final childWidgets = children.whereType<Widget>().toList();
}

Iterable<SingleChildScrollView> buildSingleChildScrollView(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield SingleChildScrollView(
    child: childWidgets.singleWidgetOrDefault(),
  );
}

Iterable<SizedBox> buildSizedBox(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final childWidgets = children.whereType<Widget>().toList();

  yield SizedBox(
    child: childWidgets.singleWidgetOrNull(),
  );
}

Iterable<Spacer> buildSpacer(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  final flex = element.attributes['flex']
      .apply((value) => value?.trim())
      .apply((value) => value.isNullEmpty ? 0 : int.parse(value));

  yield Spacer(flex: flex);
}

Iterable<RichText> buildText(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  TextStyle? textStyle =
      node is html_dom.Element ? parseTextStyle(node.attributes) : null;

  final children = buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();
  final textChildren = children
      .where((c) =>
          c is html_dom.Text || c is Text || c is TextSpan || c is RichText)
      .toList();

  yield RichText(
    text: TextSpan(
      style: textStyle,
      children: textChildren.map(
        (c) {
          if (c is html_dom.Text) {
            return TextSpan(text: c.text);
          } else if (c is Text) {
            return TextSpan(text: c.data);
          } else if (c is TextSpan) {
            return c;
          } else if (c is RichText) {
            return c.text;
          }
          throw ArgumentError();
        },
      ).toList(),
    ),
  );
}
