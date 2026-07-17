# セットアップ手順

## 1. Supabase

1. Supabaseで新規プロジェクトを作成（既存プロジェクトの流用でも可）
2. 左メニュー「SQL Editor」を開き、`schema.sql` の中身を貼り付けて実行
3. 「Authentication」→「Users」→「Add user」から、自分の管理者用メールアドレスとパスワードでユーザーを作成
   （このメール/パスワードがポータルの「管理者ログイン」で使うログイン情報になります）
4. お好みで「Authentication」→「Providers」→「Email」の「Allow new users to sign up」をOFFにしておくと、他の人が誤って新規登録できなくなります（今回のUIには登録フォーム自体がないので必須ではありません）
5. 「Project Settings」→「API」を開き、以下2つをコピー
   - Project URL
   - anon public key

## 2. index.html の設定

`index.html` 内、`<script>` タグの先頭付近にある以下2行を、上でコピーした値に書き換えてください。

```js
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

## 3. GitHubへpush

wrapper-portal フォルダをGitHubリポジトリにpushしてください。

```
git init
git add .
git commit -m "wrapper portal init"
git branch -M main
git remote add origin <あなたのリポジトリURL>
git push -u origin main
```

## 4. Renderで公開

1. Renderダッシュボード → 「New」→「Static Site」
2. 上のGitHubリポジトリを選択
3. Build Command: 空欄のまま
4. Publish Directory: `.` (ルート)
5. Deploy

デプロイ完了後に発行されるURLを他の人に共有すればOKです。管理者(あなた)がポータル上でログインしてアプリを追加すると、そのURLを開いた全員にそのまま反映されます。

## 更新について

`SUPABASE_URL` / `SUPABASE_ANON_KEY` を書き換えたら、再度 `git add . && git commit && git push` してください。Renderはpushを検知して自動で再デプロイします（コード自体を変えない、アプリの追加・編集・削除だけなら再デプロイ不要。データはSupabase側にリアルタイムで保存されます）。
