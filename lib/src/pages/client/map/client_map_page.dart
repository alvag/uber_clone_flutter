import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/pages/client/map/client_map_controller.dart';
import 'package:uber_clone/src/widgets/custom_button.dart';

class ClientMapPage extends StatefulWidget {
  const ClientMapPage({Key? key}) : super(key: key);

  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {
  ClientMapController _clientMapController = new ClientMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _clientMapController.init(context, this._refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _clientMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _clientMapController.key,
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
                _buttonRequest(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _clientMapController.centerPosition,
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
        onPressed: _clientMapController.openDrawer,
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
                    _clientMapController.client?.username ?? '',
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
                    _clientMapController.client?.email ?? '',
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
            onTap: _clientMapController.signOut,
          ),
        ],
      ),
    );
  }

  Widget _buttonRequest() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      alignment: Alignment.bottomCenter,
      child: CustomButton(
        text: 'SOLICITAR',
        textColor: Colors.black,
        btnColor: Colors.amber,
        onPressed: () {},
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: _clientMapController.initialPosition,
      mapType: MapType.normal,
      onMapCreated: _clientMapController.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_clientMapController.markers.values),
    );
  }

  void _refresh() {
    setState(() {});
  }
}
