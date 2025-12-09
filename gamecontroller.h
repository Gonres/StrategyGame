#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include <QObject>

class GameController : public QObject
{
    Q_OBJECT
public:
    explicit GameController(QObject *parent = nullptr);

    bool isRunning() const;

signals:

private:
    bool m_running;
};

#endif // GAMECONTROLLER_H
