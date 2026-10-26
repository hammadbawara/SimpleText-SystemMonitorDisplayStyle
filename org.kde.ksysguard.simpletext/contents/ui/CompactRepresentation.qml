// SPDX-License-Identifier: MIT
import QtQuick
import QtQuick.Layouts
import org.kde.ksysguard.faces as Faces

Faces.SensorFace {
    id: root
    Layout.minimumWidth: contentItem.implicitWidth
    Layout.minimumHeight: contentItem.implicitHeight
    Layout.preferredWidth: contentItem.implicitWidth
    Layout.preferredHeight: contentItem.implicitHeight

    contentItem: TextGrid {
        controller: root.controller
    }
}
