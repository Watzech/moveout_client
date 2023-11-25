// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moveout1/classes/driver.dart';
import 'package:moveout1/classes/request.dart';
import 'package:moveout1/classes/transport.dart';
import 'package:moveout1/constants/main.dart' as constants;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:moveout1/screens/interested_drivers.dart';
import 'package:moveout1/services/delete_request.dart';
import 'package:moveout1/services/transports.dart';
import 'package:moveout1/widgets/default_button.dart';
import 'package:moveout1/widgets/profile_image_container.dart';
import 'package:moveout1/widgets/sliding_panel_widgets/custom_summary_subtext_row.dart';
import 'package:moveout1/widgets/sliding_panel_widgets/custom_summary_text_row.dart';

class RequestDetailScreen extends StatefulWidget {
  final Request request;
  const RequestDetailScreen({super.key, required this.request});

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final reaisFormatter = NumberFormat("'R\$:' #,##0.00");
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = constants.API_KEY;
  bool _isLoading = false;
  Transport? transport;
  Driver? driver;
  int rating = 5;

  @override
  void initState() {
    super.initState();

    _addMarker(
        LatLng(widget.request.origin["lat"], widget.request.origin["long"]),
        "origin",
        BitmapDescriptor.defaultMarker);

    _addMarker(
        LatLng(widget.request.destination["lat"],
            widget.request.destination["long"]),
        "destination",
        BitmapDescriptor.defaultMarker);

    _getPolyline();

    if (widget.request.status == 'AG') {
      getInfoFromTransport(widget.request);
    }
  }

