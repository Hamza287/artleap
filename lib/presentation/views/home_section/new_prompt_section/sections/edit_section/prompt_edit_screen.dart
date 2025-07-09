import 'package:flutter/material.dart';

class PromptEditScreen extends StatelessWidget {
  const PromptEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 375;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: isSmallScreen ? 12 : 20),

                    // Image Upload Container
                    Container(
                      height: isLargeScreen
                          ? constraints.maxHeight * 0.6
                          : constraints.maxHeight * 0.4,
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade600),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: isLargeScreen ? 60 : 50,
                              color: Colors.black,
                            ),
                            SizedBox(height: isSmallScreen ? 8 : 10),
                            Text(
                              "Upload Image",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.9,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _roundIconButton(
                            icon: Icons.share,
                            size: isSmallScreen ? 40 : 50,
                          ),
                          _roundIconButton(
                            icon: Icons.download,
                            size: isSmallScreen ? 40 : 50,
                          ),
                          _roundIconButton(
                            icon: Icons.delete,
                            borderColor: Colors.red,
                            size: isSmallScreen ? 40 : 50,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 60),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _featureButton(
                            "Add Object",
                            Icons.edit,
                            isActive: true,
                            isSmallScreen: isSmallScreen,
                          ),
                          _featureButton(
                            "Remove Object",
                            Icons.remove,
                            isSmallScreen: isSmallScreen,
                          ),
                          _featureButton(
                            "Remove Background",
                            Icons.blur_on,
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // Instruction Text
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 20),
                      child: Text(
                        "Draw on the image above to select it and add a prompt to add or replace an object",
                        style: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 12 : 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Prompt", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 200, // Fixed height
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black54),
                          ),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Text("No prompt available", style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Generate Button
                    Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: isLargeScreen ? 64 : 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 20),
                            backgroundColor: const Color(0xFF9A57FF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Generate now ✨",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 6 : 10),
                              Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                                size: isSmallScreen ? 18 : 24,
                              ),
                              Text(
                                "20",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roundIconButton({
    required IconData icon,
    Color borderColor = Colors.black54,
    double size = 49,
  }) {
    return SizedBox(
      height: size,
      width: 110,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Icon(
          icon,
          color: borderColor,
          size: size * 0.6,
        ),
      ),
    );
  }

  Widget _featureButton(
      String label,
      IconData icon, {
        bool isActive = false,
        bool isSmallScreen = false,
      }) {
    final buttonSize = isSmallScreen ? 40.0 : 80.0;
    final fontSize = isSmallScreen ? 10.0 : 11.0;

    return SizedBox(
      width: buttonSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF9A57FF) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: BoxBorder.all(
                color: isActive ? Colors.transparent : Colors.black54,
              )
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.black,
              size: buttonSize * 0.5,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 6),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF9A57FF) : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}