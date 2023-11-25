import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moveout1/classes/request.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';
  static const String? _kFontPkg = null;

  static const IconData truck =
      IconData(0xf0d1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData truckMoving =
      IconData(0xf4df, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData truckPickup =
      IconData(0xf63c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class RequestCard extends StatelessWidget {
  final Request request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    final reaisFormatter = NumberFormat("'R\$:' #,##0.00", Intl.defaultLocale);

    IconData icon;
    switch (request.price["truckSize"]) {
      case 'Small':
        icon = CustomIcons.truckPickup;
        break;
      case 'Medium':
        icon = CustomIcons.truck;
        break;
      case 'Large':
        icon = CustomIcons.truckMoving;
        break;
      default:
        icon = Icons.error;
        break;
    }
    Color statusColor;
    String statusText;
    switch (request.status) {
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
    return SizedBox(
      height: 115,
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: 8,
                  child: ColoredBox(color: statusColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  // color: Theme.of(context).colorScheme.secondary,
                  color: statusColor,
                  size: 50,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 2,
                    child: ColoredBox(color: Colors.grey.shade200),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: statusColor,
                        size: 5,
                      ),
                      Text(
                        ' $statusText',
                        style: TextStyle(
                          fontFamily: 'BebasKai',
                          fontSize: 20,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      request.interesteds.isNotEmpty
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 7,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  request.interesteds.length.toString(),
                                  style: const TextStyle(color: Colors.white, fontFamily: 'BebasKai', fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      children: [
                        Text(
                          'Origem: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            request.origin["address"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Row(
                      children: [
                        Text(
                          'Destino: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            request.destination["address"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        reaisFormatter.format(request.price["finalPrice"]),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  Icons.arrow_right,
                  // color: Theme.of(context).colorScheme.secondary,
                  color: Colors.grey.shade500,
                  size: 35,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
