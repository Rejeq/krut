class Stopwatch {
  Duration _base;
  DateTime? _runningSince;

  Stopwatch({this._base = Duration.zero, this._runningSince});

  Duration get elapsed {
    final running = _runningSince;
    if (running == null) return _base;
    final delta = DateTime.now().difference(running);
    return _base + (delta.isNegative ? Duration.zero : delta);
  }

  bool get isRunning => _runningSince != null;

  void start() {
    if (_runningSince != null) return;
    _runningSince = DateTime.now();
  }

  void stop() {
    if (_runningSince == null) return;
    _base += DateTime.now().difference(_runningSince!);
    _runningSince = null;
  }

  void reset() {
    _base = Duration.zero;
    _runningSince = null;
  }

  Duration get base => _base;
  DateTime? get runningSince => _runningSince;

  Stopwatch copyWith({
    Duration? base,
    DateTime? runningSince,
  }) {
    return Stopwatch(
      base: base ?? this.base,
      runningSince: runningSince ?? this.runningSince,
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Stopwatch &&
        other._base == _base &&
        other._runningSince?.millisecondsSinceEpoch ==
            _runningSince?.millisecondsSinceEpoch;
  }

  @override
  int get hashCode =>
      Object.hash(_base.inMicroseconds,
          _runningSince?.millisecondsSinceEpoch ?? 0);

  @override
  String toString() =>
      'Stopwatch(base: $_base, runningSince: $_runningSince)';
}
