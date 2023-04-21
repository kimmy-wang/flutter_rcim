import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
import 'package:synchronized/synchronized.dart';

class EngineManager {
  /// 私有构造器
  EngineManager._();

  RCIMIWEngine? _engine;
  bool connected = false;

  /// 静态变量指向自身
  static final EngineManager _instance = EngineManager._();
  static final Lock _lock = Lock();

  /// 静态属性获得实例变量
  static EngineManager get instance => _instance;

  /// -------------------------容器初始化start---------------------------------

  Future<void> init() async {
    if (_engine == null) {
      await _lock.synchronized(() async {
        if (_engine == null) {
          final options = RCIMIWEngineOptions.create();
          final compressOptions = RCIMIWCompressOptions.create();
          final pushOptions = RCIMIWPushOptions.create(
            enableHWPush: false,
            enableFCM: false,
            enableVIVOPush: false,
          );
          options
            ..pushOptions = pushOptions
            ..compressOptions = compressOptions;
          final engine =
              await RCIMIWEngine.create('your appkey', options);
          _engine = engine;
        }
      });
    }
  }

  void addEngineListener() {
    assertEngine();
    _engine!.onMessageReceived =
        (RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage) {
      print(
          '[addEngineListener]: message: ${message.toString()}, left: $left, offline: $offline, hasPackage: $hasPackage');
    };
  }

  Future<int> connect() async {
    assertEngine();
    final callback = RCIMIWConnectCallback(
      onDatabaseOpened: (int? code) {
        print('[connect:onDatabaseOpened]: code: $code');
      },
      onConnected: (int? code, String? userId) {
        print('[connect:onConnected]: code: $code, userId: $userId');
        connected = code == 0;
      },
    );
    final code = await _engine!.connect('your im token', 0, callback: callback);
    print('[connect]: code: $code');
    return code;
  }

  /// 断开链接
  /// - [receivePush] 退出后是否接收 push，true:断开后接收远程推送，false:断开后不再接收远程推送
  /// - [返回值] 当次接口操作的状态码。0 代表调用成功 具体结果需要实现接口回调，非 0 代表当前接口调用操作失败，不会触发接口回调，详细错误参考错误码
  Future<int> disconnect({bool receivePush = false}) async {
    assertEngine();
    final code = await _engine!.disconnect(receivePush);
    print('[disconnect]: code: $code');
    connected = code == 0;
    return code;
  }

  Future<void> destroy() async {
    assertEngine();
    await _engine!.destroy();
    _engine = null;
  }

  /// -------------------------容器初始化end-----------------------------------

  /// -------------------------会话start---------------------------------

  Future<int> getSessions(
    String? channelId,
    int startTime,
    int count,
  ) async {
    assertEngine();
    final callback = IRCIMIWGetConversationsCallback(
      onSuccess: (List<RCIMIWConversation>? t) {
        print('[getSessions >>> onSuccess]: $t');
      },
      onError: (int? code) {
        print('[getSessions >>> onError]: $code');
      },
    );
    final code = await _engine!.getConversations(
      [
        RCIMIWConversationType.private,
        RCIMIWConversationType.group,
        RCIMIWConversationType.chatroom,
        RCIMIWConversationType.system,
      ],
      channelId,
      startTime,
      count,
      callback: callback,
    );
    print('[getSessions]: code: $code');
    return code;
  }

  /// -------------------------会话end-----------------------------------

  void assertEngine() {
    assert(
      _engine != null,
      'engine must not be null, please call init() first.',
    );
  }
}
