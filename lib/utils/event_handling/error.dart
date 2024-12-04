import 'package:finance_tracker/utils/event_handling/done.dart';

class BlocError extends BlocEvent {
  Object? err;
  StackTrace? stack;
  BlocError(super.message, {this.err, this.stack});
}
