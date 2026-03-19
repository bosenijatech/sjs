import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/netsuite/credentials.dart';
import 'package:winstar/utils/netsuite/handlers/oauth_handler.dart';
import 'package:winstar/utils/netsuite/handlers/request_handler.dart';
import 'package:winstar/utils/netsuite/netsuite_client.dart';

class NetSuiteApiService {
  static const int timeOutDuration = 60;

  static Map<String, String> oauthCredentials = {
    // 'consumer_key':
    //     '2112f39da5df170d16c9da51b985fb3e3004eb8eab8be0f8a9d2199c4b06452d',
    // 'consumer_secret':
    //     'f183297f21ad6cdc3640f9a7874d1521108c6f2ee2285284e8ac71dc8bfc5321',
    // 'token': '4f06607f02a773ea01fee1ce8d63609ea3e7ba00d4de192cb3beab02e86c6662',
    // 'token_secret':
    //     '4acebbe44f17784363f73ce46844a5ec322682c6789c5dac8ce043040117e2d2',

    'consumer_key': Prefs.getnetsuiteConsumerKey('netsuiteConsumerKey')!,
    'consumer_secret':
        Prefs.getnetsuiteConsumerSecret('netsuiteConsumerSecret')!,
    'token': Prefs.getnetsuiteToken('netsuiteToken')!,
    'token_secret': Prefs.getnetsuiteTokenSecret('netsuiteTokenSecret')!,
  };
  static Credentials credentials =
      Credentials(NetSuiteApiService.oauthCredentials);
  static RequestHandler handler =
      OAuthHandler(credentials: NetSuiteApiService.credentials);
  static NetsuiteClient client = NetsuiteClient(handler: handler);
}
