import 'package:html/dom.dart' as html_dom;

class If {
  const If({
    required this.expression,
    required this.documentFragment,
  });

  final String expression;
  final html_dom.DocumentFragment documentFragment;

  Iterable<Object> evaluate() sync* {}
}

class For {
  const For({
    required this.expression,
    required this.documentFragment,
  });

  final String expression;
  final html_dom.DocumentFragment documentFragment;

  Iterable<Object> evaluate() sync* {}
}

class Switch {
  const Switch({
    required this.cases,
    this.defaultCase,
  });

  final Map<String, SwitchCase> cases;
  final SwitchDefault? defaultCase;

  Iterable<Object> evaluate() sync* {}
}

class SwitchCase {
  const SwitchCase({
    required this.key,
    required this.documentFragment,
  });

  final String key;
  final html_dom.DocumentFragment documentFragment;
}

class SwitchDefault {
  SwitchDefault({
    required this.documentFragment,
  });

  final html_dom.DocumentFragment documentFragment;
}

class Content {
  Content({
    required this.id,
    required this.build,
  });

  final String id;
  final Iterable<Object> Function() build;
}
