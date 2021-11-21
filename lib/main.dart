import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'maskedtext.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final cardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final securityCodeController = TextEditingController();
  final cardHolderController = TextEditingController();

  var expdate = DateTime.now();

  final _ccValidator = CreditCardValidator();
  bool validateCreditCardInfo() {
    var ccNumResults = _ccValidator.validateCCNum(cardNumberController.text);
    var expDateResults = _ccValidator.validateExpDate(dateController.text);
    var cvvResults = _ccValidator.validateCVV(
        securityCodeController.text, ccNumResults.ccType);
    if (ccNumResults.isPotentiallyValid) {
      setState(() {
        errorText = "Please enter a valid card number";
      });
    } else if (errorText != null) {
      setState(() {
        errorText = null;
      });
    }
    return ccNumResults.isPotentiallyValid &&
        expDateResults.isPotentiallyValid &&
        cvvResults.isPotentiallyValid;
  }

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Card Flutter',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(
            color: Color(0xFF223263),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Add Card',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF223263)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 6.0, left: 8.0, right: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (errorText != null)
                Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Color(0xFFE78787),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: 20,
                      ),
                    ),
                    Text(
                      errorText!,
                      style: TextStyle(color: Color(0xFFE78787)),
                    )
                  ],
                ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: const Text(
                    'Card Number',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF223263)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 6.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: TextField(
                  controller: cardNumberController,
                  inputFormatters: [
                    MaskedTextInputFormatter(
                      mask: 'xxxx-xxxx-xxxx-xxxx',
                      separator: '-',
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFA9A9A9)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD3D3D3))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE78787))),
                    border: OutlineInputBorder(),
                    hintText: 'XXXX - XXXX - XXXX - XXXX',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 6.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Expiration Date',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF223263)),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        'Security Code',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF223263)),
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 6.0,
                          right: 8.0,
                        ),
                        child: Builder(builder: (context) {
                          return TextField(
                            controller: dateController,
                            onTap: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  initialDate: expdate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  initialDatePickerMode: DatePickerMode.year);
                              if (date != null) {
                                expdate = date;
                                dateController.text =
                                    DateFormat('MM/yy').format(date);
                              }
                            },
                            readOnly: true,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA9A9A9)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFD3D3D3))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFE78787))),
                              border: OutlineInputBorder(),
                              hintText: 'MM/YY',
                            ),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, left: 8.0, right: 8.0),
                        child: TextField(
                          controller: securityCodeController,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintStyle: TextStyle(color: Color(0xFFA9A9A9)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFD3D3D3))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE78787))),
                            border: OutlineInputBorder(),
                            hintText: 'XXX',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: const Text(
                    'Card Holder',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF223263)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 6.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: TextField(
                  controller: cardHolderController,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFFA9A9A9)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD3D3D3))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE78787))),
                    border: OutlineInputBorder(),
                    hintText: 'Name as on card',
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 18.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (validateCreditCardInfo())
                        print(
                            "Card Holder Name: ${cardHolderController.text}\nCard Number: ${cardNumberController.text}\nExpiration Date: ${dateController.text}");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color(0xFFAE90D4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 14.0),
                      child: Text(
                        "Add Card",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
