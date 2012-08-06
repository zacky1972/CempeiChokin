// Debug用の設定ファイル

#ifdef DEBUG
# define DNSLog(fmt, ...); NSLog(@"%s",__PRETTY_FUNCTION__); NSLog(fmt,##__VA_ARGS__);
#else
# define DNSLog(fmt, ...); // NSLog (__VA_ARGS__);
#endif

#define APP_DELEGATE AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate]

/*
DNSLog : NSLogをデバッグ専用にしたもの
         ついでにLog書いたメソッド名とクラス名も勝手に出力するようにしてみた
*/