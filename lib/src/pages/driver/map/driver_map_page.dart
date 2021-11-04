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
      _driverMapController.init(context, this._refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _driverMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _driverMapController.key,
      drawer: _drawer(),
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
    return GestureDetector(
      onTap: _driverMapController.centerPosition,
      child: Container(
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
      ),
    );
  }

  Widget _menuDrawer() {
    return Container(
      child: IconButton(
        onPressed: _driverMapController.openDrawer,
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _driverMapController.driver?.username ?? '',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: Text(
                    _driverMapController.driver?.email ?? '',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 10.0),
                CircleAvatar(backgroundImage: AssetImage('assets/img/profile.jpg'), radius: 40.0),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
            // leading: Icon(Icons.cancel),
            onTap: () {},
          ),
          ListTile(
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new),
            // leading: Icon(Icons.cancel),
            onTap: _driverMapController.signOut,
          ),
        ],
      ),
    );
  }

  Widget _buttonConnect() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      alignment: Alignment.bottomCenter,
      child: CustomButton(
        text: _driverMapController.isConnected ? 'DESCONECTARSE' : 'CONECTARSE',
        textColor: Colors.black,
        btnColor: _driverMapController.isConnected ? Colors.grey[300] : Colors.amber,
        onPressed: _driverMapController.connect,
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: _driverMapController.initialPosition,
      mapType: MapType.normal,
      onMapCreated: _driverMapController.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_driverMapController.markers.values),
    );
  }

  void _refresh() {
    setState(() {});
  }
}
