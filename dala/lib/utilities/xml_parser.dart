import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class GeneralBodyPart {
  String name;

  String path;

  GeneralBodyPart({
    required this.name,
    required this.path,
  });
}

Future<void> loadSvgImage({required String svgImage}) async {
    String generalString = await rootBundle.loadString(svgImage);

    XmlDocument document = XmlDocument.parse(generalString);

    final paths = document.findAllElements('path');

    for (var element in paths) {

      String partName = element.getAttribute('id').toString();
      String partPath = element.getAttribute('d').toString();

      if (!partName.contains('path')) {
        GeneralBodyPart part = GeneralBodyPart(name: partName, path: partPath);

        // generalBackBodyParts.add(part);
        // generalFrontBodyParts.add(part);
      }

    }
  }
