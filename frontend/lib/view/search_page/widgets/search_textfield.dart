import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;

  const SearchTextField(
      {Key? key, required this.hintText, required this.onSearch})
      : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onSearch,
        // Appeler la fonction de recherche lorsque le texte est soumis
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
