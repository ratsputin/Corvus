{FILEID: spoolm.pas }

    PROCEDURE listit;
      VAR
	xit: BOOLEAN;
	i : INTEGER;

      FUNCTION findptr(pnum : INTEGER): INTEGER;
	VAR
	  i, n : INTEGER;

	BEGIN
	  i := 0;
	  REPEAT
	    i := i+1;
	    n := ORD(pbuf.pt[i, 0]);
	  UNTIL ((n = pnum) OR (n = 63));
	  IF n=63
	    THEN
	      findptr := -1
	    ELSE
	      findptr := i;
	END;

      PROCEDURE display(i : INTEGER);
	VAR
	  j, k : INTEGER;
	BEGIN
	  j := findptr(i);
	  IF j > 0
	    THEN
	      BEGIN
		WRITE(i, '.   ');
		FOR k := 0 TO 7 DO
		  WRITE(nbuf.nm[i, k]);
		WRITE('    ');
		CASE ORD(pbuf.pt[j, 7]) OF
		  128: WRITE('Closed	---	Contains data');
		  129: WRITE('Open	Write	Contains data');
		  130: WRITE('Open	Read	Contains data');
		    1: WRITE('Open	Write	Empty	     ');
		    2: WRITE('Open	Read	Empty	     ');
		END {CASE};
		WRITELN;
	      END;
	END;

    BEGIN { listit }
      xit := statit(nbuf, pbuf);
      IF NOT(xit)
	THEN
	  BEGIN
	    WRITELN;
	    WRITELN('Active Pipes are: ');
	    FOR i := 1 TO 62 DO
	      IF nbuf.nm[i, 0] <> ' '
		THEN
		  display(i);
	  END;
    END;



PROCEDURE Dispatch;
    {This routine is used to prompt the user for a command, and to dispatch
     to the procedure to execute that command.}
    VAR
      xit: BOOLEAN;
      action: CHAR;

  BEGIN {Dispatch}
    xit := FALSE;
    WHILE NOT(xit) DO
      BEGIN
	writeln;
	WRITE('Spooler[',version,
	  ']: S(pool D(espool L(ist  Q(uit ');
	READ(action);
	WRITELN;
	IF action IN ['S','D','L','Q', '#' ] 
	  THEN
	    BEGIN
            CASE action OF
            'S' : Spoolit;
            'D' : Despoolit;
	    'L' : listit(**);
	    '#' : spldbug := NOT(spldbug);
            'Q' : xit := TRUE;
            END {CASE};
        END
      ELSE WRITE (beep);
      END;
  END;


  BEGIN { spooler }
    Initialize {variables, flags, tables, etc.};
    Dispatch;
  END.
