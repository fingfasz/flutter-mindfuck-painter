import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mindfuck_painter/widgets/expandable_fab_widget.dart';
import 'package:scribble/scribble.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_mindfuck_painter/domain/services/api_service.dart';

// Unsure if we need this tbh
final storage = FlutterSecureStorage();

class SketchingPage extends StatefulWidget {
  @override
  State<SketchingPage> createState() => _SketchingPageState();
}

class _SketchingPageState extends State<SketchingPage> {
  late ScribbleNotifier notifier;

  // Default to white
  Color backgroundColor = Colors.white;
  Color penColor = Colors.black;
  late double strokeWidth;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    strokeWidth = notifier.widths.first;
    notifier.setStrokeWidth(strokeWidth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: MediaQuery.of(context).size.height / 5,
        children: [
          // Stroke Width
          ActionButton(
            onPressed: () => onSelected(context, 2),
            icon: const Icon(Icons.draw),
          ),
          // Background
          ActionButton(
            onPressed: () => onSelected(context, 1),
            icon: const Icon(Icons.featured_video),
          ),
          // Pen Color
          ActionButton(
            onPressed: () => onSelected(context, 0),
            icon: const Icon(Icons.color_lens),
          ),
          ActionButton(
            onPressed: () => notifier.canUndo ? notifier.undo() : null,
            icon: const Icon(Icons.undo),
          ),
          ActionButton(
            onPressed: () => notifier.canRedo ? notifier.redo() : null,
            icon: const Icon(Icons.redo),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // title: Text(""),
        automaticallyImplyLeading: false,
        actions: [
          // PopupMenuButton<int>(
          //   onSelected: (item) => onSelected(context, item),
          //   itemBuilder: (context) => [
          //     PopupMenuItem<int>(
          //       value: 0,
          //       child: Row(
          //         children: const [
          //           Icon(
          //             Icons.color_lens,
          //           ),
          //           SizedBox(width: 8),
          //           Text('Change Color'),
          //         ],
          //       ),
          //     ),
          //     PopupMenuItem<int>(
          //       value: 1,
          //       child: Row(
          //         children: const [
          //           Icon(
          //             Icons.drafts,
          //           ),
          //           SizedBox(width: 8),
          //           Text('Change Background Color'),
          //         ],
          //       ),
          //     ),
          //     PopupMenuItem<int>(
          //       value: 2,
          //       child: Row(
          //         children: const [
          //           Icon(
          //             Icons.draw,
          //           ),
          //           SizedBox(width: 8),
          //           Text('Change Pen'),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          IconButton(
            icon: const Icon(Icons.send),
            tooltip: "Send your Sketch",
            onPressed: () => _saveImage(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.84,
          // height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Scribble(
                notifier: notifier,
                drawPen: true,
              ),
              // Positioned(
              //   top: 16,
              //   right: 16,
              // child: Row(
              //   children: [
              //     _buildStrokeToolbar(context),
              //     _buildColorToolbar(context),
              //     const Divider(
              //       height: 32,
              //     ),
              //   ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final image = await notifier.renderImage();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Image"),
        content: Image.memory(image.buffer.asUint8List()),
      ),
    );
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      // Change Color
      case 0:
        final newColor = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Pick a color!"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: penColor,
                onColorChanged: (color) {
                  penColor = color;
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context, penColor),
              ),
            ],
          ),
        );
        if (newColor != null) {
          notifier.setColor(newColor);
          penColor = newColor;
        }
        break;
      // Change Background Color
      case 1:
        final newColor = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Pick a background color!"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: backgroundColor,
                onColorChanged: (color) {
                  backgroundColor = color;
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context, backgroundColor),
              ),
            ],
          ),
        );
        if (newColor != null) {
          setState(() {
            backgroundColor = newColor;
          });
        }
        break;
      // Change Pen
      case 2:
        final newWidth = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Pick a pen size!"),
            content: SingleChildScrollView(
              child: Column(
                children: notifier.widths
                    .map(
                      (e) => ListTile(
                        title: Text(
                          "Size ${e.floor()}",
                          style: TextStyle(fontSize: e + 15),
                        ),
                        onTap: () => Navigator.pop(context, e),
                      ),
                    )
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        if (newWidth != null) {
          notifier.setStrokeWidth(newWidth);
          strokeWidth = newWidth;
        }
        break;
    }
  }
}
