import 'package:geocode/geocode.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GetUserLocation extends StatefulWidget {
  const GetUserLocation({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _GetUserLocationState createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {
  LocationData? currentLocation;
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (currentLocation != null)
              
                Text(
                    "Location: ${currentLocation?.latitude}, ${currentLocation?.longitude}"),
              // if (currentLocation != null) Text("Address: $address"),
              MaterialButton(
                onPressed: () {
                  debugPrint("点击了定位");
                  _getLocation().then((value) {
                    LocationData? location = value;
                    _getAddress(location?.latitude, location?.longitude)
                        .then((value) {
                      setState(() {
                        final sb = StringBuffer();
                        currentLocation = location;
                        address = value;
                        sb.write(currentLocation?.latitude.toString());
                        sb.write(currentLocation?.longitude.toString());
                        final userLocation = sb;
                        debugPrint("当前的经纬度是${userLocation.toString()}");
                      });
                    });
                  });
                },
                color: Colors.purple,
                child: const Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<LocationData?> _getLocation() async {
    Location location = Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "ssss";
    GeoCode geoCode = GeoCode();
    Address address =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }
}
