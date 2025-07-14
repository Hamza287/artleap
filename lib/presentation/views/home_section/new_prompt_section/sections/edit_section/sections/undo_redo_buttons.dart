import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Artleap.ai/providers/prompt_edit_provider.dart';

import '../../../../../../../shared/constants/app_textstyle.dart';

class UndoRedoButtons extends ConsumerWidget {
  const UndoRedoButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Undo',style: AppTextstyle.interBold(fontSize: 18,color: Colors.black),),
              const SizedBox(height: 3),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: IconButton(
                  icon: const Icon(Icons.undo, color: Colors.black),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () => ref.read(promptEditProvider.notifier).undo(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Space between buttons
         Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Redo',style: AppTextstyle.interBold(fontSize: 18,color: Colors.black),),
             const SizedBox(width: 3),
             Container(
               width: MediaQuery.of(context).size.width * 0.4,
               decoration: BoxDecoration(
                 border: Border.all(color: Colors.black, width: 1),
                 borderRadius: BorderRadius.circular(12),
                 color: Colors.transparent,
               ),
               child: IconButton(
                 icon: const Icon(Icons.redo, color: Colors.black),
                 padding: const EdgeInsets.all(8),
                 constraints: const BoxConstraints(),
                 onPressed: () => ref.read(promptEditProvider.notifier).redo(),
               ),
             ),
           ],
         )
        ],
      ),
    );
  }
}