# AGENTS.md — FreePBX 多模組正體中文翻譯專案鐵則

## 1. 專案事實與檔案角色

- **`pot/`**：各模組 POT 模板（如 `pot/amp.pot`、`pot/vmblast.pot`）——每模組翻譯任務對應一份，不可修改。
- **`work/` 每模組一子目錄**：`work/amp/`、`work/vmblast/`、`work/ivr/`…，子目錄內為 `<模組>.pot` 副本、`batchNN.json`（大型模組用）、`<模組>-translations.py`。20+ 模組以子目錄區隔，避免同層檔案過多。
- **單一真相來源**：各模組的 `<模組>-translations.py`——改翻譯先改它（或改 `batchNN.json` 後 `merge_batches.py` 合併），再 `po_gen.py` 重新生成。**禁止直接手改 `po/<模組>.po`**（會與 translations 檔 drift）。
- **交付物**：`po/<模組>.po`（`Language: zh_TW`，無語言後綴）。
- **上游參考**：各模組 POT 來自 FreePBX 官方 repo（如 `FreePBX/framework` 提供 `amp.pot`，其他模組各自 repo 的 `i18n/<模組>.pot`）；`FreePBX/freepbxlocalization` 已停更，勿參考。

## 2. 鐵則

- msgid 鍵（含前導空白、HTML、`\n`、標點）**逐字元保留**；多行 msgid 的鍵含真實換列，JSON 中為 `\n`，原樣保留。
- php-format 佔位符（僅 `%s`、`%d`）**數量與型別一一對應**；語序重排用位置式 `%1$s`、`%2$d`（msgid 無位置標記時勿重排，否則 msgfmt 報 c-format 錯誤）。禁止增刪佔位符。
- HTML 標籤（`<b>` `<br>` `<strong>` `<li>` `<a>` 等）逐字元保留；中英、中數之間加半形空格。
- 禁止簡轉繁；用語一對一一致（下表）。

## 3. 流程命令

批次檔位置（大型模組用）：`work/<模組>/batchNN.json`（行號範圍依 pot 版本切割；pot 更新時用 `extract_batch.py` 依條數重切）。

```bash
SKILLS=…/.agents/skills/l10n-tw/scripts

# 重新生成 PO（改翻譯後的標準動作）
uv run python3 $SKILLS/merge_batches.py work/<模組>/batch*.json -o work/<模組>/<模組>-translations.py
uv run python3 $SKILLS/fix_terminology.py work/<模組>/<模組>-translations.py
uv run python3 $SKILLS/po_gen.py pot/<模組>.pot -t work/<模組>/<模組>-translations.py -o po/<模組>.po \

# 兩項驗證
uv run python3 $SKILLS/po_verify.py pot/<模組>.pot po/<模組>.po --comments
msgfmt -cv po/<模組>.po -o /dev/null
```
CLI 對齊檢查步驟跳過：FreePBX 專案屬於網頁型翻譯任務，不需要做 CLI 對齊檢查。


品質自檢六項：① 用語掃描無 Remaining banned terms；② `po_verify` Coverage 100%；③ `msgfmt` 退出碼 0；④ 佔位符抽查 ≥30 條（含全部 `%d`）；⑤ 排版抽查 ≥20 條；⑥ EOF 恰一個換行、無尾端空白。

## 4. 領域術語表（一對一，全檔一致）

|English|譯文|
|---|---|
|extension / extensions|分機（電話語境；軟體 module 才譯「模組」，副檔名語境譯「副檔名」）|
|trunk|中繼（SIP trunk → SIP 中繼）|
|voicemail|語音信箱|
|IVR|維持 IVR（全稱時用「互動式語音應答」）|
|inbound / outbound|來電 / 外撥|
|route / routing|路由|
|ring group|響鈴群組|
|caller ID|來電顯示|
|DID|維持 DID|
|channel|通道|
|codec|編解碼器|
|queue|佇列|
|park / pickup|駐留 / 代接|
|conference|會議（會議室）|
|device|裝置|
|user / admin|使用者 / 管理員|
|module|模組|
|settings|設定|
|enable / disable|啟用 / 停用|
|uninstall / upgrade / downgrade|解除安裝 / 升級 / 降級|
|track|發行軌道|
|repository|儲存庫|
|dashboard|儀表板|
|notification|通知|

## 5. 技能使用（l10n-tw skill）

執行翻譯任務時，**必須使用 `l10n-tw` 技能**。所有翻譯、驗證、合併、術語修正等操作皆透過該技能提供的腳本與 SOP 執行，不得徒手繞過。
- 技能路徑：`/home/alang2/workspace/l10n-tw-projects/.agents/skills/l10n-tw/`
- 腳本位置：`skills/l10n-tw/scripts/`（`extract_batch.py`、`merge_batches.py`、`fix_terminology.py`、`po_gen.py`、`po_verify.py`、`po_align_check.py`、`regression_test.py` 等）
- 術語表：`skills/l10n-tw/references/terminology.md`
- 翻譯規範：`skills/l10n-tw/references/l10n-tw-guide.md`（含格式、排版、佔位符、檔頭等細節）

 本文件為 FreePBX 專案的**最高規則**；當與 `l10n-tw` 技能內的 `references/*.md` 衝突時，以本文件（AGENTS.md）為準。

## 6. 環境
- 指令一律 `uv run python3` 執行。
- polib 前置檢查：`uv run python3 -c "import polib"`；缺時依序 `uv venv` → `uv pip install polib`（順序不可顛倒）。

## 7. 交付
- 僅產出 PO 檔（`po/<模組>.po`）；本目錄無 git repo，不做 commit/push/PR。
