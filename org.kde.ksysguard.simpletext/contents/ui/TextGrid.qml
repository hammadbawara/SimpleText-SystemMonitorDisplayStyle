// SPDX-License-Identifier: MIT
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

Item {
    id: root
    required property var controller
    readonly property var settings: controller.faceConfiguration
    readonly property int textAlignment: settings.alignment === 1 ? Text.AlignHCenter
        : settings.alignment === 2 ? Text.AlignRight : Text.AlignLeft

    implicitWidth: grid.implicitWidth
    implicitHeight: grid.implicitHeight
    clip: true

    GridLayout {
        id: grid
        objectName: "readingsGrid"
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        columns: Math.max(1, Math.min(root.settings.columns, readings.count || 1))
        rowSpacing: root.settings.rowSpacing
        columnSpacing: root.settings.columnSpacing

        Repeater {
            id: readings
            objectName: "readingsRepeater"
            model: root.controller.highPrioritySensorIds

            Item {
                id: cell
                required property string modelData
                Layout.fillWidth: true
                Layout.minimumWidth: root.settings.stableWidth ? implicitWidth : 0
                implicitWidth: root.settings.stableWidth ? reservedMetrics.advanceWidth : naturalMetrics.advanceWidth
                implicitHeight: reading.implicitHeight

                Controls.Label {
                    id: reading
                    objectName: "sensorReading"
                    anchors.fill: parent
                    textFormat: Text.PlainText
                    wrapMode: Text.NoWrap
                    elide: root.settings.showEllipsis ? Text.ElideRight : Text.ElideNone
                    clip: true
                    Controls.ToolTip.visible: hover.hovered && (truncated || naturalMetrics.advanceWidth > width)
                    Controls.ToolTip.text: text
                    Controls.ToolTip.delay: 700
                    HoverHandler { id: hover }
                    horizontalAlignment: root.textAlignment
                    font.family: root.settings.monospace ? "monospace"
                        : (root.settings.fontFamily || Kirigami.Theme.defaultFont.family)
                    font.pointSize: root.settings.fontSize > 0 ? root.settings.fontSize : Kirigami.Theme.defaultFont.pointSize
                    font.bold: root.settings.bold
                    font.italic: root.settings.italic
                    font.underline: root.settings.underline
                    font.letterSpacing: root.settings.letterSpacing
                    color: root.settings.useSensorColors && root.controller.sensorColors[cell.modelData]
                        ? root.controller.sensorColors[cell.modelData]
                        : (/^#[0-9a-fA-F]{6}$/.test(root.settings.textColor) ? root.settings.textColor : Kirigami.Theme.textColor)
                    text: {
                        const values = {
                            "value": sensor.formattedValue || "—",
                            "name": root.controller.sensorLabels[cell.modelData] || sensor.name || cell.modelData
                        };
                        return root.settings.textFormat.replace(/\{(value|name)\}/g, (match, token) => values[token]);
                    }
                }

                Sensors.Sensor {
                    id: sensor
                    sensorId: cell.modelData
                    updateRateLimit: root.controller.updateRateLimit
                }

                TextMetrics {
                    id: reservedMetrics
                    font: reading.font
                    text: "0".repeat(Math.max(1, root.settings.widthCharacters))
                }

                TextMetrics {
                    id: naturalMetrics
                    font: reading.font
                    text: reading.text
                }
            }
        }
    }
}
