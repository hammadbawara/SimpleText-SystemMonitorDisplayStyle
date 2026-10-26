// SPDX-License-Identifier: MIT
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: root
    readonly property real contentPadding: Kirigami.Units.largeSpacing
    readonly property real maximumContentWidth: Kirigami.Units.gridUnit * 32

    Layout.fillWidth: true
    implicitWidth: maximumContentWidth + contentPadding * 2
    implicitHeight: settingsContent.implicitHeight + contentPadding * 2

    property alias cfg_columns: columns.value
    property alias cfg_rowSpacing: rowSpacing.value
    property alias cfg_columnSpacing: columnSpacing.value
    property alias cfg_fontSize: fontSize.value
    property alias cfg_bold: bold.checked
    property alias cfg_monospace: monospace.checked
    property alias cfg_alignment: alignment.currentIndex
    property alias cfg_useSensorColors: sensorColors.checked
    property alias cfg_textFormat: textFormat.text
    property alias cfg_stableWidth: stableWidth.checked
    property alias cfg_widthCharacters: widthCharacters.value
    property alias cfg_showEllipsis: showEllipsis.checked
    property alias cfg_fontFamily: fontFamily.text
    property alias cfg_italic: italic.checked
    property alias cfg_underline: underline.checked
    property alias cfg_letterSpacing: letterSpacing.value
    property alias cfg_textColor: textColor.text

    ColumnLayout {
        id: settingsContent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.contentPadding
        width: Math.min(root.maximumContentWidth, Math.max(0, root.width - root.contentPadding * 2))
        spacing: Kirigami.Units.largeSpacing

        Controls.TabBar {
            id: tabs
            objectName: "settingsTabs"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Math.min(settingsContent.width, Kirigami.Units.gridUnit * 20)
            Controls.TabButton { text: i18n("Layout") }
            Controls.TabButton { text: i18n("Text") }
            Controls.TabButton { text: i18n("Appearance") }
        }

        StackLayout {
            Layout.fillWidth: true
            currentIndex: tabs.currentIndex

            Kirigami.FormLayout {
                wideMode: width >= Kirigami.Units.gridUnit * 24
                Controls.SpinBox {
                    id: columns
                    Kirigami.FormData.label: i18n("Columns:")
                    from: 1
                    to: 16
                    editable: true
                    Controls.ToolTip.text: i18n("1 stacks readings; 2 places them side by side.")
                    Controls.ToolTip.visible: hovered
                }
                Controls.CheckBox {
                    id: stableWidth
                    text: i18n("Keep width fixed")
                }
                Controls.SpinBox {
                    id: widthCharacters
                    Kirigami.FormData.label: i18n("Reading width (chars):")
                    enabled: stableWidth.checked
                    from: 1
                    to: 80
                    editable: true
                    Controls.ToolTip.text: i18n("Space reserved for each reading, measured in zero characters using your font.")
                    Controls.ToolTip.visible: hovered
                }
                Controls.CheckBox {
                    id: showEllipsis
                    text: i18n("Show … when text is cut off")
                }
                Controls.ComboBox {
                    id: alignment
                    Kirigami.FormData.label: i18n("Text alignment:")
                    model: [i18n("Left"), i18n("Center"), i18n("Right")]
                }
                Controls.SpinBox {
                    id: rowSpacing
                    Kirigami.FormData.label: i18n("Between rows (px):")
                    from: 0
                    to: 100
                    editable: true
                }
                Controls.SpinBox {
                    id: columnSpacing
                    Kirigami.FormData.label: i18n("Between columns (px):")
                    from: 0
                    to: 100
                    editable: true
                }
            }

            Kirigami.FormLayout {
                wideMode: width >= Kirigami.Units.gridUnit * 24
                Controls.TextField {
                    id: textFormat
                    Kirigami.FormData.label: i18n("Text format:")
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 14
                    placeholderText: "{value}"
                    Controls.ToolTip.text: i18n("Example: {name}: {value}. Change sensor labels in Sensors settings.")
                    Controls.ToolTip.visible: hovered
                }
                Controls.Label {
                    Layout.fillWidth: true
                    text: i18n("{value} = reading + unit\n{name} = sensor label")
                    Layout.maximumWidth: Kirigami.Units.gridUnit * 16
                    wrapMode: Text.WordWrap
                }
            }

            Kirigami.FormLayout {
                wideMode: width >= Kirigami.Units.gridUnit * 24
                Controls.CheckBox {
                    id: monospace
                    text: i18n("Use monospace font")
                }
                Controls.TextField {
                    id: fontFamily
                    Kirigami.FormData.label: i18n("Font family:")
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 14
                    enabled: !monospace.checked
                    placeholderText: i18n("System font")
                }
                Controls.SpinBox {
                    id: fontSize
                    Kirigami.FormData.label: i18n("Size (pt, 0 = system):")
                    from: 0
                    to: 96
                    editable: true
                }
                RowLayout {
                    Kirigami.FormData.label: i18n("Style:")
                    Controls.CheckBox { id: bold; text: i18n("Bold") }
                    Controls.CheckBox { id: italic; text: i18n("Italic") }
                    Controls.CheckBox { id: underline; text: i18n("Underline") }
                }
                Controls.SpinBox {
                    id: letterSpacing
                    Kirigami.FormData.label: i18n("Letter spacing (px):")
                    from: 0
                    to: 10
                    editable: true
                }
                Controls.CheckBox {
                    id: sensorColors
                    text: i18n("Use sensor colors")
                }
                Controls.TextField {
                    id: textColor
                    Kirigami.FormData.label: i18n("Custom color:")
                    enabled: !sensorColors.checked
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 14
                    placeholderText: i18n("System or #RRGGBB")
                    validator: RegularExpressionValidator { regularExpression: /#[0-9a-fA-F]{6}|^$/ }
                }
            }
        }
    }
}
