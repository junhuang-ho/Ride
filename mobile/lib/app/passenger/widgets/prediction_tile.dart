import 'package:flutter/material.dart';
import 'package:ride/models/prediction.dart';

class PredictionTile extends StatelessWidget {
  const PredictionTile({Key? key, required this.prediction, this.onSelect})
      : super(key: key);

  final Prediction prediction;
  final Function? onSelect;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (onSelect != null) {
          onSelect!();
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              const Icon(Icons.location_on, color: Color(0xFFadadad)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      prediction.mainText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      prediction.secondaryText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFadadad)),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
