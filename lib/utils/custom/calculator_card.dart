import 'package:flutter/material.dart';

class CalculatorCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap; // Callback for tap action

  const CalculatorCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap, // Required onTap callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap action
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(
                    0.5,
                  ), // Shadow color with opacity
                  blurRadius: 8, // Blur radius for the shadow
                  offset: const Offset(0, 4), // Offset for the shadow
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 54),
          ),
          const SizedBox(height: 8), // Spacing between the container and text
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
