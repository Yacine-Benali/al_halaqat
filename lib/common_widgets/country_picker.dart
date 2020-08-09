import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

class CountryPicker extends StatelessWidget {
  const CountryPicker({
    Key key,
    @required this.title,
    @required this.initialValue,
    @required this.onSavedCountry,
    @required this.isEnabled,
  }) : super(key: key);

  final String title;
  final String initialValue;
  final ValueChanged<String> onSavedCountry;
  final bool isEnabled;

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
              Expanded(child: Text("${country.isoCode}")),
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
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          IgnorePointer(
            ignoring: !isEnabled,
            child: CountryPickerDropdown(
              onTap: null,
              underline: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, //                   <--- border color
                    width: isEnabled ? 1 : 0.2,
                  ),
                ),
              ),
              icon: isEnabled ? Icon(Icons.arrow_drop_down) : Container(),
              itemHeight: 70,
              isDense: false,
              isExpanded: true,
              itemBuilder: (Country country) =>
                  _buildDropdownItemWithLongText(country, dropdownItemWidth),
              initialValue: initialValue,
              onValuePicked: (Country country) {
                onSavedCountry(country.isoCode);
              },
            ),
          ),
        ],
      ),
    );
  }
}
