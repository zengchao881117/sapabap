CLASS zgca_parameter_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zgca_parameter_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( zgca_parameter=>get_value( iv_module = 'FI' iv_application = 'FI0001' iv_parameter = 'P1001' ) ).

    out->write( zgca_parameter=>get_range( iv_module = 'FI' iv_application = 'FI0001' iv_parameter = 'P1001' ) ).

    out->write( zgca_parameter=>get_table( iv_module = 'FI' iv_application = 'FI0001' iv_parameter = 'P1001' ) ).

  ENDMETHOD.
ENDCLASS.
