import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardTimeControl extends StatelessWidget {
  const CardTimeControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Card(
        elevation: 2,
        color: colorScheme(context).background,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Symbols.child_care
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Nome do aluno exemplo",
                    style: textTheme(context).bodyLarge!.copyWith(
                      color: colorScheme(context).surface,
                      fontWeight: FontWeight.w600
                    )
                  )
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}