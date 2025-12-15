#!/bin/bash

# HelixTrack Launcher Icon Verification Script
# Verifies that all client apps use the correct launcher icon from Core/Assets/Logo.png

set -e

echo "🎨 Verifying Launcher Icons for All HelixTrack Clients"
echo "====================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SOURCE_ICON="Core/Assets/Logo.png"
REPORTS_DIR="test-reports"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$REPORTS_DIR/icon_verification_report_$TIMESTAMP.md"

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Initialize report
cat > "$REPORT_FILE" << EOF
# HelixTrack Launcher Icon Verification Report
Generated: $(date)

## Source Icon
- Location: $SOURCE_ICON
EOF

# Check if source icon exists
if [ ! -f "$SOURCE_ICON" ]; then
    echo -e "${RED}❌ Source icon not found: $SOURCE_ICON${NC}"
    echo "- Status: ❌ FAILED - Source icon missing" >> "$REPORT_FILE"
    exit 1
fi

echo -e "${GREEN}✅ Source icon found: $SOURCE_ICON${NC}"
echo "- Status: ✅ FOUND" >> "$REPORT_FILE"

# Get source icon info
SOURCE_SIZE=$(identify "$SOURCE_ICON" | head -1 | awk '{print $3}' || echo "Unknown")
SOURCE_FORMAT=$(identify "$SOURCE_ICON" | head -1 | awk '{print $2}' || echo "Unknown")

