import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPicker extends StatefulWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String> onSavedCountry;

  const CountryPicker({
    Key key,
    this.title,
    this.initialValue,
    this.onSavedCountry,
  }) : super(key: key);
  @override
  _CountryPhoneNumberPickerState createState() =>
      _CountryPhoneNumberPickerState();
}

class _CountryPhoneNumberPickerState extends State<CountryPicker> {
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
          CountryPickerDropdown(
            underline: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            itemHeight: 70,
            isDense: false,
            isExpanded: true,
            itemBuilder: (Country country) =>
                _buildDropdownItemWithLongText(country, dropdownItemWidth),
            initialValue: widget.initialValue,
            onValuePicked: (Country country) => widget.onSavedCountry,
          ),
        ],
      ),
    );
  }
}
