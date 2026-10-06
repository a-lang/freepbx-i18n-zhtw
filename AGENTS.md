# AGENTS.md — FreePBX 多模組正體中文翻譯專案

## 0. 規則範圍與優先序

- 翻譯一律透過 `l10n-tw` 技能執行。本檔**只**記錄 FreePBX 專案事實與本專案特定決策。
- **本檔為本專案最高規則**；與技能 `SKILL.md`／`references/*.md` 衝突時以本檔為準。§2 領域術語表優先於技能 `references/terminology.md` 的同名詞條。
- 技能已涵蓋、本檔不重複：msgid 逐字元保留與多行折行、php-format 佔位符規則、位置式 `%N$` 語意、HTML/XML 標籤保留、中英中數半形空格與全形標點、PO 檔頭格式、禁止簡轉繁、批次切分與合併細節、`uv run` 與 polib 環境準備、`po_verify`／`msgfmt` 驗證 SOP。

## 1. 專案事實與檔案角色

- **`pot/<模組>.pot`** — 上游 POT 模板，**不可修改**。`amp` 來自 `FreePBX/framework` `release/17.0`；其餘模組來自各模組 repo 的 `i18n/<模組>.pot`。`FreePBX/freepbxlocalization` 已停更，勿參考。
- **`po/<模組>.po`** — 交付物，共 78 份（`amp` 核心 + 77 擴充模組），`Language: zh_TW`，檔名**無語言後綴**。
- **`work/`**（已 gitignore）— 翻譯工作區
  - `work/amp/`：唯一批次工作區，含 `amp.pot`、`amp-translations.py`、`batch01–22.json`（amp 2911 條 msgid，超技能 2000 條批次門檻）。
  - `work/deploy_dir/`：`deploy.sh` 暫存部署目錄。
  - 其餘 77 個模組無 translations 檔，譯文直接落在 `po/<模組>.po`。
- **編輯對象**
  - `amp`：先改 `work/amp/amp-translations.py`（或改 `batchNN.json` 後 `merge_batches.py`）再 `po_gen.py` 重新產生；**禁止手改 `po/amp.po`**（會與 translations 檔 drift）。
  - 其餘模組：直接編輯 `po/<模組>.po`。
- **跨模組一致性**：78 份 PO 之間同一字串須用同一譯法，以 §2 為準。
- **部署**：翻譯任務不碰部署；部署走 `deploy.sh`，語系／locale／套用步驟見 `README.md`。

## 2. 領域術語表（A→Z）

> 本表優先於技能 `references/terminology.md` 的同名詞條（含 Extension、Port、Queue、User、Module、Settings 等通用詞），差異以本表為準。

|English|譯文|
|---|---|
|Admin|管理員|
|Bind Address|綁定位址|
|Bind Port|綁定通訊埠|
|Call Detail Record|維持原文（CDR 全稱，見 CDR 條）|
|Call Event |通話事件 |
|Call Log|通話記錄（正確用法，見文末註）|
|Caller ID|來電顯示|
|Call Waiting|話中插接|
|CDR|維持 CDR（專有名詞，不翻為「通話詳單」；msgid 為全稱 Call Detail Record 時同樣保留原文）|
|Channel|通道|
|Code |簡碼 |
|Codec|編解碼器|
|Conference|會議（會議室）|
|Do Not Disturb |勿打擾 |
|DND |維持 DND (專有名詞) |
|Dashboard|儀表板|
|Device|裝置|
|DID|維持 DID|
|Enable / Disable|啟用 / 停用|
|Extension / Extensions|分機（電話語境；軟體 module 才譯「模組」，副檔名語境譯「副檔名」）|
|Feature Codes |功能簡碼 |
|Follow / Follow Me / Followme|跟隨|
|Inbound / Outbound|來電 / 外撥|
|IVR|維持 IVR（全稱時用「互動式語音應答」）|
|Logging|記錄檔（不可譯為「通話記錄」）|
|Module|模組|
|Notification|通知|
|Page / Paging|廣播|
|Park / Pickup|駐留 / 代接|
|Port|通訊埠|
|Queue|佇列|
|Repository|儲存庫|
|Responsive Firewall|維持 Responsive Firewall（Sangoma 防火牆產品名，不譯為「響防火牆」「回應式防火牆」）|
|Ring group|響鈴群組|
|Route / Routing|路由|
|Sangoma Smart Firewall|維持 Sangoma Smart Firewall（產品名，不譯為「智慧防火牆」）|
|Settings|設定|
|Submit / Submitting|送出|
|Track|發行軌道|
|Trunk|中繼（SIP trunk → SIP 中繼）|
|Uninstall / Upgrade / Downgrade|解除安裝 / 升級 / 降級|
|User|使用者|
|Voicemail|語音信箱|
|Wakeup Call |電話叫醒 |

> 「通話記錄」一詞僅用於 `Logging`（記錄檔）與 `Call Log`（通話記錄應用程式）語境，屬正確用法，不受 CDR 規則影響。

## 3. 本專案特定決策

- **跳過 CLI 對齊檢查**：FreePBX 屬網頁型（Web UI）翻譯，無 CLI 求助對齊需求，`po_align_check.py` 不執行。
- **回歸測試時機**：`regression_test.py` 僅在修改技能腳本後執行；本專案僅 `amp` 有 translations 檔。
- **佔位符**：FreePBX POT 佔位符多為無位置式 `%s`／`%d`；需重排語序時改用位置式 `%N$`，並以 `msgfmt -cv` 為準（細節見 guide §3.4）。
- **抽查門檻**（高於技能最低要求）：佔位符 ≥30 條（含全部 `%d`）、排版 ≥20 條。
- **交付**：僅產出 `po/<模組>.po`，不做其他檔案變更。
