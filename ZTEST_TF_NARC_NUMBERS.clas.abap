
CLASS ztest_tf_narc_numbers DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA t_power_of_2 TYPE ztest_tf_tt_int .
    DATA t_power_of_3 TYPE ztest_tf_tt_int .
    DATA t_power_of_4 TYPE ztest_tf_tt_int .
    DATA t_power_of_5 TYPE ztest_tf_tt_int .
    DATA t_narc_numbers TYPE ztest_tf_tt_int .

    METHODS main_method .
    METHODS constructor .
    METHODS sum_of_powers
      IMPORTING
        !iv_number    TYPE int4
      RETURNING
        VALUE(re_sum) TYPE int4 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztest_tf_narc_numbers IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZTEST_TF_NARC_NUMBERS->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    DATA: lw_power   TYPE int4,
          lv_counter TYPE int1 VALUE 1.

    WHILE lv_counter LE 9.
      lw_power = lv_counter ** 2.
      APPEND lw_power TO t_power_of_2.

      lw_power = lv_counter ** 3.
      APPEND lw_power TO t_power_of_3.

      lw_power = lv_counter ** 4.
      APPEND lw_power TO t_power_of_4.

      lw_power = lv_counter ** 5.
      APPEND lw_power TO t_power_of_5.

      lv_counter = lv_counter + 1.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZTEST_TF_NARC_NUMBERS->MAIN_METHOD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD main_method.
    DATA(lv_counter) = 0.

    WHILE lv_counter LE 99999.
      IF lv_counter LT 10. "Append all 1 digit numbers as it is
        APPEND lv_counter TO t_narc_numbers.
      ELSE.
        CALL METHOD me->sum_of_powers
          EXPORTING
            iv_number = lv_counter    " Natural Number
          RECEIVING
            re_sum    = DATA(lv_sum).  " Natural Number
        IF lv_sum EQ lv_counter.
          APPEND lv_counter TO t_narc_numbers.
        ENDIF.
      ENDIF.
      lv_counter = lv_counter + 1.
    ENDWHILE.
    cl_demo_output=>display( t_narc_numbers ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZTEST_TF_NARC_NUMBERS->SUM_OF_POWERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NUMBER                      TYPE        INT4
* | [<-()] RE_SUM                         TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD sum_of_powers.
    DATA: lv_len_str TYPE char3,
          lv_power   TYPE i.

    FIELD-SYMBOLS: <fs_power_table> TYPE table.

    DATA(lv_len) = 0.
    DATA(lv_number1) = iv_number.
    WHILE lv_number1 > 0.
      lv_number1 = lv_number1 DIV 10.
      lv_len = lv_len + 1.
    ENDWHILE.

    lv_number1 = iv_number.
    lv_len_str = lv_len.
    CONDENSE lv_len_str.
    CONCATENATE 't_power_of_' lv_len_str INTO DATA(lv_table).
    ASSIGN (lv_table) TO <fs_power_table>.

    IF <fs_power_table> IS ASSIGNED.
      WHILE lv_number1 > 0.
        DATA(lv_rem) = lv_number1 MOD 10.
        lv_number1 = lv_number1 DIV 10.
        CLEAR: lv_power.
        READ TABLE <fs_power_table> INTO lv_power INDEX lv_rem.
        re_sum = re_sum + lv_power.
      ENDWHILE.
      UNASSIGN <fs_power_table>.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
