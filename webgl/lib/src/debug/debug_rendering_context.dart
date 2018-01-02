import 'dart:async';
@MirrorsUsed(targets:const[DebugRenderingContext, RenderingErrorEvent], override:'*')
import 'dart:mirrors';
import 'dart:web_gl';

class DebugRenderingContext implements RenderingContext {
  final StreamController<RenderingErrorEvent> _onErrorController;
  final RenderingContext _gl;

  DebugRenderingContext(RenderingContext gl)
      : _gl = gl
  , _onErrorController = new StreamController<RenderingErrorEvent>();

  Stream<RenderingErrorEvent> get onError => _onErrorController.stream;

  dynamic noSuchMethod(Invocation invocation) {
    // Invoke the method and get the result
    var mirror = reflect(_gl);
    dynamic result = mirror.delegate(invocation);

    // See if there was an error
    var errorCode = _gl.getError();

    // Multiple errors can occur with a single call to WebGL so continue to
    // loop until WebGL doesn't return an error
    while (errorCode != RenderingContext.NO_ERROR) {
      if (!_onErrorController.isPaused) {
        // Query the symbol name
        var methodName = MirrorSystem.getName(invocation.memberName);

        // Put the error in the stream
        _onErrorController.add(new RenderingErrorEvent(errorCode, methodName));
      }

      errorCode = _gl.getError();
    }

    return result;
  }
}

class RenderingErrorEvent {
  /// The [WebGL] error code.
  final int error;
  /// The name of the method whose call resulted in the [error].
  final String methodName;

  RenderingErrorEvent(this.error, this.methodName);

  /// Retrieves a human readable error message.
  String get message {
    String errorMessage;

    switch (error) {
      case RenderingContext.INVALID_ENUM:
        errorMessage = 'An unacceptable value is specified for an enumerated argument. The offending command is ignored and has no other side effect than to set the error flag.';
        break;
      case RenderingContext.INVALID_VALUE:
        errorMessage = 'A numeric argument is out of range. The offending command is ignored and has no other side effect than to set the error flag.';
        break;
      case RenderingContext.INVALID_OPERATION:
        errorMessage = 'The specified operation is not allowed in the current state. The offending command is ignored and has no other side effect than to set the error flag.';
        break;
      case RenderingContext.INVALID_FRAMEBUFFER_OPERATION:
        errorMessage = 'The framebuffer object is not complete. The offending command is ignored and has no other side effect than to set the error flag.';
        break;
      case RenderingContext.OUT_OF_MEMORY:
        errorMessage = 'There is not enough memory left to execute the command. The state of the GL is undefined, except for the state of the error flags, after this error is recorded.';
        break;
      default:
        errorMessage = 'An unknown error occurred';
        break;
    }

    return '${methodName}: ${errorMessage}';
  }
}