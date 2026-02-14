// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Googlemap extends StatefulWidget {
//   const Googlemap({super.key});

//   @override
//   State<Googlemap> createState() => _GooglemapState();
// }

// class _GooglemapState extends State<Googlemap> {
//   final Completer<GoogleMapController> _controller=Completer();

//   final CameraPosition _cameraPosition=const CameraPosition(target: LatLng(23.185205, 72.629588),
//     zoom: 5
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: _cameraPosition,
//         compassEnabled: true,
//         myLocationEnabled: true,
//         mapType: MapType.normal,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }