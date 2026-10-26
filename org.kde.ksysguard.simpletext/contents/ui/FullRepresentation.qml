// SPDX-License-Identifier: MIT
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.ksysguard.faces as Faces

Faces.SensorFace {
    id: root
    Layout.minimumWidth: readings.implicitWidth
    Layout.minimumHeight: contentItem.implicitHeight

    contentItem: ColumnLayout {
        spacing: 4

        Controls.Label {
            Layout.fillWidth: true
            visible: root.controller.showTitle && text.length > 0
            text: root.controller.title
            textFormat: Text.PlainText
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        TextGrid {
            id: readings
            Layout.fillWidth: true
            Layout.fillHeight: true
            controller: root.controller
        }
    }
}
