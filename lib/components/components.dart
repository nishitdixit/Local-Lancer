import 'package:flutter/material.dart';

ClipPath backgroundClip(double heightPiece, double widthPiece) {
  return ClipPath(
      clipper: OrangeClipper(),
      child: Container(
        color: Color(0xffF57921),
        height: heightPiece * 10,
        width: widthPiece * 10,
      ));
}

TextField customTextField( String hintText, TextInputType inputType,Function onChanged,Widget prefixIcon) {
  return TextField(onChanged: onChanged,
    keyboardType: inputType,
    decoration: InputDecoration(prefixIcon: prefixIcon,
      border: InputBorder.none,
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

class OrangeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var widthPiece = size.width / 10;
    var heightPiece = size.height / 10;
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, heightPiece *9);
    path.arcToPoint(Offset(widthPiece * 3, heightPiece * 6));
    path.quadraticBezierTo((widthPiece*4), (heightPiece*5),(widthPiece*4.5), (heightPiece*5.3));
    path.arcToPoint(Offset(widthPiece * 5.5, heightPiece * 6.2));

    path.quadraticBezierTo(((widthPiece*6.4)), ((heightPiece*7.2)),((widthPiece*7.5)), ((heightPiece*6)));

    // path.arcToPoint(Offset(widthPiece * 6, heightPiece * 6));
    path.lineTo(size.width, heightPiece * 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
