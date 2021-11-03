import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/pages/driver/map/driver_map_controller.dart';
import 'package:uber_clone/src/widgets/custom_button.dart';

class DriverMapPage extends StatefulWidget {
  const DriverMapPage({Key? key}) : super(key: key);

  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  DriverMapController _driverMapController = new DriverMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _driverMapController.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _driverMapController.key,
      body: Stack(
        children: [
          _googleMaps(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _menuDrawer(),
                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
                _buttonConnect(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Card(
        elevation: 4.0,
        shape: CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.location_searching,
            color: Colors.grey[600],
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return Container(
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buttonConnect() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      alignment: Alignment.bottomCenter,
      child: CustomButton(
        text: 'CONECTARSE',
        textColor: Colors.black,
        btnColor: Colors.amber,
        onPressed: () {},
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: _driverMapController.initialPosition,
      mapType: MapType.normal,
      onMapCreated: _driverMapController.onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
