part of game_server;

/// Ids of packets
class PacketIds {
  static const PING_REQUEST = 1;
  static const PING_RESPONSE = 2;

  static const CREATE_PLAYER_REQUEST = 3;
  static const CREATE_PLAYER_RESPONSE = 4;

  static const PLAYER_LOGIN_REQUEST = 5;
  static const PLAYER_LOGIN_RESPONSE = 6;

  static const GET_ROOM_LIST_REQUEST = 7;
  static const GET_ROOM_LIST_RESPONSE = 8;

  static const JOIN_ROOM_REQUEST = 9;
  static const JOIN_ROOM_RESPONSE = 10;

  static const START_GAME_REQUEST = 11;
  static const START_GAME_RESPONSE = 12;

  static const GET_PLAYER_LIST_REQUEST = 13;
  static const GET_PLAYER_LIST_RESPONSE = 14;

  static const INPUT_STATE_REQUEST = 15;
  static const INPUT_STATE_RESPONSE = 16;

  static const PLAYER_POSITION_PUSH = 17;
}
