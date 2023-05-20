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
  static const _toolBarConfig = [
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
    ToolBarStyle.align
  ];

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
            toolBarConfig: _toolBarConfig,
          ),
          Expanded(
            child: QuillHtmlEditor(
              text: widget.initialHtml,
              hintText: 'Digite aqui, e use as opções acima para personalizar o texto!',
              controller: _controller,
              isEnabled: true,
              minHeight: 300,
              hintTextAlign: TextAlign.start,
              padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
              hintTextPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
