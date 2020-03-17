import 'user_lite.dart';
import 'long_text.dart';

abstract class Content{
	DateTime createdAt;
	int id;
	String text;
	UserLite user;
	String mid;
	String idstr;
  LongText longText;
}
