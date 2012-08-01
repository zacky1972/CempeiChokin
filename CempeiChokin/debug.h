// Debug用の設定ファイル

#ifdef DEBUG
# define DNSLog(...); NSLog(@"%s",__PRETTY_FUNCTION__); NSLog(__VA_ARGS__);
#else
# define DNSLog(...); // NSLog (__VA_ARGS__);
#endif

/*
DNSLog : NSLogをデバッグ専用にしたもの
         ついでにLog書いたメソッド名とクラス名も勝手に出力するようにしてみた
*/