  Future<void> getInfoFromTransport(Request request) async {
    setState(() {
      _isLoading = true;
    });
    var transportMap = await getTransport(request.id);
    transport = Transport.fromMap(transportMap!);
    driver = await getDriver(transport!.driver);
    setState(() {
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    _controller.complete(controller);

    List<LatLng> list = [
      LatLng(widget.request.origin["lat"], widget.request.origin["long"]),
      LatLng(
          widget.request.destination["lat"], widget.request.destination["long"])
    ];
    LatLngBounds bounds = _boundsFromLatLngList(list);

    Future.delayed(const Duration(milliseconds: 500), () {
      CameraUpdate zoomToFit = CameraUpdate.newLatLngBounds(bounds, 70);
      mapController.animateCamera(zoomToFit);
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    List<PolylineWayPoint> polylineWayPoints = [];

    polylineWayPoints.add(PolylineWayPoint(
        location:
            "${widget.request.origin["lat"].toString()}, ${widget.request.origin["long"]}",
        stopOver: false));
    polylineWayPoints.add(PolylineWayPoint(
        location:
            "${widget.request.destination["lat"].toString()}, ${widget.request.destination["long"]}",
        stopOver: false));

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(
            widget.request.origin["lat"], widget.request.origin["long"]),
        PointLatLng(widget.request.destination["lat"],
            widget.request.destination["long"]),
        travelMode: TravelMode.driving,
        wayPoints: polylineWayPoints);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }

    LatLng northeast = LatLng(x1!, y1!);
    LatLng southwest = LatLng(x0!, y0!);

    if (southwest.latitude > northeast.latitude) {
      LatLng aux;
      aux = southwest;
      southwest = northeast;
      northeast = aux;
    }

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  CameraPosition _calculateCameraPosition() {
    List<LatLng> list = [
      LatLng(widget.request.origin["lat"], widget.request.origin["long"]),
      LatLng(
          widget.request.destination["lat"], widget.request.destination["long"])
    ];
    LatLngBounds bounds = _boundsFromLatLngList(list);

    LatLng center = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

    CameraPosition initialCameraPosition = CameraPosition(
      target: center,
      zoom: 8,
    );

    return initialCameraPosition;
  }

  String _getTransportSizeString(String transportSize) {
    switch (transportSize) {
      case 'Small':
        return 'Pequeno';
      case 'Medium':
        return 'Médio';
      case 'Large':
        return 'Grande';
      default:
        return 'Tamanho Inválido';
    }
  }

  Future<dynamic> cancelationSuccessfulFLushBar() {
    return Flushbar(
      messageText: const Padding(
        padding: EdgeInsets.fromLTRB(45, 15, 15, 15),
        child: Text(
          'Pedido cancelado com sucesso!',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.green,
      padding: const EdgeInsets.all(15),
      icon: const Padding(
        padding: EdgeInsets.fromLTRB(25, 15, 15, 15),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  Future<dynamic> completionSuccessfulFLushBar() {
    return Flushbar(
      messageText: const Padding(
        padding: EdgeInsets.fromLTRB(45, 15, 15, 15),
        child: Text(
          'Pedido concluído com sucesso!',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.green,
      padding: const EdgeInsets.all(15),
      icon: const Padding(
        padding: EdgeInsets.fromLTRB(25, 15, 15, 15),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  void showDriverDialog(BuildContext context, Driver driver,
      List<Transport>? transportsList, double rating, Request request) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                                fontFamily: 'BebasKai'),
                          ),
                        )
                      ],
                    )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
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
                    CustomSummarySubtextRow(
                        title: 'Telefone:', text: driver.phone),
                    CustomSummarySubtextRow(
                        title: 'Transportes realizados:',
                        text: transport.toString()),
                    CustomSummarySubtextRow(
                        title: 'Membro desde:',
                        text:
                            '${driver.createdAt.month}/${driver.createdAt.year}'),
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

  void _showFinishRequestDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      children: [
                        ImageContainer(
                          photoString: driver!.photo,
                          imageSize: MediaQuery.sizeOf(context).height * 0.18,
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.015,
                        ),
                        Text(
                          'Avalie sua experiência com ',
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).width * 0.04,
                              fontWeight: FontWeight.bold,
                              // fontFamily: 'BebasKai',
                              color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${driver!.name}!',
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).width * 0.04,
                              fontWeight: FontWeight.bold,
                              // fontFamily: 'BebasKai',
                              color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.015,
                  ),
                  Center(
                    child: RatingBar.builder(
                      // initialRating: rating,
                      initialRating: 5,
                      allowHalfRating: false,
                      minRating: 1,
                      direction: Axis.horizontal,
                      ignoreGestures: false,
                      itemSize: MediaQuery.sizeOf(context).width * 0.075,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        size: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onRatingUpdate: (value) {
                        setState(() {
                          rating = value.toInt();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = true;
                    });
                    await endTransport(widget.request, rating);
                    setState(() {
                      _isLoading = false;
                    });
                    completionSuccessfulFLushBar();
                    setState(() {
                      widget.request.status = "CO";
                    });
                  },
                  child: const Text('Avaliar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Voltar'))
            ],
          );
        });
  }

  void _showCancelRequestDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Deseja cancelar esse pedido?',
                style: TextStyle(fontSize: 17),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    widget.request.status = "CA";
                    setState(() {
                      _isLoading = true;
                    });
                    await cancelRequest(widget.request);
                    setState(() {
                      _isLoading = false;
                    });
                    cancelationSuccessfulFLushBar();
                  },
                  child: const Text('Sim')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (widget.request.status) {
      case 'CO': //Concluído
        statusColor = Colors.green;
        statusText = 'Concluído';
        break;
      case 'CA': //Cancelado
        statusColor = Colors.grey;
        statusText = 'Cancelado';
        break;
      case 'EA': //Em Aberto
        statusColor = Theme.of(context).colorScheme.secondary;
        statusText = 'Em Aberto';
        break;
      case 'AG': //Agendado
        statusColor = Colors.blue;
        statusText = 'Agendado';
        break;
      default:
        statusColor = Colors.red;
        statusText = 'ERRO';
        break;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.secondary,
                size: 30,
              )),
          actions: [
            widget.request.status == 'AG' || widget.request.status == 'EA'
                ? Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.sizeOf(context).width * 0.03),
                    child: InkWell(
                        onTap: () {
                          widget.request.status == 'AG'
                              ? Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return InterestedDriversScreen(
                                          interesteds:
                                              widget.request.interesteds,
                                          request: widget.request);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;
                                      var tween =
                                          Tween(begin: begin, end: end).chain(
                                        CurveTween(curve: curve),
                                      );
                                      var offsetAnimation =
                                          animation.drive(tween);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ))
                              : widget.request.status == 'EA'
                                  ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return InterestedDriversScreen(
                                              interesteds:
                                                  widget.request.interesteds,
                                              request: widget.request);
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(
                                            CurveTween(curve: curve),
                                          );
                                          var offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ))
                                  : null;
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_sharp,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 30,
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        )),
                  )
                : const SizedBox()
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 2.0,
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                child: GoogleMap(
                  initialCameraPosition: _calculateCameraPosition(),
                  myLocationEnabled: false,
                  tiltGesturesEnabled: false,
                  compassEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(markers.values),
                  polylines: Set<Polyline>.of(polylines.values),
                ),
              ),
              Divider(
                thickness: 2,
                height: 0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Column(
                  children: [
                    Text(
                      'PEDIDO $statusText',
                      style: TextStyle(
                          fontFamily: 'BebasKai',
                          fontSize: 35,
                          color: statusColor),
                    ),
                    const CustomSummaryTextRow(title: 'Endereços: ', text: ''),
                    CustomSummarySubtextRow(
                        title: 'Origem: ',
                        text: widget.request.origin['address']),
                    CustomSummarySubtextRow(
                        title: 'Destino: ',
                        text: widget.request.destination['address']),
                    CustomSummarySubtextRow(
                      title: 'Distância: ',
                      text: widget.request.distance.toStringAsFixed(2) + ' Km',
                    ),
                    CustomSummaryTextRow(
                      title: 'Tamanho do transporte: ',
                      text: _getTransportSizeString(
                          widget.request.price['truckSize']),
                      textSize: 16,
                    ),
                    CustomSummaryTextRow(
                      title: 'Ajudantes: ',
                      text: widget.request.helpers ? 'Sim' : 'Não',
                      textSize: 16,
                    ),
                    CustomSummaryTextRow(
                      title: 'Embalagem: ',
                      text:
                          widget.request.price['wrapping'] > 0 ? 'Sim' : 'Não',
                      textSize: 16,
                    ),
                    const CustomSummaryTextRow(title: 'Carga: ', text: ''),
                    widget.request.load['furniture'].isNotEmpty
                        ? CustomSummarySubtextRow(
                            title: 'Móveis / Eletrodomésticos: ',
                            text: widget.request.load['furniture'])
                        : const SizedBox(height: 0),
                    widget.request.load['box'].isNotEmpty
                        ? CustomSummarySubtextRow(
                            title: 'Caixas / Itens: ',
                            text: widget.request.load['box'])
                        : const SizedBox(height: 0),
                    widget.request.load['fragile'].isNotEmpty
                        ? CustomSummarySubtextRow(
                            title: 'Vidro / Frágeis: ',
                            text: widget.request.load['fragile'])
                        : const SizedBox(height: 0),
                    widget.request.load['other'].isNotEmpty
                        ? CustomSummarySubtextRow(
                            title: 'Outros: ',
                            text: widget.request.load['other'])
                        : const SizedBox(height: 0),
                    CustomSummaryTextRow(
                      title: 'Datas: ',
                      text:
                          '${widget.request.date[0]}   -   ${widget.request.date[1]}',
                      textSize: 16,
                    ),
                    Divider(
                      height: 0.25,
                      color: Colors.grey[200],
                    ),
                    CustomSummaryTextRow(
                      title: 'Valor: ',
                      text: reaisFormatter
                          .format(widget.request.price['finalPrice']),
                      textSize: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: widget.request.status == 'EA'
                            ? _isLoading
                                ? DefaultButton(
                                    text: 'CANCELAR PEDIDO',
                                    onPressedFunction: () {},
                                    isLoading: true)
                                : ElevatedButton(
                                    onPressed: _showCancelRequestDialog,
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                        fixedSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.075))),
                                    child: const Text(
                                      'CANCELAR PEDIDO',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontFamily: 'BebasKai'),
                                    ),
                                  )
                            : widget.request.status == 'AG'
                                ? _isLoading
                                    ? DefaultButton(
                                        text: 'CONCLUIR PEDIDO',
                                        onPressedFunction: () {},
                                        isLoading: true)
                                    : ElevatedButton(
                                        onPressed: _showFinishRequestDialog,
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.075))),
                                        child: const Text(
                                          'CONCLUIR PEDIDO',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'BebasKai'),
                                        ),
                                      )
                                : const SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
