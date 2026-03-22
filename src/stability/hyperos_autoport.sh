STOK_DIR="/data/DNA/DNA_stok"
PORT_DIR="/data/DNA/DNA_port"

echo "=========================================="
echo "[INFO] HyperOS Auto-Port Script"
echo "=========================================="
echo "[INFO] Stock project: $STOK_DIR"
echo "[INFO] Port project: $PORT_DIR"
echo ""

if [ ! -d "$STOK_DIR" ]; then
    echo "[ERROR] Stock project not found: $STOK_DIR"
    exit 1
fi

if [ ! -d "$PORT_DIR" ]; then
    echo "[ERROR] Port project not found: $PORT_DIR"
    exit 1
fi

echo "[STEP 1] Copying mi_ext build.prop to product..."

MI_EXT_BUILD_PROP="$PORT_DIR/mi_ext/etc/build.prop"
PRODUCT_BUILD_PROP="$PORT_DIR/product/etc/build.prop"

if [ -f "$MI_EXT_BUILD_PROP" ]; then
    if [ -f "$PRODUCT_BUILD_PROP" ]; then
        echo "[INFO] Appending mi_ext/etc/build.prop to product/etc/build.prop"
        {
            echo ""
            echo "# =========================================="
            echo "# imported from mi_ext"
            echo "# =========================================="
            cat "$MI_EXT_BUILD_PROP"
        } >> "$PRODUCT_BUILD_PROP"
        echo "[OK] Build.prop merged successfully"
    else
        echo "[WARNING] $PRODUCT_BUILD_PROP not found, skipping..."
    fi
else
    echo "[WARNING] $MI_EXT_BUILD_PROP not found, skipping..."
fi

echo ""

echo "[STEP 2] Copying folders from mi_ext/product/ to product/..."

MI_EXT_PRODUCT="$PORT_DIR/mi_ext/product"
PRODUCT_DIR="$PORT_DIR/product"

if [ -d "$MI_EXT_PRODUCT" ]; then
    cd "$MI_EXT_PRODUCT" || exit 1
    for item in *; do
        if [ -d "$item" ]; then
            echo "[INFO] Copying folder: $item"
            cp -rf "$item" "$PRODUCT_DIR/"
        fi
    done
    echo "[OK] All folders copied from mi_ext/product/"
else
    echo "[WARNING] $MI_EXT_PRODUCT not found, skipping..."
fi

echo ""

echo "[STEP 3] Moving folders from product/pangu/system/ to system/system/..."

PANGU_SYSTEM="$PORT_DIR/product/pangu/system"
SYSTEM_SYSTEM="$PORT_DIR/system/system"

if [ -d "$PANGU_SYSTEM" ]; then
    if [ -d "$SYSTEM_SYSTEM" ]; then
        cd "$PANGU_SYSTEM" || exit 1
        for item in *; do
            if [ -d "$item" ]; then
                echo "[INFO] Moving folder: $item"
                cp -rf "$item" "$SYSTEM_SYSTEM/"
                rm -rf "$item"
            fi
        done
        echo "[OK] All folders moved from product/pangu/system/"
    else
        echo "[WARNING] $SYSTEM_SYSTEM not found, skipping..."
    fi
else
    echo "[WARNING] $PANGU_SYSTEM not found, skipping..."
fi

echo ""

echo "[STEP 4] Copying device_features from stock to port..."

STOK_DEVICE_FEATURES="$STOK_DIR/product/etc/device_features"
PORT_DEVICE_FEATURES="$PORT_DIR/product/etc/device_features"

if [ -d "$STOK_DEVICE_FEATURES" ]; then
    if [ ! -d "$PORT_DEVICE_FEATURES" ]; then
        mkdir -p "$PORT_DEVICE_FEATURES"
    fi
    
    cd "$STOK_DEVICE_FEATURES" || exit 1
    for file in *; do
        if [ -f "$file" ]; then
            echo "[INFO] Copying: $file"
            cp -f "$file" "$PORT_DEVICE_FEATURES/"
        fi
    done
    echo "[OK] Device features copied"
else
    echo "[WARNING] $STOK_DEVICE_FEATURES not found, skipping..."
fi

echo ""

echo "[STEP 5] Renaming display_id XML to match stock..."

STOK_DISPLAYCONFIG="$STOK_DIR/product/etc/displayconfig"
PORT_DISPLAYCONFIG="$PORT_DIR/product/etc/displayconfig"

if [ -d "$STOK_DISPLAYCONFIG" ] && [ -d "$PORT_DISPLAYCONFIG" ]; then

    STOK_DISPLAY_FILE=$(cd "$STOK_DISPLAYCONFIG" && ls display_id_*.xml 2>/dev/null | head -n 1)
    
    if [ -n "$STOK_DISPLAY_FILE" ]; then
        echo "[INFO] Stock display file: $STOK_DISPLAY_FILE"
        

        PORT_DISPLAY_FILE=$(cd "$PORT_DISPLAYCONFIG" && ls display_id_*.xml 2>/dev/null | head -n 1)
        
        if [ -n "$PORT_DISPLAY_FILE" ]; then
            if [ "$STOK_DISPLAY_FILE" != "$PORT_DISPLAY_FILE" ]; then
                echo "[INFO] Renaming $PORT_DISPLAY_FILE to $STOK_DISPLAY_FILE"
                mv "$PORT_DISPLAYCONFIG/$PORT_DISPLAY_FILE" "$PORT_DISPLAYCONFIG/$STOK_DISPLAY_FILE"
                echo "[OK] Display config renamed"
            else
                echo "[INFO] Display config already has correct name"
            fi
        else
            echo "[WARNING] No display_id file found in port"
        fi
    else
        echo "[WARNING] No display_id file found in stock"
    fi
else
    echo "[WARNING] Display config directories not found, skipping..."
fi

echo ""

echo "[STEP 6] Copying missing VNDK apex files..."

STOK_VNDK_DIR="$STOK_DIR/system_ext/apex"
PORT_VNDK_DIR="$PORT_DIR/system_ext/apex"

if [ -d "$STOK_VNDK_DIR" ]; then
    if [ ! -d "$PORT_VNDK_DIR" ]; then
        mkdir -p "$PORT_VNDK_DIR"
    fi
    
    cd "$STOK_VNDK_DIR" || exit 1
    for file in com.android.vndk.v*.apex; do
        if [ -f "$file" ]; then
            if [ ! -f "$PORT_VNDK_DIR/$file" ]; then
                echo "[INFO] Copying missing VNDK: $file"
                cp -f "$file" "$PORT_VNDK_DIR/"
            else
                echo "[INFO] Already exists, skipping: $file"
            fi
        fi
    done
    echo "[OK] VNDK apex files processed"
else
    echo "[WARNING] $STOK_VNDK_DIR not found, skipping..."
fi

echo ""
echo "=========================================="
echo "[OK] HyperOS Auto-Port completed!"
echo "=========================================="
