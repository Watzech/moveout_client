// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moveout1/classes/driver.dart';
import 'package:moveout1/classes/request.dart';
import 'package:moveout1/classes/transport.dart';
import 'package:moveout1/services/get_interest.dart';
import 'package:moveout1/services/transports.dart';
import 'package:moveout1/widgets/driver_card.dart';
import 'package:moveout1/widgets/profile_image_container.dart';
import 'package:moveout1/widgets/sliding_panel_widgets/custom_divider.dart';
import 'package:moveout1/widgets/sliding_panel_widgets/custom_summary_subtext_row.dart';

class InterestedDriversScreen extends StatefulWidget {
  const InterestedDriversScreen({
    super.key,
    required this.interesteds,
    required this.request
  });

  final List<dynamic> interesteds;
  final Request request;

  @override
  State<InterestedDriversScreen> createState() =>
      _InterestedDriversScreenState();
}

class _InterestedDriversScreenState extends State<InterestedDriversScreen> {
  List<Driver> _driverArray = [];
  List<List<Transport>?> _transportsArray = [];
  List<double> _ratingArray = [];
  bool _isLoading = true;
  late Request _request;

  void showDriverDialog(BuildContext context, Driver driver, List<Transport>? transportsList, double rating, Request request) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> filterOptions = <String>['Distância', 'Valor'];
          double fontSize = MediaQuery.of(context).size.height * 0.022;
          int transport = transportsList != null ? transportsList.length : 0;
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                        child: Column(
                      children: [
                        ImageContainer(
                          photoString: driver.photo,
                          imageSize: MediaQuery.sizeOf(context).height * 0.18,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            driver.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 25,
                              fontFamily: 'BebasKai'
                            ),
                          ),
                        )
                      ],
                    )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15,0,15,15),
                        child: RatingBar.builder(
                          // initialRating: rating,
                          initialRating: rating,
                          allowHalfRating: true,
                          minRating: 0,
                          direction: Axis.horizontal,
                          ignoreGestures: true,
                          itemSize: MediaQuery.sizeOf(context).width * 0.075,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 3.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: 1,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onRatingUpdate: (value) {},
                        ),
                      ),
                    ),
                    CustomSummarySubtextRow(title: 'Telefone:', text: driver.phone),
                    CustomSummarySubtextRow(title: 'Transportes realizados:', text: transport.toString()),
                    CustomSummarySubtextRow(title: 'Membro desde:', text: '${driver.createdAt.month}/${driver.createdAt.year}'),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Voltar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              request.status = "AG";
                              Navigator.pop(context);
                              await setDriver(request, driver);
                            },
                            child: const Text('Aceitar Motorista'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>>? map = await getInterests(widget.interesteds);
      Request request = widget.request;

      List<Driver> interestedDrivers = [];
      List<List<Transport>> interestedDriversTransports = [];
      List<double> interestedDriversRating = [];
      if (map != null) {
        for (var element in map) {
          dynamic transport = await getTransports(element["cnh"]);
          double rating = getCurrentRating(transport);
          interestedDrivers.add(Driver.fromMap(element));
          
          if(transport != null){
            List<Transport> list = [];
            for(var transportItem in transport){
              list.add(Transport.fromMap(transportItem));
            }
            interestedDriversTransports.add(list);
          }
          interestedDriversRating.add(rating);
        }
      }
      setState(() {
        _driverArray = interestedDrivers;
        _transportsArray = interestedDriversTransports;
        _ratingArray = interestedDriversRating;
        _isLoading = false;
        _request = request;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'Motoristas interessados',
            style: TextStyle(
                fontFamily: 'BebasKai', fontSize: 30, color: Colors.white),
          ),
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  // backgroundColor: Theme.of(context).colorScheme.primary,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : Column(
                children: [
                  _driverArray.isEmpty
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
                              final itemTransport = _transportsArray[index]!.isNotEmpty ? _transportsArray[index] : null;
                              final itemRating = _ratingArray[index];
                              return Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        showDriverDialog(context, item, itemTransport, itemRating, _request);
                                      },
                                      child: DriverCard(driver: item, rating: itemRating, transports: itemTransport)),
                                  const CustomDivider(),
                                ],
                              );
                            },
                          ),
                        ),
                ],
              ));
  }
}
