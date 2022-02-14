import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/home/widgets/alert.dart';
import 'package:ride/app/home/widgets/main_menu.dart';
import 'package:ride/app/home/widgets/menu_button.dart';
import 'package:ride/app/home/widgets/search_sheet.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/permission_helper.dart';

class HomeView extends StatefulHookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  late Position currentPosition;

  void setupPositionLocator() async {
    if (!await PermissionHelper.requestLocationWhenInUsePermission()) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng mapPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: mapPosition, zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    final drawerCanOpen = useState<bool>(true);
    final mapBottomPadding = useState<double>(0.0);
    final polylines = useState<Set<Polyline>>({});
    final markers = useState<Set<Marker>>({});
    final circles = useState<Set<Circle>>({});
    final searchSheetHeight = useState<double>(Platform.isIOS ? 200 : 175);

    void resetApp() {
      drawerCanOpen.value = true;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: MainMenu(
        onReset: () => Alert(
            title: 'Warning',
            text:
                'Without your seed phrase or private key you cannot restore your wallet balance',
            actions: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('reset'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(authProvider.notifier).deleteAccount();
                  context.go('/');
                },
              ),
            ]).show(context),
        onRevealKey: () => Alert(
          title: 'Private key',
          text:
              'WARNING, In production environment, the private key should be protected with password.\r\n\r\n'
              '${ref.read(authProvider.notifier).getPrivateKey() ?? "-"}',
          actions: [
            TextButton(
              child: const Text('close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('copy and close'),
              onPressed: () {
                final privateKey =
                    ref.read(authProvider.notifier).getPrivateKey();
                Clipboard.setData(ClipboardData(text: privateKey));
                Navigator.of(context).pop();
              },
            )
          ],
        ).show(context),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding.value),
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: polylines.value,
            markers: markers.value,
            circles: circles.value,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapBottomPadding.value = (Platform.isAndroid) ? 180 : 170;
              setupPositionLocator();
            },
          ),
          MenuButton(
            iconData: (drawerCanOpen.value) ? Icons.menu : Icons.arrow_back,
            onTap: () {
              if (drawerCanOpen.value) {
                _scaffoldKey.currentState!.openDrawer();
              } else {
                resetApp();
              }
            },
          ),
          SearchSheet(
            searchSheetHeight: searchSheetHeight.value,
            // onSearchBarTap: () async {
            //   context.go('/home/search');
            // },
          ),
        ],
      ),
    );
  }
}
