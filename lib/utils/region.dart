import 'package:country_dial_code/country_dial_code.dart';
import 'package:flutter/material.dart';

class Region {
  String? getCountryCode(BuildContext context) {
    final Locale appLocale = View.of(context).platformDispatcher.locale;
    return appLocale.countryCode;
  }

  String getDialCode(BuildContext context) {
    return CountryDialCode.fromCountryCode(getCountryCode(context)!).dialCode;
  }
}