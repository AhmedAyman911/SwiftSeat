import 'package:flutter/material.dart';

class CustomTextFormField {
  static Widget log(String text1,String hint,Icon icon,TextEditingController controller,bool seq) {
    return TextFormField(
      controller: controller,
      obscureText: seq,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        labelText: text1,
        hintText: hint,
        prefixIcon: icon,
      ),
    );
  }
  static Widget pas(
      String text1, String hint, Icon icon, TextEditingController controller, bool seq,Function(bool) toggleCallback) {
    return TextFormField(
      controller: controller,
      obscureText: seq,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        labelText: text1,
        hintText: hint,
        prefixIcon: icon,
        suffixIcon: IconButton(
          icon: Icon(seq ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            toggleCallback(!seq);
          },
        ),
      ),
    );
  }
}
