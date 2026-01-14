#ifndef ACTION_MODE_H
#define ACTION_MODE_H

#include <QObject>

namespace ActionMode {
Q_NAMESPACE

enum Mode {
    Move,
    Attack,
    Build,
    Train,
    PlaceStronghold
};
Q_ENUM_NS(Mode)
}

#endif // ACTION_MODE_H
