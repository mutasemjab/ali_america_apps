/// The `type` field on a career specification — what kind of input to
/// render for it. Anything the backend sends that isn't one of these
/// renders as a plain text field rather than crashing.
class CareerSpecType {
  CareerSpecType._();

  static const String text = 'text';
  static const String select = 'select';
  static const String file = 'file';
}
