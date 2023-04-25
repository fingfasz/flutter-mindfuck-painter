import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mindfuck_painter/domain/services/api_service_sketchpage.dart';
import 'package:flutter_mindfuck_painter/screens/home_page.dart';
import 'package:flutter_mindfuck_painter/widgets/expandable_fab_widget.dart';
import 'package:scribble/scribble.dart';

class SketchingPage extends StatefulWidget {
  const SketchingPage({super.key});

  @override
  State<SketchingPage> createState() => _SketchingPageState();
}

class _SketchingPageState extends State<SketchingPage> {
  late ScribbleNotifier notifier;

  // Default to white
  Color backgroundColor = Colors.white;
  Color penColor = Colors.black;
  bool isErasing = false;
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.send),
              tooltip: "Send your Sketch",
              onPressed: () async {
                bool success =
                    await renderImage(context, notifier, backgroundColor);
                if (success) {
                  Navigator.pop(context);
                  await Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => HomePage()));
                  setState(() {});
                } else {
                  return;
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.84,
          child: Stack(
            children: [
              Scribble(
                notifier: notifier,
                drawPen: true,
              ),
            ],
          ),
        ),
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
                  isErasing = false;
                  penColor = color;
                },
              ),
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const CircleBorder(side: BorderSide.none)),
                      iconColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.tertiary)),
                  child: const Icon(Icons.radio_button_checked),
                  onPressed: () {
                    //Eraser
                    penColor = Colors.transparent;
                    notifier.setEraser();
                    isErasing = true;
                    Navigator.pop(context, penColor);
                  }),
              Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.16)),
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
          if (isErasing) {
            notifier.setEraser();
            return;
          }
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
