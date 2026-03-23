# HyperOS Auto-Port Script

## Description

This script automates the porting process for HyperOS ROM.

## What the Script Does

The script performs the following operations automatically:

1. **Merges build.prop files** - Copies all properties from `mi_ext/etc/build.prop` and appends them to `product/etc/build.prop` 

2. **Copies mi_ext folders** - Transfers all folders from `mi_ext/product/` to `/product/`

3. **Moves Pangu system files** - Relocates all folders from `product/pangu/system/` to `system/system/`

4. **Syncs device features** - Copies all files from `stock/product/etc/device_features/` to the same path in port project

5. **Renames display config** - Finds and renames `display_id_**.xml` in port to match the stock ROM's naming convention

6. **Syncs VNDK apex files** - Copies missing `com.android.vndk.v**.apex` files from stock to port (only if they don't already exist)

## Prerequisites

Before running this script, you need to:

1. **Download and install [DNA Tools](https://github.com/StabilityBrickOS/DNA-Android)**
2. **Create two projects in DNA Tools:**
   - **stok** - For your stock ROM
   - **port** - For the ROM you're porting

3. **Unpack required partitions:**
   - In **stok** project: Unpack `system_ext` , `product` partitions
   - In **port** project: Unpack `system`, `system_ext`, `product`, and `mi_ext` partitions

## How to Use

### Step-by-Step Instructions:

1. Open **DNA Tools** application
2. Navigate to your **port** project
3. Go to **Plugins** section
4. Locate and select `HyperOS_AutoPort.zip2` and run the plugin
5. Wait for the script to complete all operations
6. Check the output log for any warnings or errors

## After Running the Script

### 1. Verify Changes
Check that all files were copied correctly by reviewing the script output log.

### 2. Pack Required Partitions in Port Project

In the **port** project, you need to pack the following partitions:

**Required partitions:**
- `system`
- `system_ext`
- `product`

**Additional partitions (use from your device's stock ROM):**
- `vendor`
- `odm` (optional - only if your device has this partition)
- `odm_dlkm` (optional - only if your device has this partition)
- `vendor_dlkm` (optional - only if your device has this partition)
- `system_dlkm` (optional - only if your device has this partition)

### 3. Rebuild super.img

Rebuild the `super.img` according to your device's partition type:

- **A-only** devices: Use A-only super building method
- **A/B** devices: Use A/B super building method  
- **Virtual A/B** devices: Use Virtual A/B super building method

Check your device's stock super type to determine the partition type.

### 4. Use Stock Kernel

**Important:** Always use the kernel (boot.img) from the **latest version** of your stock ROM. This ensures maximum compatibility and stability.

## Common Issues:

**"Project not found" error:**
- Ensure you've created both `DNA_stok` and `DNA_port` projects
- Check that project names are exactly `stok` and `port`

**"File not found" warnings:**
- Some warnings are normal if your ROM doesn't have certain partitions
- Only critical errors will stop the script

**Script doesn't run:**
- Make sure you're running it from the port project
- Check that you have proper permissions (DNA should handle this automatically)

**Missing files after porting:**
- Verify all partitions were unpacked correctly in both projects
- Re-run the script if needed (it's safe to run multiple times)

**Bootloop after flashing:**
- Check if you used the correct partition type (A-only/A/B/Virtual A/B)
- Verify you used stock kernel (boot.img) from latest stock ROM
- Make sure you packed vendor/odm from stock, not port
- Try using a custom kernel

**Super.img won't flash:**
- Size might be too large - check super partition size on your device from stock ROM
- Check that all partition images were created successfully

**System won't boot past logo:**
- Check if SELinux is causing issues (boot to permissive mode to test)
- Try disabling AVB 2.0

## Important Notes

- **Safe to re-run** - You can execute the script multiple times if needed
- **Non-destructive** - Original files in stock project remain untouched
- **Creates backups** - Build.prop is appended, not overwritten
- **Smart copying** - VNDK apex files are only copied if missing

### Testing Before Full Flash

1. Boot the ROM without installing via DSU sideloader
2. Test basic functionality
Only then do a full installation

## Compatibility

- ✅ Compatible only with MIUI/HyperOS file structure
- ✅ Tested on DNA Tools environment

## Credits

Created for the HyperOS porting community. Don't forget to credit the author if you made a port using this script. @Stability_BrickOS

---

**Version:** 1.1
**Last Updated:** February 2026  
**Compatibility:** DNA Tools
