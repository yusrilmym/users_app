import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistans/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/progress_dialog.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Setting Up Drop-off, please wait",
            ));

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occured, failed. No Response") {
      return;
    }

    if (responseApi["status"] == "OK") {
      //documentation
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      // print("\nlocation name =" + directions.locationName!);
      // print("\nlocation Lat =" + directions.locationLatitude!.toString());
      // print("\nlocation Lang =" + directions.locationLongitude!.toString());

      //get data
      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      Navigator.pop(context, "obtainedDropOff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 14.0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  predictedPlaces!.main_text!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white54),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Text(
                  predictedPlaces!.secondary_text!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.0, color: Colors.white54),
                ),
                const SizedBox(
                  height: 2.0,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
