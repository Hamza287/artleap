import 'package:flutter/material.dart';

class AiFiltersGrid extends StatelessWidget {
  const AiFiltersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      "Fantasy Portraits",
      "Hunkify",
      "AI Stickers",
      "AI Headshots",
      "AI Scenes",
      "AI Headshots",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ai Filters",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54
                ),
              ),
              Text(
                "Transform your images with a single click",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 20, bottom: 8,right: 20),
          child: GridView.builder(
            itemCount: filters.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFECE9FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: index < 2
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("New", style: TextStyle(color: Colors.white, fontSize: 10)),
                      )
                          : const SizedBox(),
                    ),
                    Center(
                      child: Text(filters[index], textAlign: TextAlign.center),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
