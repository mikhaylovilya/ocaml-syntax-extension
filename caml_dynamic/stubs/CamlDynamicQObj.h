#ifndef QDYNAMIC_H
#define QDYNAMIC_H

#include <caml/mlvalues.h>
#include <QtCore/QObject>
#include "dynamicqobject.h"

class CamlDynamicQObj : public DynamicQObject
{
    value _camlSlot;

public:
    CamlDynamicQObj(QObject *parent) : DynamicQObject(parent) {}
    DynamicSlot *createSlot(char *slot);
};

class CamlSlot : public DynamicSlot
{
public:
    CamlSlot(CamlDynamicQObj *parent) { Q_ASSERT(parent != 0); }
    void call(QObject *sender, void **arguments);
};

class Wrapper : public QObject
{
    Q_OBJECT
public:
    Wrapper(QObject *parent, CamlDynamicQObj *backend);

    Q_INVOKABLE bool callConnectDynamicSlot(QObject *obj, QString signal, QString slot);
    Q_INVOKABLE bool callConnectDynamicSignal(QString signal, QObject *obj, QString slot);

private:
    CamlDynamicQObj *backend;
};

#endif "QDYNAMIC_H"