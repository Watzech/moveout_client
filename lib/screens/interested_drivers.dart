// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:moveout1/classes/driver.dart';
import 'package:moveout1/services/get_interest.dart';
import 'package:moveout1/widgets/driver_card.dart';
import 'package:moveout1/widgets/sliding_panel_widgets/custom_divider.dart';

class InterestedDriversScreen extends StatefulWidget {
  const InterestedDriversScreen({
    super.key,
    required this.interesteds,
  });

  final List<dynamic> interesteds;

  @override
  State<InterestedDriversScreen> createState() =>
      _InterestedDriversScreenState();
}

class _InterestedDriversScreenState extends State<InterestedDriversScreen> {
  List<Driver> _driverArray = [];

  // Route _createRoute(Driver item) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) =>
  //         RequestDetailScreen(request: item),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(0.0, 1.0);
  //       const end = Offset.zero;
  //       const curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>>? map = await getInterests(widget.interesteds);

      List<Driver> interestedDrivers = [];
      if (map != null) {
        for (var element in map) {
          interestedDrivers.add(Driver.fromMap(element));
        }
      }
      setState(() {
        _driverArray = interestedDrivers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_sharp,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            height: 2.0,
          ),
        ),
      ),
      body: _driverArray.isEmpty
          ? const Center(
              child: Text(
                'Ainda nenhum motorista se interessou nesse pedido.',
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _driverArray.length,
                itemBuilder: (context, index) {
                  final item = _driverArray[index];
                  return Column(
                    children: [
                      InkWell(
                          onTap: () {
                            // Navigator.of(context).push(_createRoute(item));
                          },
                          child: DriverCard(driver: item)),
                      const CustomDivider(),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
