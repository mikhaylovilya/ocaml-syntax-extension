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

CamlSlot::CamlSlot(CamlDynamicQObj *parent) : _camlSlot(0)
{
    // Q_ASSERT(false);
    Q_ASSERT(parent != 0);
    // printf("%s %d this = %p\n", __FILE__, __LINE__, this);
    // fflush(stdout);
    // caml_register_global_root(&_camlSlot);
}
CamlSlot::CamlSlot(CamlDynamicQObj *parent, value _func)
// : _camlSlot(_func)
{
    Q_ASSERT(parent != 0);

    // printf("%s %d this = %p\n", __FILE__, __LINE__, this);
    // fflush(stdout);

    // printf("%p\n", _func);
    // fflush(stdout);

    _camlSlot = _func;
    // printf("%s %d _camlSlot = %p\n", __FILE__, __LINE__, _camlSlot);
    // fflush(stdout);
}

void CamlSlot::call(QObject *sender, void **arguments)
{
    // qDebug("call");
    // printf("%p\n", _camlSlot);
    // fflush(stdout);
    Q_ASSERT(Tag_val(_camlSlot) == Closure_tag);

    caml_leave_blocking_section();
    caml_callback(_camlSlot, Val_unit);
    caml_enter_blocking_section();
}

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

// extern "C" value caml_create_camldynamicqobj(value _unit)
// {
//     CAMLparam1(_unit);
//     CAMLlocal1(_ans);

//     caml_enter_blocking_section();
//     _ans = caml_alloc_small(1, Abstract_tag);
//     //*((CamlDynamicQObj **)&Field(_ans, 0)) = new CamlDynamicQObj(0);
//     CamlDynamicQObj *camlObj = new CamlDynamicQObj(0);
//     *((Wrapper **)&Field(_ans, 0)) = new Wrapper(0, camlObj);
//     caml_leave_blocking_section();

//     CAMLreturn(_ans);
// }

extern "C" value caml_create_func(value _name, value _func)
{
    CAMLparam2(_name, _func);
    CAMLlocal1(_ans);

    Q_ASSERT(Tag_val(_func) == Closure_tag);
    // qDebug("%d", Wosize_val(_func));
    // caml_callback(_func, Val_unit);

    caml_register_global_root(&_func);
    caml_enter_blocking_section();
    _ans = caml_alloc_small(1, Abstract_tag);
    //*((CamlDynamicQObj **)&Field(_ans, 0)) = new CamlDynamicQObj(0);
    CamlDynamicQObj *camlObj = new CamlDynamicQObj(nullptr);

    // printf("%p\n", _func);
    // fflush(stdout);

    CamlSlot *camlSlot = new CamlSlot(camlObj, _func);
    QString slotSignature = QString(String_val(_name));
    camlObj->addCustomSlot(slotSignature, camlSlot);
    *((Wrapper **)&Field(_ans, 0)) = new Wrapper(0, camlObj);

    caml_leave_blocking_section();
    // qDebug("caml_create_func");

    CAMLreturn(_ans);
}