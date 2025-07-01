import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String id;
  final String? avatarUrl; // can be null

  const ProfileHeader({
    super.key,
    required this.name,
    required this.id,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.accent,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Text(
                  name.characters.first,
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "ID: $id",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}