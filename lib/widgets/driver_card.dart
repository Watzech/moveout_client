import 'package:flutter/material.dart';
import 'package:moveout1/classes/driver.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;

  const DriverCard(
      {super.key,
      required this.driver
      });

  @override
  Widget build(BuildContext context) {
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
                  child: ColoredBox(color: Theme.of(context).colorScheme.secondary),
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
                  Icons.person_outline,
                  // color: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.secondary,
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
                      Text(
                        //'Pedido $request. ',
                        '',
                        style: TextStyle(
                          fontFamily: 'BebasKai',
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Icon(
                        Icons.circle,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 5,
                      ),
                      Text(
                        'Test',
                        style: TextStyle(
                          fontFamily: 'BebasKai',
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
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
                            //driver.origin["address"],
                            'Teste',
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
                            // driver.destination["address"],
                            'Teste',
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
                        // reaisFormatter.format(driver.price["finalPrice"]),
                        'Teste',
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
