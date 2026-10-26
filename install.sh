#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
package_dir="$project_dir/org.kde.ksysguard.simpletext"
tool=${KPACKAGETOOL:-kpackagetool6}
install_root="${XDG_DATA_HOME:-$HOME/.local/share}/ksysguard/sensorfaces"

if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Install KDE Plasma 6 and kpackagetool6 first." >&2
    exit 1
fi

# --show also accepts source folders relative to the working directory, so it
# cannot tell us whether this package is installed.
if [ -d "$install_root/org.kde.ksysguard.simpletext" ]; then
    "$tool" --type KSysguard/SensorFace --packageroot "$install_root" --upgrade "$package_dir"
else
    "$tool" --type KSysguard/SensorFace --packageroot "$install_root" --install "$package_dir"
fi
echo 'Installed Simple Text. Reopen the System Monitor configuration and select Simple Text as the display style.'
