#include "CamlDynamicQObj.h"

extern "C"
{
#include <caml/memory.h>
#include <caml/threads.h>
#include <caml/alloc.h>
#include <caml/callback.h>
}

CamlDynamicQObj::CamlDynamicQObj(QObject *parent) : DynamicQObject(parent) {}
DynamicSlot *CamlDynamicQObj::createSlot(char *slot)
{
    return new CamlSlot(this);
}

CamlSlot::CamlSlot(CamlDynamicQObj *parent)
{
    Q_ASSERT(parent != 0);
}
CamlSlot::CamlSlot(CamlDynamicQObj *parent, value _func) : _camlSlot(_func)
{
    Q_ASSERT(parent != 0);
}

void CamlSlot::call(QObject *sender, void **arguments) {}

CamlSlot::~CamlSlot()
{
    if (_camlSlot)
        caml_remove_global_root(&_camlSlot);
}

Wrapper::Wrapper(QObject *parent, CamlDynamicQObj *backend) : QObject(parent), backend(backend)
{
}
bool Wrapper::callConnectDynamicSlot(QObject *obj, QString signal, QString slot)
{
    QByteArray byteSignal = signal.toLocal8Bit();
    char *charSignal = byteSignal.data();
    QByteArray byteSlot = slot.toLocal8Bit();
    char *charSlot = byteSlot.data();
    return backend->connectDynamicSlot(obj, charSignal, charSlot);
}
bool Wrapper::callConnectDynamicSignal(QString signal, QObject *obj, QString slot)
{
    QByteArray byteSignal = signal.toLocal8Bit();
    char *charSignal = byteSignal.data();
    QByteArray byteSlot = slot.toLocal8Bit();
    char *charSlot = byteSlot.data();
    return backend->connectDynamicSignal(charSignal, obj, charSlot);
}

extern "C" value caml_create_camldynamicqobj(value _unit)
{
    CAMLparam1(_unit);
    CAMLlocal1(_ans);

    caml_enter_blocking_section();
    _ans = caml_alloc_small(1, Abstract_tag);
    *((CamlDynamicQObj **)&Field(_ans, 0)) = new CamlDynamicQObj(0);
    caml_leave_blocking_section();

    CAMLreturn(_ans);
}

extern "C" value caml_create_func(value _handler, value _name, value _func)
{
    CAMLparam3(_handler, _name, _func);
    CAMLreturn(Val_unit);
}