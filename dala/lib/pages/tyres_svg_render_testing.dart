import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

class Tyre {
  final String id;
  final String path;
  final String name;
  final bool isTyre;

  Tyre({
    required this.id,
    required this.path,
    required this.name,
    required this.isTyre,
  });
}

class Clipper extends CustomClipper<Path> {
  Clipper({required this.svgPath});

  String svgPath;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(svgPath);
    final Matrix4 matrix4 = Matrix4.identity();

    matrix4.scale(0.7, 0.7);

    return path.transform(matrix4.storage).shift(const Offset(-225, 100));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Future<List<Tyre>> loadSvgImage({required String svgImage}) async {
  List<Tyre> tires = [];

  String? generalString = await rootBundle.loadString(svgImage);

  XmlDocument document = XmlDocument.parse(generalString);

  final paths = document.findAllElements('path');

  for (var ele in paths) {
    String partId = ele.getAttribute('id').toString();
    String partPath = ele.getAttribute('d').toString();
    String name = ele.getAttribute('name').toString();
    bool isTyre = ele.getAttribute('isTyre').toString() == "1";

    tires.add(
      Tyre(id: partId, path: partPath, name: name, isTyre: isTyre),
    );
  }

  return tires;
}

// Widget to render a single clipped tyre with interactivity
class TyreWidget extends StatelessWidget {
  final Tyre tyre;
  final Function(Tyre tyre) onTapTyreSelected;
  final Function(Tyre tyre) onDoubleTabTyreSelected;
  final Color color;

  const TyreWidget({
    super.key,
    required this.tyre,
    required this.color,
    required this.onTapTyreSelected,
    required this.onDoubleTabTyreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: Clipper(svgPath: tyre.path),
      child: GestureDetector(
        onTap: () => onTapTyreSelected(tyre),
        child: Container(
          color: color,
        ),
        onDoubleTap: () => onDoubleTabTyreSelected(tyre),
      ),
    );
  }
}

class InteractiveSVGTyre extends StatefulWidget {
  final String svgAsset;
  final Function(Tyre)? onTapTyreSelected;
  final Function(Tyre)? onDoubleTabTyreSelected;

  const InteractiveSVGTyre({
    super.key,
    required this.svgAsset,
    this.onTapTyreSelected,
    this.onDoubleTabTyreSelected,
  });

  @override
  State<InteractiveSVGTyre> createState() => _InteractiveSVGTyreState();
}

class _InteractiveSVGTyreState extends State<InteractiveSVGTyre> {
  Future<List<Tyre>>? _tires;
  Tyre? _tapSelectedTyre;
  Tyre? _doubleTapSelectedTyre;

  @override
  void initState() {
    super.initState();
    _tires = loadSvgImage(svgImage: widget.svgAsset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tyre Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Tyre>>(
            future: _tires,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tires = snapshot.data!;
                return InteractiveViewer(
                  maxScale: 10.0,
                  minScale: 0.1,
                  child: Stack(
                    children: [
                      for (var tyre in tires)
                        TyreWidget(
                          tyre: tyre,
                          onTapTyreSelected: (selectedTyre) {
                            setState(() {
                              if (tyre.isTyre) _tapSelectedTyre = selectedTyre;
                            });
                          },
                          onDoubleTabTyreSelected: (selectedTyre) {
                            setState(() {
                              if (tyre.isTyre) {
                                _tapSelectedTyre = selectedTyre;
                                _doubleTapSelectedTyre = selectedTyre;
                              }
                            });
                          },
                          color: (tyre.isTyre)
                              ? Colors.black
                                  .withOpacity((_doubleTapSelectedTyre == null || _tapSelectedTyre != _doubleTapSelectedTyre)
                                      ? 1.0
                                      : _doubleTapSelectedTyre == tyre
                                          ? 1.0
                                          : 0.3)
                              : Colors.grey,
                        )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error loading SVG: ${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _tapSelectedTyre?.name ?? 'No Tyre Selected',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
