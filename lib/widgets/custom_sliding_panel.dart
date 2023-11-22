// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moveout1/services/request.dart';
import 'package:moveout1/services/get_price.dart';
import 'package:moveout1/widgets/default_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'sliding_panel_widgets/custom_address_text_form.dart';
import 'sliding_panel_widgets/custom_checkbox_list_tile.dart';
import 'sliding_panel_widgets/custom_confirm_button_widget.dart';
import 'sliding_panel_widgets/custom_date_picker.dart';
import 'sliding_panel_widgets/custom_divider.dart';
import 'sliding_panel_widgets/custom_summary_subtext_row.dart';
import 'sliding_panel_widgets/custom_summary_text_row.dart';
import 'sliding_panel_widgets/custom_summary_title.dart';
import 'sliding_panel_widgets/custom_title.dart';
import 'sliding_panel_widgets/transport_size_segmented_button.dart';

class CustomSlidingPanel extends StatefulWidget {
  const CustomSlidingPanel(
      {super.key,
      required this.panelController,
      required this.originAddressController,
      required this.destinationAddressController,
      required this.firstDateController,
      required this.secondDateController,
      required this.furnitureCheckController,
      required this.boxCheckController,
      required this.fragileCheckController,
      required this.otherCheckController,
      required this.addressTextFormOnTapFunction,
      required this.originAddressFieldFocus,
      required this.destinationAddressFieldFocus,
      required this.originPlace,
      required this.destinationPlace,
      required this.userData,
      required this.showFlushBar});

  final PanelController panelController;
  final TextEditingController originAddressController;
  final TextEditingController destinationAddressController;
  final TextEditingController firstDateController;
  final TextEditingController secondDateController;
  final TextEditingController furnitureCheckController;
  final TextEditingController boxCheckController;
  final TextEditingController fragileCheckController;
  final TextEditingController otherCheckController;
  final void Function(TextEditingController?, String, String)
      addressTextFormOnTapFunction;
  final FocusNode originAddressFieldFocus;
  final FocusNode destinationAddressFieldFocus;
  final Map<String, dynamic> originPlace;
  final Map<String, dynamic> destinationPlace;
  final dynamic userData;
  final VoidCallback showFlushBar;

  @override
  State<CustomSlidingPanel> createState() => _CustomSlidingPanelState();
}

