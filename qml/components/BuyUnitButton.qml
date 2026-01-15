import QtQuick
import QtQuick.Controls

Button {
    id: root

    property int unitType

    property var info: unitInfo.getInfo(root.unitType)

    text: info.icon + " " + info.name + " (" + info.price + "g)"
    height: 48
    checkable: true

    checked: controller.action.mode === ActionMode.Put
             && controller.action.chosenUnitType === root.unitType

    enabled: {
        return modelData.ownerId === controller.currentPlayerId
                && controller.currentGold >= info.price
                && controller.unitRepository.canCreate(
                    controller.currentPlayerId, root.unitType)
    }

    onClicked: {
        if (controller.action.mode === ActionMode.Put) {
            controller.action.mode = ActionMode.Move
            controller.action.chosenUnitType = UnitType.Warrior
        } else {
            controller.action.mode = ActionMode.Put
            controller.action.chosenUnitType = root.unitType
        }
    }
}
