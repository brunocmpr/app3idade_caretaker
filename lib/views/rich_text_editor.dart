import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class RichTextEditor extends StatefulWidget {
  final String? initialHtml;

  const RichTextEditor({Key? key, this.initialHtml}) : super(key: key);

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  final QuillEditorController _controller = QuillEditorController();

  @override
  void initState() {
    super.initState();

    if (widget.initialHtml != null) {
      _controller.setText(widget.initialHtml!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruções'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () async {
              var navigator = Navigator.of(context);
              final html = await _controller.getText();
              navigator.pop(html);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ToolBar(
            controller: _controller,
            spacing: 2.0,
            toolBarColor: Colors.blueGrey.shade100,
            toolBarConfig: const [
              ToolBarStyle.undo,
              ToolBarStyle.redo,
              ToolBarStyle.bold,
              ToolBarStyle.italic,
              ToolBarStyle.underline,
              ToolBarStyle.background,
              ToolBarStyle.color,
              ToolBarStyle.size,
              ToolBarStyle.headerOne,
              ToolBarStyle.headerTwo,
              ToolBarStyle.listBullet,
              ToolBarStyle.listOrdered,
              ToolBarStyle.align,
            ],
          ),
          Expanded(
            child: QuillHtmlEditor(
                text: widget.initialHtml,
                hintText: 'Digite aqui!',
                controller: _controller,
                isEnabled: true,
                minHeight: 300,
                // textStyle: _editorTextStyle,
                // hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 5),
                hintTextPadding: EdgeInsets.zero,
                // backgroundColor: _backgroundColor,
                onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
                onEditorResized: (height) => debugPrint('Editor resized $height'),
                onSelectionChanged: (sel) => debugPrint('${sel.index},${sel.length}')),
          ),
        ],
      ),
    );
  }
}
