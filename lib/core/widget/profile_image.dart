import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String username;
  final double radius;
    final double size;

  const ProfileImage({
    super.key,
    required this.username,
    this.imageUrl,
    this.radius = 25,
     this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : null,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Text(
              username[0].toUpperCase(),
              style: TextStyle(
                fontSize: radius * 0.8,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
