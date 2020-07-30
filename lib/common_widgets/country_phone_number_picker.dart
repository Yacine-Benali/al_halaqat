import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPhoneNumberPicker extends StatefulWidget {
  final String title;
  final ValueChanged<String> onSavedCountry;
  final ValueChanged<String> onSavedPhoneNumber;

  const CountryPhoneNumberPicker({
    Key key,
    this.title,
    this.onSavedCountry,
    this.onSavedPhoneNumber,
  }) : super(key: key);
  @override
  _CountryPhoneNumberPickerState createState() =>
      _CountryPhoneNumberPickerState();
}

class _CountryPhoneNumberPickerState extends State<CountryPhoneNumberPicker> {
  Country chosenCountry = Country.fromMap({
    'name': 'Lebanon',
    'isoCode': 'LB',
    'iso3Code': 'LBN',
    'phoneCode': '961',
  });
  Widget _buildDropdownItemWithLongText(
          Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: Text("${country.iso3Code}")),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.5;
    double dropdownItemWidth = dropdownButtonWidth - 32;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    suffix: Text(
                      chosenCountry.phoneCode,
                    ),
                    hintText: "Phone",
                    isDense: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => widget.onSavedPhoneNumber(value),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              CountryPickerDropdown(
                itemHeight: 63,
                isDense: false,
                itemBuilder: (Country country) =>
                    _buildDropdownItemWithLongText(country, dropdownItemWidth),
                initialValue: 'LB',
                onValuePicked: (Country country) => widget.onSavedCountry,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
