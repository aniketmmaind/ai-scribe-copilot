//for login api
enum LoginStatus { initial, loading, success, failure }

//for fetch list of patients associtated with user.
enum PatientStatus { initial, loading, success, failure }

//for fetch list of patients associtated with user.
enum PatientDetailsStatus { initial, loading, success, failure }

// for recording and api call
enum RecordingStatus { idle, recording, paused, stopped, loading, error }

/// for haptics
enum HapticType {
  light,
  medium,
  heavy,
  success,
  warning,
  vibrate,
  selectionChng,
  error,
}

enum AudioRouteStatus { speaker, wiredHeadset, bluetooth }

//for session status
enum SessionStatus { initial, loading, success, failure }
