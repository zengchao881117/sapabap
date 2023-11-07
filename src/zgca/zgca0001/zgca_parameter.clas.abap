CLASS zgca_parameter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_range,
           sign TYPE ddsign,
           option TYPE ddoption,
           low TYPE zge_low,
           high TYPE zge_high,
           END OF ty_range,

           tty_range TYPE STANDARD TABLE OF ty_range WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_table,
             module      TYPE zge_module,
             application TYPE zge_application,
             parameter   TYPE zge_parameter,
             itemno      TYPE zge_itemno,
             sign        TYPE zge_sign,
             option      TYPE zge_option,
             low         TYPE zge_low,
             high        TYPE zge_high,
           END OF ty_table,

           tty_table TYPE STANDARD TABLE OF ty_table WITH DEFAULT KEY.

    CLASS-METHODS: get_value
      IMPORTING
        iv_module      TYPE zge_module
        iv_application TYPE zge_application
        iv_parameter   TYPE zge_parameter
      RETURNING
         VALUE(ev_value)       TYPE zge_low
      EXCEPTIONS
        not_found .



    CLASS-METHODS: get_table
      IMPORTING
        iv_module      TYPE zge_module
        iv_application TYPE zge_application
        iv_parameter   TYPE zge_parameter
      RETURNING
         value(et_table)  TYPE tty_table
      EXCEPTIONS
        not_found.

    CLASS-METHODS: get_range
      IMPORTING
        iv_module      TYPE zge_module
        iv_application TYPE zge_application
        iv_parameter   TYPE zge_parameter
      RETURNING
         VALUE(et_range)  TYPE tty_range
      EXCEPTIONS
        not_found.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zgca_parameter IMPLEMENTATION.

  METHOD get_range.

        SELECT    sign,
                   zoption as option,
                   low ,
                   high
            FROM zgca_r_parameter
            WHERE moduleid = @iv_module
             AND application = @iv_application
             AND parameterid = @iv_parameter
             ORDER BY itemno
            INTO CORRESPONDING FIELDS OF TABLE @et_range[].

         return et_range[].

  ENDMETHOD.

  METHOD get_table.
    SELECT moduleid as module,
           application ,
           parameterid as parameter,
           itemno ,
           sign,
           zoption as option,
           low ,
           high
    FROM zgca_r_parameter
    WHERE moduleid = @iv_module
     AND application = @iv_application
     AND parameterid = @iv_parameter
    ORDER BY moduleid ,application ,parameterid ,itemno
    INTO TABLE @et_table[] .

    return et_table[].

  ENDMETHOD.

  METHOD get_value.
    SELECT moduleid as module,
           application ,
           parameterid as parameter,
           itemno ,
           sign,
           zoption as option,
           low ,
           high
    FROM zgca_r_parameter
    WHERE moduleid = @iv_module
     AND application = @iv_application
     AND parameterid = @iv_parameter
    INTO TABLE @DATA(lt_data) .

    if sy-subrc <> 0.
      RAISE not_found.
    else.
         SORT lt_data by module  application parameter itemno.
         READ TABLE lt_data INTO DATA(ls_data) INDEX 1.
         if sy-subrc = 0.
            ev_value = ls_data-low.
         else.
            raise not_found.
         ENDIF.
    ENDIF.

    return ev_value.

  ENDMETHOD.

ENDCLASS.
