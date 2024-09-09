import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

class InteractiveSVGMap extends StatefulWidget {
  final String svgAsset;
  final Function(Country)? onCountrySelected;

  const InteractiveSVGMap({
    super.key,
    required this.svgAsset,
    this.onCountrySelected,
  });

  @override
  State<InteractiveSVGMap> createState() => _InteractiveSVGMapState();
}

class _InteractiveSVGMapState extends State<InteractiveSVGMap> {
  Future<List<Country>>? _countries;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _countries = loadSvgImage(svgImage: widget.svgAsset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Map Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Country>>(
            future: _countries,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final countries = snapshot.data!;
                return InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 0.1,
                  child: Stack(
                    children: [
                      for (var country in countries)
                        CountryWidget(
                          country: country,
                          onCountrySelected: (selectedCountry) {
                            setState(() {
                              _selectedCountry = selectedCountry;
                            });
                          },
                          color:
                              country.color.withOpacity(_selectedCountry == null
                                  ? 1.0
                                  : _selectedCountry == country
                                      ? 1.0
                                      : 0.3),
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
                _selectedCountry?.name ?? 'No Country Selected',
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

Future<List<Country>> loadSvgImage({required String svgImage}) async {
  List<Country> maps = [];

  String? generalString = await rootBundle.loadString(svgImage);

  XmlDocument document = XmlDocument.parse(generalString);

  final paths = document.findAllElements('path');

  for (var ele in paths) {
    String partId = ele.getAttribute('id').toString();
    String partPath = ele.getAttribute('d').toString();
    String name = ele.getAttribute('name').toString();
    String color = ele.getAttribute('color').toString();

    maps.add(Country(
        id: partId,
        path: partPath,
        name: name,
        color: Color(int.parse('FF$color', radix: 16))));
  }

  return maps;
}

class Country {
  final String id;
  final String path;
  final String name;
  final Color color;

  Country(
      {required this.id,
      required this.path,
      required this.name,
      required this.color});
}

class Clipper extends CustomClipper<Path> {
  Clipper({required this.svgPath});

  String svgPath;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(svgPath);
    final Matrix4 matrix4 = Matrix4.identity();

    matrix4.scale(1.1, 1.1);

    return path.transform(matrix4.storage).shift(const Offset(-220, 0));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Widget _getClippedImage({
//   required Clipper clipper,
//   required Color color,
//   required Country country,
//   final Function(Country country)? onCountrySelected,
// }) {
//   return ClipPath(
//     clipper: clipper,
//     child: GestureDetector(
//       onTap: () => onCountrySelected?.call(country),
//       child: Container(
//         color: color,
//       ),
//     ),
//   );
// }

// Widget to render a single clipped country with interactivity
class CountryWidget extends StatelessWidget {
  final Country country;
  final Function(Country country) onCountrySelected;
  final Color color;

  const CountryWidget({
    super.key,
    required this.country,
    required this.onCountrySelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: Clipper(svgPath: country.path),
      child: GestureDetector(
        onTap: () => onCountrySelected(country),
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
