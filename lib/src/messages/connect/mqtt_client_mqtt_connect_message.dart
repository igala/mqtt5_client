/*
 * Package : mqtt5_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/05/2020
 * Copyright :  S.Hamblett
 */

part of mqtt5_client;

/// An Mqtt message that is used to initiate a connection to a message broker.
/// After a Network Connection is established by a Client to a Server, the
/// first packet sent from the Client to the Server MUST be a CONNECT
/// packet [MQTT-3.1.0-1].
///
/// A Client can only send the CONNECT packet once over a Network Connection.
class MqttConnectMessage extends MqttMessage {
  /// Initializes a new instance of the MqttConnectMessage class.
  /// Only called via the MqttMessage.create operation during processing of
  /// an Mqtt message stream.
  MqttConnectMessage() {
    header = MqttHeader().asType(MqttMessageType.connect);
    variableHeader = MqttConnectVariableHeader();
    payload = MqttConnectPayload(variableHeader);
  }

  ///  Initializes a new instance of the MqttConnectMessage class.
  MqttConnectMessage.fromByteBuffer(
      MqttHeader header, MqttByteBuffer messageStream) {
    this.header = header;
    readFrom(messageStream);
  }

  /// Sets the startClean flag so that the broker drops any messages
  /// that were previously destined for us.
  MqttConnectMessage startClean() {
    variableHeader.connectFlags.cleanStart = true;
    return this;
  }

  /// Sets the keep alive period
  MqttConnectMessage keepAliveFor(int keepAliveSeconds) {
    variableHeader.keepAlive = keepAliveSeconds;
    return this;
  }

  /// Sets the Will flag of the variable header
  MqttConnectMessage will() {
    variableHeader.connectFlags.willFlag = true;
    return this;
  }

  /// Sets the WillQos of the connect flag.
  MqttConnectMessage withWillQos(MqttQos qos) {
    variableHeader.connectFlags.willQos = qos;
    return this;
  }

  /// Sets the WillRetain flag of the Connection Flags
  MqttConnectMessage withWillRetain() {
    variableHeader.connectFlags.willRetain = true;
    return this;
  }

  /// Sets the client identifier of the message.
  MqttConnectMessage withClientIdentifier(String clientIdentifier) {
    payload.clientIdentifier = clientIdentifier;
    return this;
  }

  /// Sets the will message.
  MqttConnectMessage withWillMessage(String willMessage) {
    will();
    payload.willMessage = willMessage;
    return this;
  }

  /// Sets the Will Topic
  MqttConnectMessage withWillTopic(String willTopic) {
    will();
    payload.willTopic = willTopic;
    return this;
  }

  /// Sets the authentication
  MqttConnectMessage authenticateAs(String username, String password) {
    if (username != null) {
      variableHeader.connectFlags.usernameFlag = username.isNotEmpty;
      payload.username = username;
    }
    if (password != null) {
      variableHeader.connectFlags.passwordFlag = password.isNotEmpty;
      payload.password = password;
    }
    return this;
  }

  /// The variable header contents. Contains extended metadata about the message
  MqttConnectVariableHeader variableHeader;

  /// The payload of the Mqtt Message.
  MqttConnectPayload payload;

  /// Writes the message to the supplied stream.
  @override
  void writeTo(MqttByteBuffer messageStream) {
    header.writeTo(variableHeader.getWriteLength() + payload.getWriteLength(),
        messageStream);
    variableHeader.writeTo(messageStream);
    payload.writeTo(messageStream);
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write(super.toString());
    sb.writeln(variableHeader.toString());
    sb.writeln(payload.toString());
    return sb.toString();
  }
}
