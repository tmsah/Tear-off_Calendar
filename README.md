# こゆみ物語（Tear-off_Calendar）
2016/01/01〜2016/12/31の期間に運用されていた「暦物語」のパロディアプリ「こゆみ物語」です．  
iOSアプリです．Androidには対応していません．  
2020/01/01〜2020/12/31の期間に運用することを想定していますが，運用期間や長さは可変にしてあります．  
毎日ログインしてその日のカレンダーをめくると，いろんな人の名言を見ることができます．  
月ごとのカレンダーでは，それまでめくった日の名言を振り返ることができます．  
他人のツイートを名言として使う場合は，ツイートした日付も表示することができます．  


![](https://github.com/tmsah/Tear-off_Calendar/blob/images/demo.png)

## 開発環境
```
macOS: 10.15.1 (Catalina)
Swift: 5.1.2
Xcode: 11.2 
```

## インストール手順
### 用意するもの
結構色々なものが必要．
- `DatesInfo.json`(366日分の名言を記述したjsonファイル)
形式は以下の通り．
```
{
    "datesInfo": [
        {
            "day": "01-01",
            "id": "Descartes",
            "person": "デカルト",
            "words": "一日一日を大切にしなさい。毎日のわずかな差が、人生にとって大きな差となって現れるのですから。",
            "tweetDay": "",
            "color": "green"
        },
        {
            "day": "01-02",
            "id": "tmsah",
            "person": "ざわ",
            "words": "大事なのは「あの人は特別だ」ではなく「あの人に出来たのだから自分にも出来る」",
            "tweetDay": "2017/03/17",
            "color": "blue"
        },
        
        .
        .
        .

    ]
}
```
これを366日分用意してください．  
作者はGoogleSpreadSheetでまとめた後にcsvで出力し，jsonに変換しました．  
![](https://github.com/tmsah/Tear-off_Calendar/blob/images/gss.png)
変換に使ったpythonスクリプトは[ここ](https://github.com/tmsah/Tear-off_Calendar/blob/images/366.py)に置きました（csvファイル名は`366daysWord.csv`）．  
```
python 366.py
```
整形は，適当にWeb上で整形してくれるサービス使いました．  
（ここら辺の細かいやり方は何でもいいです．）
- 名言を言った人の画像（idのバリエーション分）
    - ファイル名はidと一致させる．デカルトなら`Descartes.png`．
- スタンプ画像（colorのバリエーション分）
    - ファイル名はcolorの後に`_stamp`．colorがpurpleなら`purple_stamp.png`．
    ![](https://github.com/tmsah/Tear-off_Calendar/blob/images/purple_stamp.png)
- 表紙画像（12枚）
    - ファイル名は月(2桁表示)の後に`_cover`．3月用の画像なら`03_cover.png`．
- 運用期間終了後の表示用画像．（1枚）
    - ファイル名は`end.png`．
- アイコン画像（必須ではない）
    - 色々な大きさの画像が必要になります．  
画像は`png`である必要はありません．  

### クローンからビルドまで
1. Xcodeで新規のプロジェクトを作成する．プロジェクト名は`Calendar`．  
`Calendar`じゃなくてもいいのかもしれないけど変えた場合どこで動かなくなるか分かりません．
1. Xcodeを一旦閉じ，Finderやコマンドラインなどから`Calendar`プロジェクト内の`ViewController.swift`と`Base.Iproj/Main.storyboard`を削除する．
1. 別の（捨て）ディレクトリにこのリポジトリを一旦クローンする．
```
git clone git@github.com:tmsah/Tear-off_Calendar.git
```
1. 全てのファイルをプロジェクト内の作業ディレクトリ（さっき`ViewController.swift`があった場所）にコピーする．`Main.storyboard`だけは`Base.Iproj/`に入れる．  
入ったらクローンしてきたリポジトリは削除して構いません．
1. 用意しておいた`DatesInfo.json`を同様に作業ディレクトリに置く．
1. 再びXcodeを起動する．
1. 作業ディレクトリに追加したファイルをプロジェクトにも追加する（Xcodeからできます．分からない人は調べてくれ．）．
1. 名言を言った人の画像（idのバリエーション分），スタンプ画像（colorのバリエーション分），表紙画像（12枚），終了画像（1枚）をプロジェクトに追加する．  
Xcode上で`Assets.xcassets`を選択しておいて，そこにドラッグ&ドロップでいける．
1. アプリのビルド．（Ctrl + R）．完成．

`ViewController.swift`の`firstDay`と`lastDay`をいじって運用期間を調整してあげてください．  
`color`のバリエーションは`CalendarVars.swift`にRGBで指定してあるので，増やしたければそれに倣ってください．

## その他もろもろ
基本的に暦物語を真似して作ってるのでそれとほぼ同じ挙動をします．ただしアニメはついていません．  
その代わりに本家よりも作り込んだ部分も地味にですけどあったりします．MonthlyからDailyに戻る部分とか．  
一番大変なのは366日分の名言を集めるところですね．  
ちなみにコード見てもらったら分かりますが考えるのを放棄した脳筋部分が少しあります（`getWordsInfo`とか...）．誰か直してください．
