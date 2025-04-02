import 'package:flutter/material.dart';

class LanguagePopup extends StatelessWidget {
  final Function(Locale) changeLanguage;

  LanguagePopup({required this.changeLanguage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('English'),
            onTap: () => _onLanguageSelected(context, Locale('en', '')),  // English locale
          ),
          ListTile(
            title: Text('Spanish'),
            onTap: () => _onLanguageSelected(context, Locale('es', '')),  // Spanish locale
          ),
          ListTile(
            title: Text('Bengali'),
            onTap: () => _onLanguageSelected(context, Locale('bn', '')),  // Bengali locale
          ),
          ListTile(
            title: Text('Arabic'),
            onTap: () => _onLanguageSelected(context, Locale('ar', 'AE')),  // Arabic locale
          ),
        ],
      ),
    );
  }

  void _onLanguageSelected(BuildContext context, Locale locale) {
    changeLanguage(locale);  // Notify the app to change the locale
    Navigator.pop(context);  // Close the dialog
  }
}
