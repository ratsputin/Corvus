!  9"�*  "" "#�%�  �  �  1�͊�͊1c͊�FO!V͖�=�ͦ�ÊL.HkBqVoI�RFQZ=�1��4>2)�+	͊�2��e�&�Ć!�
" !-1>2�O��"��	͊�	͊���	͊���	͊��>P2�
͊��)
͊Ϳ20K
͊�F����
͊(���̈́���!�
" !)͵q
͊͢�%�:1��4�
�1�
͊:2��	�1��4>	2)�͊�2��e�&�Ć!" �͊!)��20 ͵:���ʡͨ�4!��2ͲÊ͢�%�?��!!��2$Ͷ��!��2 Ͳá:*2&!% ͵��Ԣ�4��4!<" ͊!Ͳ!2"�͢��4*����4`͊�y���͊�yo�yg͵�͊>2���_�	�_�	�_
�_>@2�
�_
�_�4��4!U" ,͊!Ͳͨ�4!
ͲÇ~#� ^#V�##7�͢�%�?�!Ͳ!1"�ͥF͊�yo�yg͵v͊�y�y���͊�y�������Ê�͊�F�� �͊7�:1�������C:2O!J͖�;3͊:2���͊�%7���?�%�q�������͊:�G�yͥ�g�͊���*�~#"��������* �͊���Aw#x��!1�����v�"�� ~�M#x�µ����AG2��������͊�͑�͊7�̈́�-	�<�-	�<����x������[> �M���A2�G��x���z͊7�:����a�J*^"�:`2�*�",!  ".�:�����!Z����e!�" >�M:*�M���4!9� ͖!Z���6�	� ���͚���0�:ڥ�O����Y� �������0������������� ��/"���*�y��� æ æ���o& 0������!  ��F�� ���ͦ�0��
?�]T)))_ ��*�����?���F�Y�@�N�2<�ͦ���O�`�Q�_���͊�͊*����͊�F�1�k�5�k�02*22"æQ	͊��چ".m	͊��ڕ|�ʕ",�*.�*����	͊Æ�F�F ���N¿ͦx��N�#��/<��}�o|�g�:��
� *��:�_ "��!�~��N#~#��!16 #x����ͦ������ �-�<��<����� �A���������N����>�����<���� �[�A���[�  ��O�� �yy��ʔ�Aw#�y���
 --- CORVUS MIRROR UTILITY ---
       ( VERSION 1.32S/TT ) 
$
 --- MIRROR MENU ---

 L:  LIST THIS MENU
 H:  LIST HELP DATA
 B:  BACKUP 
 V:  VERIFY 
 I:  IDENTIFY
 R:  RESTORE 
 Q:  QUIT 
$
 TASK (L TO LIST) : $
 ->> THIS FEATURE IS NOT AVAILABLE UNDER VERS. 0 CONTROLLER CODE
$

 ** DISC R/W ERROR # $H **
$
 CORVUS DRIVE #  (1-4) ? $^C
$
 -- THIS WOULD EXCEED DISC SIZE --
$
 BACKUP ENTIRE CORVUS DISC (Y/N) ? $
 STARTING DISC BLOCK # ? $
      NUMBER OF BLOCKS ? $
 ** THIS WOULD EXCEED DISC SIZE **
$

 --- ENTER TAPE FILE HEADER INFORMATION ---
$
    DATE : $
    TIME : $
    NAME : $
 COMMENT : $
           $
 NORMAL OR FAST FORMAT (N/F) ? $
 STARTUP RECORDER AND PRESS RETURN $
 >> BACKUP HAS STARTED <<
$

 WAITING FOR RECORDER TO SPEED UP ...
$
 BACKUP IN PROGRESS ...
$
 BACKUP DONE -- NO DISC ERRORS
$
 THERE WERE $ DISC READ ERRORS DURING BACKUP $

 START RECORDER AT BEGINNING OF IMAGE

 VERIFY IN PROGRESS ...
$
 IMAGE ID NOT EQUAL TO 1
$
 ILLEGAL RESTORE COMMAND
$
ILLEGAL RETRY COMMAND
$
 IMAGE SIZE MISMATCH
$
 ILLEGAL COMMAND
$
 TIMEOUT - NO IMAGE FOUND
$
 TAPE DROPOUT DURING PLAYBACK
$
 MIRROR ERROR # $
 --- ERROR STATISTICS ---

 # SOFT ERRORS :$
 # DISC ERRORS :  $
 # OF BLOCKS NEEDING RETRYS :  $

 ALL DATA RECEIVED 
$
 -- RETRY NEEDED --
 START RECORDER AT BEGINNING OF IMAGE -- PRESS RETURN $
 POSITION TAPE AND START PLAYBACK 

 SEARCHING FOR IMAGE HEADER ...
$
 --- IMAGE RECORDED FROM CORVUS DRIVE ---

 IMAGE ID : $
 IMAGE LENGTH : $ BLOCKS 
$
  SYSTEM : $
 RESTORE ENTIRE DISC (Y/N) ? $

 POSITION TAPE AND START PLAYBACK 

 RESTORE IN PROGRESS ...
$CP/M            

     THIS PROGRAM PROVIDES THE BASIC CONTROL FUNCTIONS
 FOR THE CORVUS "MIRROR" DISC BACKUP SYSTEM.  IT WILL
 ONLY WORK ON SYSTEMS WITH CONTROLLER CODE VERSION > 0.
 FUNCTIONS PROVIDED ARE:

  B: BACKUP
     COPY A CONTIGUOUS SECTION OF INFORMATION ON THE
     CORVUS DRIVE ONTO A VIDEO TAPE FILE.
  V: VERIFY
     RE-READ A VIDEO TAPE FILE AND VERIFY THAT IT HAS
     BEEN RECORDED CORRECTLY.  THIS IS DONE BY TESTING
     THE  CRC  (A FORM OF CHECKSUM) OF EACH RECORD.
  I: IDENTIFY
     READ THE HEADER OF A VIDEO TAPE FILE AND LIST IT
     ON THE CONSOLE.
  R: RESTORE
     COPY A VIDEO TAPE FILE BACK TO THE CORVUS DRIVE.
     IT NEED NOT BE RESTORED TO THE SAME PLACE IT WAS 
     COPIED FROM.

  -  RETRY
     THIS FUNCTION IS BUILT IN TO THE  VERIFY  AND  RESTORE
     FUNCTIONS.  A RETRY WILL BE REQUESTED IF THE REDUNDANCY
     BUILT INTO "THE MIRROR" RECORDING FORMAT WAS NOT
     SUFFICIENT TO RECOVER FROM AN ERROR DETECTED IN ONE OR
     MORE TAPE RECORDS.  IN THIS CASE, THE ERROR STATISTICS
     WILL SHOW HOW MANY BLOCKS NEED RETRYS (NOTE: IF THIS
     NUMBER IS ZERO THEN ALL OF THE DATA WAS RECOVERED).

 A CONTROL - C ISSUED IN RESPONSE TO A PROMPT WILL CAUSE
 AN EXIT BACK TO CP/M.  A NON DECIMAL INPUT, IN RESPONSE
 TO A PROMPT REQUESTING A NUMBER, WILL CAUSE A REPEAT OF
 THE QUESTION ( CONTROL - C WILL ALWAYS CAUSE AN EXIT).
 THE ONLY NUMERICAL INPUTS REQUIRED ARE ALL IN DECIMAL.
 THE  BACKUP  AND  RESTORE  COMMANDS MAY ASK FOR THE
 " STARTING DISC BLOCK # " AND THE " # OF BLOCKS " 
 (IF YOU ARE NOT SAVING OR RESTORING AN ENTIRE DISC).
 THIS REFERS TO THE ACTUAL INTERNAL ORGANIZATION OF
 THE DRIVE - WHICH USES 512 BYTE SECTORS (BLOCKS).
 THE RELATION BETWEEN THE  BLOCK ADDRESS  
 AND THE USUAL  128 BYTE DISC ADDRESS  
 IS SIMPLE:

   DISC ADDRESS (128 BYTE) = 4 X BLOCK ADDRESS

 THIS MAY CAUSE A SLIGHT PROBLEM IF YOU WANT TO SAVE 
 OR RESTORE DISC DATA AT   DISC ADDRESSES (128 BYTE)
 THAT ARE NOT DIVISIBLE BY 4.  FOR REFERENCE,
 THE MAXIMUM BLOCK ADDRESS FOR VARIOUS CORVUS
 DRIVES ARE:

       18935   (REV A 10 MB DRIVE)
       21219   (REV B 10 MB DRIVE)
       38459   (REV B 20 MB DRIVE)
       11219   (REV B  5 MB DRIVE)

$THAT ARE NOT DIVIS
  
 
 
  ^�I 
,  H AI  	                                                                                     