#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include <QObject>

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningNotify)

public:
    explicit GameController(QObject *parent = nullptr);

    bool isRunning() const;

    Q_INVOKABLE void startGame();

signals:
    void isRunningNotify();

private:
    bool m_running;
};

#endif // GAME_CONTROLLER_H
