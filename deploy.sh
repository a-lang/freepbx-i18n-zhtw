#!/usr/bin/env bash
set -euo pipefail

# 確認 msgfmt 可用
if ! command -v msgfmt &>/dev/null; then
    echo "錯誤：msgfmt 未安裝。請先安裝 gettext 套件。" >&2
    exit 1
fi

WORKDIR="$(pwd)"
# 部署目標：FreePBX 的 web root（非 po/ 所在目錄）
web_root="/var/www/html"

echo "Compiling .po files into .mo binaries for use…"

# 逐一處理 po/ 下的 .po 檔案
for pofile in "$WORKDIR"/po/*.po; do
  [ -f "$pofile" ] || continue
  FNAME="$(basename "$pofile" .po)"

  # 編譯為 .mo 二進位檔（供 FreePBX 載入）
  msgfmt -f -v "$pofile" -o "$WORKDIR/po/${FNAME}.mo"

  # 決定部署目的地：
  # - amp 是框架核心，語系檔逕放 admin/i18n/
  # - 其餘模組放在 admin/modules/<模組名>/i18n/
  if [ "$FNAME" = "amp" ]; then
    DEST="$web_root/admin/i18n/zh_TW/LC_MESSAGES"
  else
    # 模組目錄固定為 admin/modules/<模組名>；
    # 不可用 find 全 web root 撈，否則會誤中 framework 的 admin/api（與 api 模組撞名）
    REALPATH="$web_root/admin/modules/$FNAME"
    [ -d "$REALPATH" ] || continue # 找不到目標目錄則跳過
    DEST="$REALPATH/i18n/zh_TW/LC_MESSAGES"
  fi

  # 建立 zh_TW/LC_MESSAGES 目錄（若不存在），並複製 .po 與 .mo
  mkdir -p "$DEST"
  cp -v "$WORKDIR/po/${FNAME}."* "$DEST/"
done

# 清理：刪除 po/ 下產生的 .mo，避免留在工作目錄
echo "Deleting .mo files…"
find "$WORKDIR/po" -name "*.mo" -delete

echo "Done ($(date)), now refresh the browser and check out your work."
