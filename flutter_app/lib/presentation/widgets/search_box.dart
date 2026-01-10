import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 25),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Color(0xFF9CA3AF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}