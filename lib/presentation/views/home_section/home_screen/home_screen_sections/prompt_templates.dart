import 'package:flutter/material.dart';

class PromptTemplates extends StatelessWidget {
  const PromptTemplates({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = [
      "",
      "",
      "",
      "",
      "",
      ""
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            "Prompt Templates",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: styles.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120, // Adjust width as needed
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE9FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    styles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
