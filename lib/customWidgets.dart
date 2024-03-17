import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
        ),
        child: Text(buttonText),
      ),
    );
  }
}

class DifficultyCard extends StatefulWidget {
  final String difficulty;
  final Function(bool isSelected) onSelect;

  const DifficultyCard({
    required this.difficulty,
    required this.onSelect,
  });

  @override
  _DifficultyCardState createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<DifficultyCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.onSelect(isSelected);
          });
        },
        child: Container(
          height: 100,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blue.withOpacity(0.3) : null,
          ),
          child: Center(
            child: Text(
              widget.difficulty,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
