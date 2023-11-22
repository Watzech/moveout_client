import 'package:flutter/material.dart';
import 'package:moveout1/classes/driver.dart';
import 'package:moveout1/widgets/profile_image_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
          // Column(
          //   children: [
          //     Expanded(
          //       child: SizedBox(
          //         width: 8,
          //         child: ColoredBox(color: Theme.of(context).colorScheme.secondary),
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15,15,10,15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.person_outline,
                //   color: Theme.of(context).colorScheme.secondary,
                //   size: 50,
                // ),
                ImageContainer(photoString: driver.photo, imageSize: 80),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ' ${driver.name}',
                        style: TextStyle(
                          fontFamily: 'BebasKai',
                          fontSize: 21,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Text(
                        'Transportes feitos: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          //driver.origin["address"],
                          10.toString(),
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
                  Row(
                    children: [
                      Text(
                        'Telefone: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          //driver.origin["address"],
                          driver.phone,
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
                  Row(
                    children: [
                      RatingBar.builder(
                        // initialRating: rating,
                        initialRating: 2.5,
                        allowHalfRating: true,
                        minRating: 0,
                        direction: Axis.horizontal,
                        ignoreGestures: true,
                        itemSize: 18,
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
                    ],
                  ),
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
