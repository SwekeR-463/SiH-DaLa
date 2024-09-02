import 'package:dala/constants/colors.dart';
import 'package:dala/constants/dimensions.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

enum TruckLabel {
  blue('BEML BH100', Colors.blue, Icon(Icons.fire_truck)),
  pink('BEML BH150E', Colors.pink, Icon(Icons.fire_truck_outlined)),
  green('BelAZ 75306', Colors.green, Icon(Icons.car_crash_rounded)),
  yellow('BelAZ 75710', Colors.orange, Icon(Icons.pedal_bike_outlined)),
  grey('CAT 789D', Colors.grey, Icon(Icons.bike_scooter));

  const TruckLabel(this.label, this.color, this.leadingIcon);
  final String label;
  final Color color;
  final Icon leadingIcon;
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController truckController = TextEditingController();
  TruckLabel? selectedTruck;
  TruckLabel? dropdownValue = TruckLabel.blue;
  double? tkphValue = 2038;
  String? payloadValue = "Hello";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          iconTheme: const IconThemeData(
            color: AppColor.whiteColor,
            size: 32,
          ),
          leadingWidth: 84,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: AppColor.notificationColor,
              onPressed: () {},
              iconSize: 36,
            ),
            const SizedBox(
              width: 16,
            ),
          ],
          actionsIconTheme: const IconThemeData(),
          backgroundColor: AppColor.appbarBackgroundColor,
          title: const Text("OD392831H"),
          titleSpacing: 0,
          titleTextStyle: const TextStyle(
            color: AppColor.whiteColor,
            fontSize: 24,
          ),
        ),
        drawer: NavigationDrawer(
          backgroundColor: AppColor.dashboardBackgroundColor,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 48,
                      child: Image.asset("assets/farmer.png"),
                    ),
                  ),
                ],
              ),
            ),
            sideMenuListTile(Icons.add, 'Add New Vehicle'),
            sideMenuListTile(Icons.fire_truck, 'Manage Vehicles'),
            sideMenuListTile(Icons.live_help, 'Application Help'),
            sideMenuListTile(Icons.help, 'FAQ'),
            sideMenuListTile(Icons.settings, 'Settings'),
            sideMenuListTile(Icons.pest_control_rounded, 'Need Help?'),
            sideMenuListTile(Icons.book, 'User Guide'),
            sideMenuListTile(Icons.card_travel_rounded, 'Our Products'),
            sideMenuListTile(Icons.login, 'Log Out'),
            sideMenuListTile(Icons.report, 'Report Issue'),
          ],
        ),
        backgroundColor: AppColor.dashboardBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 24,
            ),
            DropdownMenu<TruckLabel>(
              initialSelection: TruckLabel.green,
              controller: truckController,
              leadingIcon: (selectedTruck != null)
                  ? selectedTruck!.leadingIcon
                  : const Icon(Icons.fire_truck),
              inputDecorationTheme: const InputDecorationTheme(filled: true),
              width: Dimensions.dashboardDropdownWidth,
              label: const Text('Dumper Trucks'),
              onSelected: (TruckLabel? color) {
                setState(
                  () {
                    selectedTruck = color;
                  },
                );
              },
              dropdownMenuEntries:
                  TruckLabel.values.map<DropdownMenuEntry<TruckLabel>>(
                (TruckLabel truck) {
                  return DropdownMenuEntry<TruckLabel>(
                    value: truck,
                    label: truck.label,
                    style: MenuItemButton.styleFrom(
                      foregroundColor: truck.color,
                    ),
                    leadingIcon: truck.leadingIcon,
                  );
                },
              ).toList(),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  child: Text('TKPH Value: $tkphValue'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text('Payload Value: $payloadValue'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget sideMenuListTile(IconData icon, String title,
    {double iconSize = 32, Color iconColor = Colors.blue}) {
  return ListTile(
    leading: Icon(
      icon,
      size: iconSize,
      color: iconColor,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    onTap: () {},
  );
}
