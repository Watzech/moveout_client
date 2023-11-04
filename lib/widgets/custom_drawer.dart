import 'package:flutter/material.dart';
import 'package:moveout1/screens/login.dart';
import 'package:moveout1/screens/mapscreen.dart';
import 'package:moveout1/screens/requests.dart';
import 'package:moveout1/services/device_info.dart';
import 'profile_image_container.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 25,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.userData,
    required this.context,
  });

  final dynamic userData;
  final BuildContext context;

  void _showConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Deseja realmente sair? \n\nSerá necessário realizar o login novamente.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                      return const AuthScreen();
                    }), (r){
                      return false;
                    });
                    await removeUserInfo();
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
    return Drawer(
      shape: const BeveledRectangleBorder(),
      width: MediaQuery.of(context).size.width * 0.65,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              const SizedBox(height: 25),
              Row(
                children: [
                  ImageContainer(photoString: userData['photo']),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData != null
                                ? userData['name']
                                : 'Carregando...',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userData != null
                                ? userData['phone']
                                : 'Carregando...',
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                overflow: TextOverflow.clip),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              Divider(
                height: 5,
                thickness: 2,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 15),
              CustomListTile(
                icon: Icons.home,
                text: 'Início',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                },
              ),
              const SizedBox(height: 15),
              CustomListTile(
                icon: Icons.content_paste,
                text: 'Pedidos',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RequestsScreen()));
                },
              ),
              // const SizedBox(height: 15),
              // CustomListTile(
              //   icon: Icons.calendar_month,
              //   text: 'Agenda',
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => RequestsScreen()));
              //   },
              // ),
              // const SizedBox(height: 15),
              // CustomListTile(
              //   icon: Icons.settings,
              //   text: 'Configurações',
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => RequestsScreen()));
              //   },
              // )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: TextButton(
                  onPressed: _showConfirmationDialog,
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    side: const MaterialStatePropertyAll(BorderSide(color: Colors.red)),
                    fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.60, 50)),
                  ),
                  child: const Text(
                    'Sair',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'BebasKai'),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
