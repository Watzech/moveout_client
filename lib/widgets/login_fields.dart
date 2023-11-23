// ignore_for_file: prefer_const_constructors, unnecessary_this, no_logic_in_create_state, prefer_typing_uninitialized_variables, must_be_immutable, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum ImageSourceType { gallery, camera }

const cLabelStyle = TextStyle(color: Colors.white, fontSize: 15);
const cBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0));
const helperEmpty = ' ';

class NavigatorTextButton extends StatelessWidget {
  const NavigatorTextButton(
      {super.key,
      required this.txt,
      this.color = Colors.white,
      this.fontSize = 12,
      required this.destinationWidget});

  final String txt;
  final Color color;
  final double fontSize;
  final Widget destinationWidget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationWidget),
          );
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            txt,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              decoration: TextDecoration.underline,
              decorationColor: color,
              decorationThickness: 2,
            ),
          ),
        ));
  }
}

class LoginTextFormField extends StatefulWidget {
  final String lbl;
  final TextEditingController controller;
  final String? Function(String?) validatorFunction;
  const LoginTextFormField(
      {super.key,
      required this.lbl,
      required this.controller,
      required this.validatorFunction});

  @override
  State<LoginTextFormField> createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validatorFunction,
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: cBorder,
        focusedBorder: cBorder,
        labelText: widget.lbl,
        labelStyle: cLabelStyle,
        helperText:
            helperEmpty, // Helper text como uma string contendo um espaço.
      ),
    );
  }
}

class LoginPasswordFormField extends StatefulWidget {
  final String lbl;
  final TextEditingController controller;
  bool obscure = true;
  final String? Function(String?) validatorFunction;
  LoginPasswordFormField(
      {super.key,
      required this.lbl,
      required this.controller,
      required this.validatorFunction});

  @override
  State<LoginPasswordFormField> createState() => _LoginPasswordFormFieldState();
}

class _LoginPasswordFormFieldState extends State<LoginPasswordFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: cBorder,
        focusedBorder: cBorder,
        labelText: widget.lbl,
        labelStyle: cLabelStyle,
        helperText:
            helperEmpty, // Helper text como uma string contendo um espaço.
        suffixIcon: IconButton(
          icon: Icon(
            widget.obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              widget.obscure = !widget.obscure;
            });
          },
        ),
      ),
      validator: widget.validatorFunction,
    );
  }
}

class MaskedLoginTextFormField extends StatefulWidget {
  final String lbl;
  final TextEditingController controller;
  final bool obscure;
  final MaskTextInputFormatter maskFormatter;
  final String? Function(String?) validatorFunction;
  const MaskedLoginTextFormField(
      {super.key,
      required this.lbl,
      required this.controller,
      this.obscure = false,
      required this.maskFormatter,
      required this.validatorFunction});

  @override
  State<MaskedLoginTextFormField> createState() =>
      _MaskedLoginTextFormFieldState();
}

class _MaskedLoginTextFormFieldState extends State<MaskedLoginTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: cBorder,
        focusedBorder: cBorder,
        labelText: widget.lbl,
        labelStyle: cLabelStyle,
        helperText:
            helperEmpty, // Helper text como uma string contendo um espaço.
      ),
      validator: widget.validatorFunction,
      inputFormatters: [widget.maskFormatter],
    );
  }
}

class LoginPhotoField extends StatefulWidget {
  const LoginPhotoField(
    this.type, {
    super.key,
    required this.callback,
  });

  final type;
  final ValueChanged<XFile> callback;

  @override
  _LoginPhotoFieldState createState() => _LoginPhotoFieldState(this.type);
}

class _LoginPhotoFieldState extends State<LoginPhotoField> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  var _image;
  var imagePicker;
  var type;

  _LoginPhotoFieldState(this.type);

  void _sendDataToParent(XFile value) {
    widget.callback(value);
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              XFile? image;
              image = await imagePicker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 50,
              );
              setState(() {
                if (image != null) {
                  _image = File(image.path);
                  _sendDataToParent(image);
                }
              });
            },
            child: _image != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      border: Border.all(
                        width: 3,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(200),
                      image: DecorationImage(
                          image: FileImage(_image), fit: BoxFit.cover),
                    ),
                    // width: MediaQuery.sizeOf(context).width * 0.50,
                    // height: MediaQuery.sizeOf(context).height * 0.23,
                    width: 225,
                    height: 225,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(
                        width: 3,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(200),
                    ),
                    // width: MediaQuery.sizeOf(context).width * 0.50,
                    // height: MediaQuery.sizeOf(context).height * 0.23,
                    width: 225,
                    height: 225,
                    child: Icon(
                      Icons.camera_alt,
                      size: MediaQuery.sizeOf(context).width * 0.075,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}

class AddressPickerFormField extends StatefulWidget {
  final String lbl;
  final TextEditingController controller;
  final String? Function(String?) validatorFunction;
  const AddressPickerFormField(
      {super.key,
      required this.lbl,
      required this.controller,
      required this.validatorFunction});

  @override
  State<AddressPickerFormField> createState() => _AddressPickerFormFieldState();
}

class _AddressPickerFormFieldState extends State<AddressPickerFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: cBorder,
        focusedBorder: cBorder,
        labelText: widget.lbl,
        labelStyle: cLabelStyle,
        helperText:
            helperEmpty, // Helper text como uma string contendo um espaço.
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     Icons.room,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     //aqui, abrir o mapa para selecionar o endereço
        //     setState(() {});
        //   },
        // ),
      ),
      validator: widget.validatorFunction,
    );
  }
}
