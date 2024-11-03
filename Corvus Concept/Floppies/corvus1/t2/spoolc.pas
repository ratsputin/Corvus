{ File ID: SPOOLC.PAS  }
{	This file contains all of the routines that are specific} 
{ to the  CP/M enviroment.					}

EXTERNAL FUNCTION pipestatus (VAR names, ptrs: BLOCK): INTEGER;
EXTERNAL FUNCTION pipeord (pname: STRING): INTEGER;                        
EXTERNAL FUNCTION pipeowr (pname: STRING): INTEGER;                        
EXTERNAL FUNCTION pipecrd (npipe: INTEGER): INTEGER;                       
EXTERNAL FUNCTION pipecwr (npipe: INTEGER): INTEGER;                       
EXTERNAL FUNCTION piperead (npipe: INTEGER; VAR info: BLOCK): INTEGER;     
EXTERNAL FUNCTION pipewrite (npipe, wlen: INTEGER; info: BLOCK): INTEGER;  
EXTERNAL PROCEDURE pmodinit;

EXTERNAL FUNCTION @BDOS( func: INTEGER; parm: WORD): INTEGER;
    
FUNCTION beep: CHAR;
  BEGIN
    beep := CHR(BELL);
  END;

			{ Readstring and Writestring have been }
			{ used to allow compatibility with LSI-}
			{ OREGON SOFTWARE pascal	       }
PROCEDURE ReadString( VAR s: STRING );
  BEGIN
    READLN(s);
  END;

PROCEDURE WriteString( s: STRING );
  BEGIN
    WRITE(s);
  END;


FUNCTION keypress(**) : BOOLEAN;
  CONST
    CONSTAT = 11;
    CONIN  = 1;
  VAR
    i : INTEGER;
  BEGIN
    IF @BDOS(CONSTAT, WRD(0)) <> 0
      THEN
	BEGIN
	  i := @BDOS(CONIN, WRD(0));
 	  keypress := TRUE;
	END
      ELSE
	keypress := FALSE;
  END;

PROCEDURE  INITIALIZE;
  BEGIN
    pmodinit;
    coname := 'CON:';
    lprname := 'LST:';
    spldbug := FALSE;
  END;



	      { bufrd
		Read a record.  If result <> 0 then the last 
		record has already been read.  So if the file
		is a text file then find CPMEOF marker in the
		previously read record and set nbcnt to this
		value.
	      }
FUNCTION bufrd( VAR f: BUFILE): BOOLEAN;
    VAR
      endf : BOOLEAN;
      ior : INTEGER;
      i   : INTEGER;
  BEGIN
    SEEKREAD(f, recnt);
    recnt := recnt + BUFBLKS;
    ior := IORESULT(**);
    endf := (ior <> 0);
    IF endf
      THEN
	BEGIN
	  IF spldbug = TRUE
	    THEN
	      WRITELN(' READ RETURN CODE:  ', ior);
	  IF ftype <> NONTXT
	    THEN
	      BEGIN
		i := 0;
		WHILE ((i < nbcnt) AND
		       (ORD(nbuf.txt[i]) <> CPMEOF)) DO
			i := i + 1;
		nbcnt := i;
	      END;
	END;
    bufrd := endf;
  END;

FUNCTION bufwrt( VAR f: BUFILE): INTEGER;
    VAR
      ior: INTEGER;
  BEGIN
    SEEKWRITE(f, recnt);
    recnt := recnt + BUFBLKS;
    ior := IORESULT(**);
    IF ior = FILERR
      THEN
	WRITELN('FILE WRITE ERROR: ', ior);
    bufwrt := ior;
  END;


    FUNCTION rstbufile( VAR f : BUFILE; name : STRING): INTEGER;
      BEGIN
	ASSIGN(f, name);
	RESET(f);
	rstbufile := IORESULT(**);
      END;

    FUNCTION rstxtfile( VAR f : TEXT; name : STRING): INTEGER;
      BEGIN
	ASSIGN(f, name);
	RESET(f);
	rstxtfile := IORESULT(**);
      END;

    FUNCTION rwrtxtfile( VAR f : TEXT; name : STRING): INTEGER;
      BEGIN
	ASSIGN(f, name);
	REWRITE(f);
	rwrtxtfile := IORESULT(**);
      END;

    FUNCTION rwrtbufile( VAR f : BUFILE; name : STRING): INTEGER;
      BEGIN
	ASSIGN(f, name);
	REWRITE(f);
	rwrtbufile := IORESULT(**);
      END;

    FUNCTION closbufile( VAR f: BUFILE ): INTEGER;
      VAR
	result : INTEGER;
      BEGIN
	CLOSE( f, result);
	closbufile := result;
      END;

    FUNCTION closbfile( VAR f: BFILE ): INTEGER;
      VAR
	result : INTEGER;
      BEGIN
	CLOSE( f, result);
	closbfile := result;
      END;

    FUNCTION clostxtfile( VAR f: TEXT ): INTEGER;
      VAR
	result : INTEGER;
      BEGIN
	CLOSE( f, result);
	clostxtfile := result;
      END;

