import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onPickImage;

  const ControlButtons({
    super.key,
    required this.onTakePhoto,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LargeButton(
          icon: Icons.camera_alt,
          text: 'Take Photo',
          onPressed: onTakePhoto,
        ),
        _LargeButton(
          icon: Icons.photo_library,
          text: 'Choose Photo',
          onPressed: onPickImage,
        ),
      ],
    );
  }
}

//for accessibility sake, this large button widget was created so all buttons on the screen would be modelled after it
class _LargeButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const _LargeButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}