# hakoniwa-ev3rt-devkit

[TOPPERS/箱庭 単体ロボット向け](https://toppers.github.io/hakoniwa/prototypes/single-robot/#%E5%B0%8E%E5%85%A5%E6%96%B9%E6%B3%95)プロトタイプモデルのビルド・実行環境。


## 必須環境

- docker(docker-compose ファイルバージョン 3 以上が実行可能なもの)
- Unity
    - [Unityのインストール・パッケージのインポート・通信方式の切替方法](https://toppers.github.io/hakoniwa/single-robot-setup-detail/60_unity_install/) を参照


## 実行環境構成

Docker コンテナ上に構築した EV3RT とホスト上で起動した Unity が UDP で通信する構成。

Unity 側の設定は [UDP 用 Unity 設定 - 単体ロボット向けシミュレータ導入手順](https://toppers.github.io/hakoniwa/single-robot-setup-detail/61_unity_install_udp/) を参照。


```
+-----------------+       UDP(54001)      +-------+
| Docker コンテナ |---------------------->|       |
|     (EV3RT)     |                       | Unity |
|                 |<----------------------|       |
+-----------------+       UDP(54002)      +-------+
```


## 使い方

本リポジトリをクローンした後、リポジトリのルートディレクトリに移動し、「EV3RT アプリケーション開発手順」を実施する。

```sh
git clone --depth 1 https://github.com/mikoto2000/hakoniwa-ev3rt-devkit.git
cd hakoniwa-ev3rt-devkit
```


## EV3RT アプリケーション開発手順

### アプリケーションのディレクトリ共有設定

以下 2 つのどちらかで、 Docker コンテナに共有する EV3RT アプリケーションディレクトリを指定する。

- 環境変数 `EV3RT_APP_DIR` に、アプリケーションのディレクトリパスを設定する
- `docker-compose.yaml` の `volumes` セクションの `${EV3RT_APP_DIR}` をアプリケーションディレクトリに書き換える


#### Windows での環境変数設定の例

例えば [ライントレースのサンプルアプリ](https://github.com/toppers/hakoniwa-scenario-samples/tree/master/single-robot/line_trace) をビルドする場合。

```sh
$env:EV3RT_APP_DIR="C:/PATH/TO/line_trace"
```

#### Linux/Mac での環境変数設定の例

例えば [ライントレースのサンプルアプリ](https://github.com/toppers/hakoniwa-scenario-samples/tree/master/single-robot/line_trace) をビルドする場合。

```sh
export EV3RT_APP_DIR="/PATH/TO/line_trace"
```

### ビルドと実行

#### ビルドからシミュレータ起動まで一括で実行

毎回全ビルドしても問題なければこの方法。


```sh
docker-compose run --rm --service-ports ev3rt
```


#### ビルドとシミュレータ起動を別々に実行

差分ビルドが必要であればこの方法。


##### 開発環境コンテナ起動

```sh
docker-compose up -d
```

##### アプリケーションビルド

```sh
docker-compose exec ev3rt make img=app
```

※ アプリケーションはコンテナに `app` という名前でマウントしているため、 `img=app` の名前を変更する必要はない(`docker-compose.yaml` にて設定)

##### エミュレータ実行

```sh
docker-compose exec ev3rt make img=app start
```

必要であれば直接 `athrill2` コマンドを実行することで、起動方法や設定を変更できる。
([athrill の起動 - 単体ロボット向けシミュレータ使用手順(V850版)](https://toppers.github.io/hakoniwa/single-robot-usage/01_usage_v850/#athrill%E3%81%AE%E8%B5%B7%E5%8B%95) を参照)


※ アプリケーションはコンテナに `app` という名前でマウントしているため、 `img=app` の名前を変更する必要はない(`docker-compose.yaml` にて設定)



##### 開発環境コンテナ終了

```sh
docker-compose down
```


### バイナリの取得

`docker cp` コマンドでバイナリをコピーする。

実行例:

```sh
docker cp e74a3ba2e7d0:/ev3rt-athrill-v850e2m/sdk/workspace/asp ./asp
```

