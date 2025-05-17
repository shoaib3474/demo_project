import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? rightText;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType; // ✅ Add this

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.rightText,
    this.onChanged,
    this.keyboardType = TextInputType.number, // ✅ Default to number
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // TextField
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType, // ✅ Use provided or default
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),

          // Optional right text
          if (!_isFocused && widget.rightText != null) ...[
            Container(height: 50, width: 1, color: Colors.grey.shade400),
            Container(
              width: 45,
              alignment: Alignment.center,
              child: Text(
                widget.rightText!,
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
