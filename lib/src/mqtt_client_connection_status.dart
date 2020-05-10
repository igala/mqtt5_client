/*
 * Package : mqtt5_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/05/2020
 * Copyright :  S.Hamblett
 */

part of mqtt5_client;

/// Records the status of the last connection attempt
class MqttClientConnectionStatus {
  /// Connection state
  MqttConnectionState state = MqttConnectionState.disconnected;

  /// Return code
  MqttConnectReturnCode returnCode = MqttConnectReturnCode.noneSpecified;

  /// Disconnection origin
  MqttDisconnectionOrigin disconnectionOrigin = MqttDisconnectionOrigin.none;

  @override
  String toString() {
    final s = state.toString().split('.')[1];
    final r = returnCode.toString().split('.')[1];
    final t = disconnectionOrigin.toString().split('.')[1];
    return 'Connection status is $s with return code of $r and a disconnection origin of $t';
  }
}
