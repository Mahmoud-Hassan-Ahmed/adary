class ResponseModel {
  bool _isSuccess;
  dynamic _message;
  ResponseModel(this._isSuccess, this._message);

  dynamic get message => _message;
  bool get isSuccess => _isSuccess;
}