class _CustomSlidingPanelState extends State<CustomSlidingPanel> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final _formkey = GlobalKey<FormState>();
  final reaisFormatter = NumberFormat("'R\$:' #,##0.00");
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  Map<String, dynamic>? _quote;

  String transportSizeValue = ' ';
  void _handleTransportSizeValue(String data) {
    setState(() {
      transportSizeValue = data;
    });
  }

  bool helperCheckValue = false;
  void _handleHelperCheckValue(bool data) {
    setState(() {
      helperCheckValue = data;
    });
  }

  bool wrappingCheckValue = false;
  void _handlePackageCheckValue(bool data) {
    setState(() {
      wrappingCheckValue = data;
    });
  }

  bool furnitureCheckValue = false;
  void _handleFurnitureCheckValue(bool data) {
    setState(() {
      furnitureCheckValue = data;
    });
  }

  bool boxCheckValue = false;
  void _handleBoxCheckValue(bool data) {
    setState(() {
      boxCheckValue = data;
    });
  }

  bool fragileCheckValue = false;
  void _handleFragileCheckValue(bool data) {
    setState(() {
      fragileCheckValue = data;
    });
  }

  bool otherCheckValue = false;
  void _handleOtherCheckValue(bool data) {
    setState(() {
      otherCheckValue = data;
    });
  }

  DateTime _formatDate(String dateString) {
    List<String> dateParts =
        dateString.split('/').map((part) => part.trim()).toList();

    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    return DateTime(year, month, day);
  }

  void _buttonValidate() {
    bool verifyCheckboxText(
        bool checkvalue, TextEditingController textController) {
      if (checkvalue == true) {
        return textController.text.isNotEmpty ? true : false;
      } else {
        return true;
      }
    }

    bool verifyCheckboxesValidation() {
      bool furnitureCheckValid = verifyCheckboxText(
          furnitureCheckValue, widget.furnitureCheckController);
      bool boxCheckValid =
          verifyCheckboxText(boxCheckValue, widget.boxCheckController);
      bool fragileCheckValid =
          verifyCheckboxText(fragileCheckValue, widget.fragileCheckController);
      bool otherCheckValid =
          verifyCheckboxText(otherCheckValue, widget.otherCheckController);
      return (furnitureCheckValid &&
              boxCheckValid &&
              fragileCheckValid &&
              otherCheckValid)
          ? true
          : false;
    }

    bool isAtLeastOneChecked = (furnitureCheckValue ||
            boxCheckValue ||
            fragileCheckValue ||
            otherCheckValue)
        ? true
        : false;

    bool allCheckboxesValid =
        isAtLeastOneChecked ? verifyCheckboxesValidation() : false;

    setState(() {
      if ((widget.originAddressController.text.isNotEmpty) &&
          (widget.destinationAddressController.text.isNotEmpty) &&
          allCheckboxesValid &&
          (widget.firstDateController.text.isNotEmpty) &&
          (widget.secondDateController.text.isNotEmpty)) {
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _isButtonEnabled = false;
        });
      }
    });
  }

  Future<void> _getFormInfo() async {
    Map<String, dynamic> info = {};
    String firstDate = widget.firstDateController.text;
    String secondDate = widget.secondDateController.text;
    String furnitureCheck = widget.furnitureCheckController.text;
    String boxCheck = widget.boxCheckController.text;
    String fragileCheck = widget.fragileCheckController.text;
    String otherCheck = widget.otherCheckController.text;

    info["date"] = [firstDate, secondDate];
    info["size"] = transportSizeValue;
    info["plus"] = 2;
    info["helpers"] = helperCheckValue;
    info["wrapping"] = wrappingCheckValue;
    info["load"] = {};

    info["load"]["furniture"] = furnitureCheck;
    info["load"]["box"] = boxCheck;
    info["load"]["fragile"] = fragileCheck;
    info["load"]["other"] = otherCheck;

    var quoteInfo =
        await getQuote(widget.originPlace, widget.destinationPlace, info);

    quoteInfo["cpf"] = widget.userData['cpf'];
    setState(() {
      if(quoteInfo["error"] == null){
        _quote = quoteInfo;
      }
    });
  }

  void _showConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Deseja confirmar esse pedido?',
                style: TextStyle(fontSize: 17),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _submitData();
                    _navigatorKey.currentState?.pop();
                    widget.showFlushBar();
                    _cleanAndClose();
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

  Future<void> _submitData() async {
    setState(() {
      _isLoading = true;
    });
    await doRequest(_quote);
    setState(() {
      _isLoading = false;
    });
  }

  void _cleanAndClose() {
    setState(() {
      helperCheckValue = false;
      wrappingCheckValue = false;
      furnitureCheckValue = false;
      boxCheckValue = false;
      fragileCheckValue = false;
      otherCheckValue = false;
      widget.originAddressController.text = "";
      widget.destinationAddressController.text = "";
      widget.firstDateController.text = "";
      widget.secondDateController.text = "";
      widget.furnitureCheckController.text = "";
      widget.boxCheckController.text = "";
      widget.fragileCheckController.text = "";
      widget.otherCheckController.text = "";
    });
    _togglePanel();
  }

  void _togglePanel() {
    if (widget.panelController.isPanelOpen) {
      widget.panelController.close();
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      widget.panelController.open();
    }
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

  Widget _buildFormContent() {
    return WillPopScope(
      onWillPop: () async {
        _togglePanel(); // Fechar o SlidingUpPanel
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formkey,
            child: Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 15.0),
                    child: CustomTitle(label: 'Endereços:'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                    child: CustomAddressTextForm(
                      hintText: 'Endereço de origem...',
                      textFieldController: widget.originAddressController,
                      onTapFunction: () {
                        widget.addressTextFormOnTapFunction(
                            widget.originAddressController,
                            'Endereço de Origem',
                            'O');
                      },
                      addressFieldFocus: widget.originAddressFieldFocus,
                    ),
                  ),
                  Center(
                    child: SizedBox.fromSize(
                        size: const Size(2, 30),
                        child: ColoredBox(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
                    child: CustomAddressTextForm(
                      hintText: 'Endereço de destino...',
                      textFieldController: widget.destinationAddressController,
                      onTapFunction: () {
                        widget.addressTextFormOnTapFunction(
                            widget.destinationAddressController,
                            'Endereço de Destino',
                            'D');
                      },
                      addressFieldFocus: widget.destinationAddressFieldFocus,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 15.0, bottom: 0.0),
                    child: CustomCheckboxListTile(
                        checkboxValue: helperCheckValue,
                        label: 'Preciso de Ajudantes',
                        callback: _handleHelperCheckValue,
                        onChangedFunction: () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 0.0, bottom: 15.0),
                    child: CustomCheckboxListTile(
                        checkboxValue: wrappingCheckValue,
                        label: 'Preciso de Embalagem',
                        callback: _handlePackageCheckValue,
                        onChangedFunction: () {}),
                  ),
                  const CustomDivider(),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 15.0),
                    child: CustomTitle(label: 'Tamanho do Transporte:'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                    child: Center(
                        child: TransportSizeSegmentedButton(
                            callback: _handleTransportSizeValue)),
                  ),
                  const CustomDivider(),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 15.0),
                    child: CustomTitle(label: 'Lista de Carga:'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 0.0, bottom: 0.0),
                    child: CustomCheckboxTextListTile(
                        checkboxValue: furnitureCheckValue,
                        label: 'Móveis / Eletrodomésticos de grande porte',
                        callback: _handleFurnitureCheckValue,
                        textController: widget.furnitureCheckController,
                        onChangedFunction: () {
                          _buttonValidate();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 0.0, bottom: 0.0),
                    child: CustomCheckboxTextListTile(
                        checkboxValue: boxCheckValue,
                        label: 'Caixas / Itens diversos',
                        callback: _handleBoxCheckValue,
                        textController: widget.boxCheckController,
                        onChangedFunction: () {
                          _buttonValidate();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 0.0, bottom: 0.0),
                    child: CustomCheckboxTextListTile(
                        checkboxValue: fragileCheckValue,
                        label: 'Vidros / Objetos frágeis',
                        callback: _handleFragileCheckValue,
                        textController: widget.fragileCheckController,
                        onChangedFunction: () {
                          _buttonValidate();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 0.0, bottom: 0.0),
                    child: CustomCheckboxTextListTile(
                        checkboxValue: otherCheckValue,
                        label: 'Outros',
                        callback: _handleOtherCheckValue,
                        textController: widget.otherCheckController,
                        onChangedFunction: () {
                          _buttonValidate();
                        }),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                        child: Text(
                          'Selecione ao menos um tipo de carga',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 12,
                          ),
                        )),
                  ),
                  const SizedBox(height: 10),
                  const CustomDivider(),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 15.0),
                    child: CustomTitle(label: 'Agendamento:'),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                        child: CustomDatePicker(
                            dateController: widget.firstDateController,
                            unavailableDates:
                                widget.secondDateController.text.isEmpty
                                    ? <DateTime>{}
                                    : <DateTime>{
                                        _formatDate(
                                            widget.secondDateController.text)
                                      })),
                  ),
                  Center(
                    child: SizedBox.fromSize(
                        size: const Size(2, 25),
                        child: ColoredBox(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
                        child: CustomDatePicker(
                            dateController: widget.secondDateController,
                            unavailableDates: widget
                                    .firstDateController.text.isEmpty
                                ? <DateTime>{}
                                : <DateTime>{
                                    _formatDate(widget.firstDateController.text)
                                  })),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 25.0, bottom: 15.0),
                        child: Text(
                          'Selecione ao menos duas datas disponíveis',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 12,
                          ),
                        )),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          child: SlidingPanelConfirmButtonWidget(
                            isEnabled: _isButtonEnabled,
                            // isEnabled: true,
                            text: 'Fazer Pedido',
                            onPressedFunction: () {
                              _navigatorKey.currentState?.pushNamed('/summary');
                            },
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContent() {
    return _quote == null
        ? Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                      Stack(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 15.0),
                            child: IconButton(
                                onPressed: () {
                                  _navigatorKey.currentState?.pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_sharp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 35,
                                )),
                          ),
                        ),
                        CustomSummaryTitle(context: context, title: 'RESUMO')
                      ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Column(
                          children: [
                            // CustomSummaryTextRow(
                            //     title: 'Origem: ',
                            //     text: _quote!['origin']['address']),
                            // CustomSummaryTextRow(
                            //     title: 'Destino: ',
                            //     text: _quote!['destination']['address']),
                            const CustomSummaryTextRow(
                                title: 'Endereços: ', text: ''),
                            CustomSummarySubtextRow(
                                title: 'Origem: ',
                                text: _quote!['origin']['address']),
                            CustomSummarySubtextRow(
                                title: 'Destino: ',
                                text: _quote!['destination']['address']),
                            CustomSummarySubtextRow(
                              title: 'Distância: ',
                              text: _quote!['distance'].toStringAsFixed(2) +
                                  ' Km',
                            ),
                            CustomSummaryTextRow(
                              title: 'Tamanho do transporte: ',
                              text: _getTransportSizeString(
                                  _quote!['price']['truckSize']),
                              textSize: 16,
                            ),
                            CustomSummaryTextRow(
                              title: 'Ajudantes: ',
                              text: _quote!['helpers'] ? 'Sim' : 'Não',
                              textSize: 16,
                            ),
                            CustomSummaryTextRow(
                              title: 'Embalagem: ',
                              text: _quote!['price']['wrapping'] > 0
                                  ? 'Sim'
                                  : 'Não',
                              textSize: 16,
                            ),
                            const CustomSummaryTextRow(
                                title: 'Carga: ', text: ''),
                            _quote!['load']['furniture'].isNotEmpty
                                ? CustomSummarySubtextRow(
                                    title: 'Móveis / Eletrodomésticos: ',
                                    text: _quote!['load']['furniture'])
                                : const SizedBox(height: 0),
                            _quote!['load']['box'].isNotEmpty
                                ? CustomSummarySubtextRow(
                                    title: 'Caixas / Itens: ',
                                    text: _quote!['load']['box'])
                                : const SizedBox(height: 0),
                            _quote!['load']['fragile'].isNotEmpty
                                ? CustomSummarySubtextRow(
                                    title: 'Vidro / Frágeis: ',
                                    text: _quote!['load']['fragile'])
                                : const SizedBox(height: 0),
                            _quote!['load']['other'].isNotEmpty
                                ? CustomSummarySubtextRow(
                                    title: 'Outros: ',
                                    text: _quote!['load']['other'])
                                : const SizedBox(height: 0),
                            CustomSummaryTextRow(
                              title: 'Datas: ',
                              text:
                                  '${_quote!['date'][0]}   -   ${_quote!['date'][1]}',
                              textSize: 16,
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      const CustomDivider(),
                      CustomSummaryTitle(context: context, title: 'PREÇOS'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Column(
                          children: [
                            CustomSummaryTextRow(
                              title: 'Distância: ',
                              text: reaisFormatter.format(_quote!['price']
                                      ['valuePerDistance'] *
                                  _quote!['price']['distance']),
                              textSize: 16,
                            ),
                            CustomSummaryTextRow(
                              title: 'Tamanho do Transporte: ',
                              text: reaisFormatter
                                  .format(_quote!['price']['valueByTruck']),
                              textSize: 16,
                            ),
                            _quote!['price']['valueByHelper'] != 0
                                ? CustomSummaryTextRow(
                                    title: 'Ajudantes: ',
                                    text: reaisFormatter.format(
                                        _quote!['price']['valueByHelper']),
                                    textSize: 16)
                                : const SizedBox(height: 0),
                            _quote!['price']['wrapping'] != 0
                                ? CustomSummaryTextRow(
                                    title: 'Embalagem: ',
                                    text: reaisFormatter
                                        .format(_quote!['price']['wrapping']),
                                    textSize: 16)
                                : const SizedBox(height: 0),
                            CustomSummaryTextRow(
                              title: 'Carga: ',
                              text: reaisFormatter
                                  .format(_quote!['price']['valueByLoad']),
                              textSize: 16,
                            ),
                            const CustomDivider(),
                            CustomSummaryTextRow(
                              title: 'Valor Final: ',
                              text: reaisFormatter
                                  .format(_quote!['price']['finalPrice']),
                              textSize: 20,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: DefaultButton(
                            text: 'Confirmar Pedido',
                            onPressedFunction: _showConfirmationDialog,
                            isLoading: _isLoading,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    widget.originAddressController.addListener(() {
      if (widget.originAddressController.text.isNotEmpty) _buttonValidate();
    });
    widget.destinationAddressController.addListener(() {
      if (widget.destinationAddressController.text.isNotEmpty) {
        _buttonValidate();
      }
    });
    widget.firstDateController.addListener(() {
      if (widget.firstDateController.text.isNotEmpty) _buttonValidate();
    });
    widget.secondDateController.addListener(() {
      if (widget.secondDateController.text.isNotEmpty) _buttonValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      boxShadow: [
        BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 2.0,
            color: Theme.of(context).colorScheme.shadow)
      ],
      controller: widget.panelController,
      minHeight: MediaQuery.of(context).size.height * 0.058,
      maxHeight: MediaQuery.of(context).size.height * 0.70,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      panel: Column(
        children: [
          GestureDetector(
            onTap: _togglePanel,
            child: Container(
              // color: Colors.white,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.drag_handle,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: MediaQuery.of(context).size.height * 0.045,
                  ),
                ),
              ),
            ),
          ),
          const CustomDivider(),
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                if (settings.name == '/summary') {
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      _getFormInfo();
                      return _buildSummaryContent();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  );
                }
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return _buildFormContent();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.originAddressController.dispose();
    widget.destinationAddressController.dispose();
    widget.firstDateController.dispose();
    widget.secondDateController.dispose();
    widget.furnitureCheckController.dispose();
    widget.boxCheckController.dispose();
    widget.fragileCheckController.dispose();
    widget.otherCheckController.dispose();
    super.dispose();
  }
}
