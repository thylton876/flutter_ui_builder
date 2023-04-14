import 'package:flutter/material.dart';

import 'utils.dart';

class ParseError extends Error {}

bool? parseBool(String? text, {bool? defaultValue}) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  return (text == '1' || lowerCaseText == 'true')
      ? true
      : (text == '0' || lowerCaseText == 'false')
          ? false
          : throw ParseError();
}

BorderStyle? parseBorderStyle(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'none':
      return BorderStyle.none;
    case 'solid':
      return BorderStyle.solid;
    default:
      return null;
  }
}

BoxFit? parseBoxFit(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fitheight':
      return BoxFit.fitHeight;
    case 'fitwidth':
      return BoxFit.fitWidth;
    case 'none':
      return BoxFit.none;
    case 'scaledown':
      return BoxFit.scaleDown;
    default:
      return null;
  }
}

Color? parseColour(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'brown':
      return Colors.brown;
    default:
      return null;
  }
}

FontStyle? parseFontStyle(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'normal':
      return FontStyle.normal;
    case 'italic':
      return FontStyle.italic;
    default:
      return null;
  }
}

FontWeight? parseFontWeight(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'bold':
      return FontWeight.bold;
    case 'normal':
      return FontWeight.normal;
    case 'w100':
      return FontWeight.w100;
    case 'w200':
      return FontWeight.w200;
    case 'w300':
      return FontWeight.w300;
    case 'w400':
      return FontWeight.w400;
    case 'w500':
      return FontWeight.w500;
    case 'w600':
      return FontWeight.w600;
    case 'w700':
      return FontWeight.w700;
    case 'w800':
      return FontWeight.w800;
    case 'w900':
      return FontWeight.w900;
    default:
      throw Exception();
  }
}

MainAxisAlignment? parseMainAxisAlignment(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'center':
      return MainAxisAlignment.center;
    case 'end':
      return MainAxisAlignment.end;
    case 'spacearound':
      return MainAxisAlignment.spaceAround;
    case 'spacebetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceevenly':
      return MainAxisAlignment.spaceEvenly;
    case 'start':
      return MainAxisAlignment.start;
    default:
      throw Exception('Invalid main-axis-alignment: $text.');
  }
}

CrossAxisAlignment? parseCrossAxisAlignment(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'baseline':
      return CrossAxisAlignment.baseline;
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    case 'start':
      return CrossAxisAlignment.start;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    default:
      throw ArgumentError('Invalid cross-axis-alignment: $text.');
  }
}

TextDecoration parseTextDecoration(String? text) {
  if (text.isNullEmpty) {
    return TextDecoration.none;
  }

  final lowerCaseText = text?.toLowerCase();

  switch (lowerCaseText) {
    case 'linethrough':
      return TextDecoration.lineThrough;
    case 'overline':
      return TextDecoration.overline;
    case 'underline':
      return TextDecoration.underline;
    default:
      return TextDecoration.none;
  }
}

TextDecoration? parseTextDecorations(String? text) {
  if (text.isNullEmpty) {
    return null;
  }

  final lowerCaseText = text?.toLowerCase();

  final decorations =
      lowerCaseText!.split(' ').map((e) => e.trim()).map(parseTextDecoration);

  return TextDecoration.combine(decorations.toList());
}

TextStyle? parseTextStyle(Map<Object, String> attributes) {
  final backgroundColor = parseColour(attributes['background-color']);
  final color = parseColour(attributes['color']);
  final decoration = parseTextDecorations(attributes['decorations']);
  final fontFamily = attributes['font-family'];
  final fontSize = attributes['font-size']
      .apply((value) => value.isNotNullEmpty ? double.parse(value!) : null);
  final fontStyle = parseFontStyle(attributes['font-style']);
  final fontWeight = parseFontWeight(attributes['font-weight']);

  return TextStyle(
    backgroundColor: backgroundColor,
    color: color,
    decoration: decoration,
    fontFamily: fontFamily,
    fontStyle: fontStyle,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}
