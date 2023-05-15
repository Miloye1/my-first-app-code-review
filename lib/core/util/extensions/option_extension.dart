import 'package:dartz/dartz.dart';

extension OptionX<T> on Option<T> {
  T? getSome() => (this as Some).value;
}
