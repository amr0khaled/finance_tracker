class BlocEvent {
  final String message;
  const BlocEvent(this.message);
}

class BlocDone extends BlocEvent {
  const BlocDone(super.message);
}
