import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../logic/models/exceptions.dart';
import 'messenger.dart';

class Navigation {
  /// future - future to run.
  /// initialRoute - the route name from which the function was called.
  ///                This serves as a return to widget incase error occured.
  /// destinationRoute - The route name to navigate to when future is completed.
  /// message - message to show when navigated to the destination route.
  static navigate({
    required BuildContext context,
    required Future future,
    required String initialRoute,
    required String destinationRoute,
    String? message,
  }) async {
    // show loading screen
    Navigator.pushNamed(context, '/loading');

    try {
      // wait for data to be fetched
      await future.then((value) {
        if (message != null) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Messenger.showSnackBar(message: message, context: context);
          });
        }
        Navigator.pushNamed(context, destinationRoute);
      });
    } catch (error) {
      // handle error and show error screen
      Navigator.pushNamed(context, initialRoute);
      // show error message
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        var err = error as UserDataException;
        Messenger.showSnackBar(message: err.errorMessage, context: context);
      });
    }
  }
}