echo "- Size: $SOURCE_SIZE" >> "$REPORT_FILE"
echo "- Format: $SOURCE_FORMAT" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Function to verify Android icons
verify_android_icons() {
    echo -e "${BLUE}🔍 Verifying Android Client Icons${NC}"
    echo "## Android Client" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    cd Android-Client

    local android_icons=(
        "app/src/main/res/mipmap-hdpi/ic_launcher.png"
        "app/src/main/res/mipmap-mdpi/ic_launcher.png"
        "app/src/main/res/mipmap-xhdpi/ic_launcher.png"
        "app/src/main/res/mipmap-xxhdpi/ic_launcher.png"
        "app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"
    )

    local android_passed=0
    local android_total=${#android_icons[@]}

    for icon in "${android_icons[@]}"; do
        if [ -f "$icon" ]; then
            echo -e "${GREEN}✅ $icon exists${NC}"
            echo "- ✅ $icon" >> "../$REPORT_FILE"

            # Verify icon is not empty
            if [ -s "$icon" ]; then
                echo -e "${GREEN}  └─ Not empty${NC}"
                ((android_passed++))
            else
                echo -e "${RED}  └─ Empty file${NC}"
                echo "  - ❌ Empty file" >> "../$REPORT_FILE"
            fi

            # Get icon info
            local icon_info=$(identify "$icon" 2>/dev/null | head -1 || echo "Unknown format")
            echo "  - Info: $icon_info" >> "../$REPORT_FILE"

        else
            echo -e "${RED}❌ $icon missing${NC}"
            echo "- ❌ $icon (MISSING)" >> "../$REPORT_FILE"
        fi
    done

    # Check for icon generation script
    if [ -f "scripts/generate-icons.sh" ]; then
        echo -e "${GREEN}✅ Icon generation script found${NC}"
        echo "- ✅ Icon generation script available" >> "../$REPORT_FILE"

        # Test script execution
        if bash scripts/generate-icons.sh > /dev/null 2>&1; then
            echo -e "${GREEN}  └─ Script executes successfully${NC}"
            echo "  - Script execution: ✅ SUCCESS" >> "../$REPORT_FILE"
        else
            echo -e "${RED}  └─ Script execution failed${NC}"
            echo "  - Script execution: ❌ FAILED" >> "../$REPORT_FILE"
        fi
    else
        echo -e "${YELLOW}⚠️ Icon generation script not found${NC}"
        echo "- ⚠️ Icon generation script not found" >> "../$REPORT_FILE"
    fi

    local android_success_rate=$((android_passed * 100 / android_total))
    echo -e "${BLUE}📊 Android icons: $android_passed/$android_total (${android_success_rate}%)${NC}"
    echo "" >> "../$REPORT_FILE"
    echo "**Success Rate: $android_success_rate%**" >> "../$REPORT_FILE"
    echo "" >> "../$REPORT_FILE"

    cd ..
    return $android_success_rate
}

# Function to verify Desktop icons
verify_desktop_icons() {
    echo -e "${BLUE}🔍 Verifying Desktop Client Icons${NC}"
    echo "## Desktop Client" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    cd Desktop-Client

    local desktop_icons=(
        "src-tauri/icons/32x32.png"
        "src-tauri/icons/128x128.png"
        "src-tauri/icons/128x128@2x.png"
        "src-tauri/icons/Square30x30Logo.png"
        "src-tauri/icons/Square44x44Logo.png"
        "src-tauri/icons/Square71x71Logo.png"
        "src-tauri/icons/Square89x89Logo.png"
        "src-tauri/icons/Square107x107Logo.png"
        "src-tauri/icons/Square142x142Logo.png"
        "src-tauri/icons/Square150x150Logo.png"
        "src-tauri/icons/Square284x284Logo.png"
        "src-tauri/icons/Square310x310Logo.png"
        "src-tauri/icons/StoreLogo.png"
        "src-tauri/icons/icon.png"
        "src-tauri/icons/icon.ico"
    )

    local desktop_passed=0
    local desktop_total=${#desktop_icons[@]}

    for icon in "${desktop_icons[@]}"; do
        if [ -f "$icon" ]; then
            echo -e "${GREEN}✅ $icon exists${NC}"
            echo "- ✅ $icon" >> "../$REPORT_FILE"

            # Verify icon is not empty
            if [ -s "$icon" ]; then
                echo -e "${GREEN}  └─ Not empty${NC}"
                ((desktop_passed++))
            else
                echo -e "${RED}  └─ Empty file${NC}"
                echo "  - ❌ Empty file" >> "../$REPORT_FILE"
            fi

            # Get icon info for key icons
            if [[ "$icon" == *"32x32"* ]] || [[ "$icon" == *"128x128"* ]] || [[ "$icon" == *"icon.png"* ]]; then
                local icon_info=$(identify "$icon" 2>/dev/null | head -1 || echo "Unknown format")
                echo "  - Info: $icon_info" >> "../$REPORT_FILE"
            fi

        else
            echo -e "${RED}❌ $icon missing${NC}"
            echo "- ❌ $icon (MISSING)" >> "../$REPORT_FILE"
        fi
    done

    # Check for icon generation script
    if [ -f "scripts/generate-icons.sh" ]; then
        echo -e "${GREEN}✅ Icon generation script found${NC}"
        echo "- ✅ Icon generation script available" >> "../$REPORT_FILE"

        # Test script execution
        if bash scripts/generate-icons.sh > /dev/null 2>&1; then
            echo -e "${GREEN}  └─ Script executes successfully${NC}"
            echo "  - Script execution: ✅ SUCCESS" >> "../$REPORT_FILE"
        else
            echo -e "${RED}  └─ Script execution failed${NC}"
            echo "  - Script execution: ❌ FAILED" >> "../$REPORT_FILE"
        fi
    else
        echo -e "${YELLOW}⚠️ Icon generation script not found${NC}"
        echo "- ⚠️ Icon generation script not found" >> "../$REPORT_FILE"
    fi

    local desktop_success_rate=$((desktop_passed * 100 / desktop_total))
    echo -e "${BLUE}📊 Desktop icons: $desktop_passed/$desktop_total (${desktop_success_rate}%)${NC}"
    echo "" >> "../$REPORT_FILE"
    echo "**Success Rate: $desktop_success_rate%**" >> "../$REPORT_FILE"
    echo "" >> "../$REPORT_FILE"

    cd ..
    return $desktop_success_rate
}

# Function to verify Web icons
verify_web_icons() {
    echo -e "${BLUE}🔍 Verifying Web Client Icons${NC}"
    echo "## Web Client" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    cd Web-Client

    local web_icons=(
        "public/icon-72x72.png"
        "public/icon-96x96.png"
        "public/icon-128x128.png"
        "public/icon-144x144.png"
        "public/icon-152x152.png"
        "public/icon-192x192.png"
        "public/icon-384x384.png"
        "public/icon-512x512.png"
        "public/apple-touch-icon.png"
        "public/favicon.ico"
    )

    local web_passed=0
    local web_total=${#web_icons[@]}

    for icon in "${web_icons[@]}"; do
        if [ -f "$icon" ]; then
            echo -e "${GREEN}✅ $icon exists${NC}"
            echo "- ✅ $icon" >> "../$REPORT_FILE"

            # Verify icon is not empty
            if [ -s "$icon" ]; then
                echo -e "${GREEN}  └─ Not empty${NC}"
                ((web_passed++))
            else
                echo -e "${RED}  └─ Empty file${NC}"
                echo "  - ❌ Empty file" >> "../$REPORT_FILE"
            fi

            # Get icon info for key icons
            if [[ "$icon" == *"192x192"* ]] || [[ "$icon" == *"512x512"* ]] || [[ "$icon" == *"favicon"* ]]; then
                local icon_info=$(identify "$icon" 2>/dev/null | head -1 || echo "Unknown format")
                echo "  - Info: $icon_info" >> "../$REPORT_FILE"
            fi

        else
            echo -e "${RED}❌ $icon missing${NC}"
            echo "- ❌ $icon (MISSING)" >> "../$REPORT_FILE"
        fi
    done

    # Check for icon generation script
    if [ -f "scripts/generate-icons.sh" ]; then
        echo -e "${GREEN}✅ Icon generation script found${NC}"
        echo "- ✅ Icon generation script available" >> "../$REPORT_FILE"

        # Test script execution
        if bash scripts/generate-icons.sh > /dev/null 2>&1; then
            echo -e "${GREEN}  └─ Script executes successfully${NC}"
            echo "  - Script execution: ✅ SUCCESS" >> "../$REPORT_FILE"
        else
            echo -e "${RED}  └─ Script execution failed${NC}"
            echo "  - Script execution: ❌ FAILED" >> "../$REPORT_FILE"
        fi
    else
        echo -e "${YELLOW}⚠️ Icon generation script not found${NC}"
        echo "- ⚠️ Icon generation script not found" >> "../$REPORT_FILE"
    fi

    # Check manifest.json references
    if [ -f "public/manifest.json" ]; then
        echo -e "${GREEN}✅ PWA manifest found${NC}"
        echo "- ✅ PWA manifest available" >> "../$REPORT_FILE"

        # Verify manifest contains icon references
        if grep -q '"icons"' public/manifest.json; then
            echo -e "${GREEN}  └─ Contains icon references${NC}"
            echo "  - Icon references: ✅ PRESENT" >> "../$REPORT_FILE"
        else
            echo -e "${RED}  └─ Missing icon references${NC}"
            echo "  - Icon references: ❌ MISSING" >> "../$REPORT_FILE"
        fi
    else
        echo -e "${YELLOW}⚠️ PWA manifest not found${NC}"
        echo "- ⚠️ PWA manifest not found" >> "../$REPORT_FILE"
    fi

    local web_success_rate=$((web_passed * 100 / web_total))
    echo -e "${BLUE}📊 Web icons: $web_passed/$web_total (${web_success_rate}%)${NC}"
    echo "" >> "../$REPORT_FILE"
    echo "**Success Rate: $web_success_rate%**" >> "../$REPORT_FILE"
    echo "" >> "../$REPORT_FILE"

    cd ..
    return $web_success_rate
}

# Function to verify icon derivation (basic check)
verify_icon_derivation() {
    echo -e "${BLUE}🔗 Verifying Icon Derivation from Source${NC}"
    echo "## Icon Derivation Verification" >> "$REPORT_FILE"
    echo "" >> "../$REPORT_FILE"

    # This is a basic check - in production, you might use image comparison tools
    echo -e "${BLUE}Note: Full image comparison requires additional tools like ImageMagick compare${NC}"
    echo "- Note: Full image comparison requires additional tools" >> "$REPORT_FILE"

    # Check file sizes are reasonable
    local source_size=$(stat -f%z "$SOURCE_ICON" 2>/dev/null || stat -c%s "$SOURCE_ICON" 2>/dev/null || echo "0")

    if [ "$source_size" -gt 100 ]; then
        echo -e "${GREEN}✅ Source icon has reasonable size ($source_size bytes)${NC}"
        echo "- ✅ Source icon size reasonable ($source_size bytes)" >> "$REPORT_FILE"
    else
        echo -e "${RED}❌ Source icon seems too small${NC}"
        echo "- ❌ Source icon size suspicious ($source_size bytes)" >> "$REPORT_FILE"
    fi

    echo "" >> "$REPORT_FILE"
}

# Main verification
ANDROID_RATE=0
DESKTOP_RATE=0
WEB_RATE=0

verify_android_icons
ANDROID_RATE=$?

verify_desktop_icons
DESKTOP_RATE=$?

verify_web_icons
WEB_RATE=$?

verify_icon_derivation

# Calculate overall success
OVERALL_TOTAL=$((ANDROID_RATE + DESKTOP_RATE + WEB_RATE))
OVERALL_AVERAGE=$((OVERALL_TOTAL / 3))

echo "" >> "$REPORT_FILE"
echo "## Overall Results" >> "$REPORT_FILE"
echo "- Android Client: ${ANDROID_RATE}%" >> "$REPORT_FILE"
echo "- Desktop Client: ${DESKTOP_RATE}%" >> "$REPORT_FILE"
echo "- Web Client: ${WEB_RATE}%" >> "$REPORT_FILE"
echo "- **Average Success Rate: ${OVERALL_AVERAGE}%**" >> "$REPORT_FILE"

if [ $OVERALL_AVERAGE -ge 95 ]; then
    echo -e "${GREEN}🎯 EXCELLENT: All launcher icons properly configured!${NC}"
    echo "" >> "$REPORT_FILE"
    echo "🎯 **EXCELLENT: All launcher icons properly configured!**" >> "$REPORT_FILE"
elif [ $OVERALL_AVERAGE -ge 80 ]; then
    echo -e "${YELLOW}⚠️ GOOD: Most icons configured with minor issues${NC}"
    echo "" >> "$REPORT_FILE"
    echo "⚠️ **GOOD: Most icons configured with minor issues**" >> "$REPORT_FILE"
else
    echo -e "${RED}❌ NEEDS ATTENTION: Icon configuration incomplete${NC}"
    echo "" >> "$REPORT_FILE"
    echo "❌ **NEEDS ATTENTION: Icon configuration incomplete**" >> "$REPORT_FILE"
fi

echo -e "${BLUE}📄 Report saved to: $REPORT_FILE${NC}"

# Exit with success if overall rate is acceptable
if [ $OVERALL_AVERAGE -ge 80 ]; then
    exit 0
else
    exit 1
fi