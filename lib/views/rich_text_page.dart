import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class RichTextPage extends StatefulWidget {
  final Function(String) onInstructionsSaved;

  const RichTextPage({super.key, required this.onInstructionsSaved});

  @override
  State<RichTextPage> createState() => _RichTextPageState();
}

class _RichTextPageState extends State<RichTextPage> {
  final FocusNode _focusNode = FocusNode();
  late flutter_quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = QuillController(
    //   document: Document(),
    //   selection: const TextSelection.collapsed(offset: 0),
    //   // Customizing the toolbar options
    //   toolbarOptions: ToolbarOptions(
    //     // Disabling image insertion
    //     showImagePickOption: false,
    //   ),
    // );
    // _controller = flutter_quill.QuillController.basic();
    _controller = flutter_quill.QuillController(
      document: flutter_quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void handleHtmlChange(String html) {
    final sanitizedHtml = sanitizeHtml(html);
    _controller.document.delete(0, html.length);
    _controller.document.insert(0, sanitizedHtml);
  }

  String sanitizeHtml(String html) {
    final parsedHtml = html_parser.parse(html);
    if (parsedHtml.body != null) {
      sanitizeElements(parsedHtml.body!.children);
      return parsedHtml.body!.innerHtml;
    }
    return "No body for sanitizing";
  }

  void sanitizeElements(List<html_dom.Node> nodes) {
    for (var i = nodes.length - 1; i >= 0; i--) {
      final node = nodes[i];
      if (node is html_dom.Element) {
        if (node.localName == null) {
          continue;
        }
        final tagName = node.localName!.toLowerCase();
        if (tagName == 'table' || tagName == 'script') {
          node.remove();
        } else {
          sanitizeElements(node.children);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar instruções'),
      ),
      body: Column(children: [
        flutter_quill.QuillToolbar.basic(controller: _controller),
        Expanded(
          child: Container(
            child: flutter_quill.QuillEditor.basic(
              controller: _controller,
              readOnly: false, // true for view only mode
            ),
          ),
        )
      ]),
      // body: flutter_quill.QuillEditor(

      //   scrollController: ScrollController(),
      //   padding: const EdgeInsets.all(8.0),
      //   expands: true,
      //   controller: _controller,
      //   focusNode: _focusNode,
      //   readOnly: false,
      //   scrollable: true,
      //   autoFocus: false,
      //   minHeight: 200,
      //   maxHeight: 400,
      //   // Handle HTML changes

      //   // onHtmlChanged: handleHtmlChange, //TODO usar isso de alguma forma...

      //   // Customizing the available formats
      //   customStyles: flutter_quill.DefaultStyles(
      //     // Allowing only bold text
      //     bold: const TextStyle(fontWeight: FontWeight.bold),

      //     // Allowing headers (h1, h2, h3)
      //     // heading1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //     // heading2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //     // heading3: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final plainText = _controller.document.toPlainText();
          print(plainText);
          widget.onInstructionsSaved(plainText);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
