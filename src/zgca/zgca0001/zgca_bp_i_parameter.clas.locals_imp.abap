CLASS lhc_ZGCA_I_PARAMETER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zgca_i_parameter RESULT result.

ENDCLASS.

CLASS lhc_ZGCA_I_PARAMETER IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
